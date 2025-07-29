import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/database/local_database.dart';
import 'package:sigapp/grade_simulator/domain/sync_constants.dart';
import 'package:sigapp/grade_simulator/domain/value_objects/sync_value_objects.dart';
import 'package:sigapp/grade_simulator/infrastructure/dtos/sync_reporting_dtos.dart';

/// Repository for managing sync queue operations
/// Handles all SQLite operations related to the sync_queue table
@singleton
class SyncQueueRepository {
  final LocalDatabase _database;
  final Logger _logger;

  SyncQueueRepository(this._database, this._logger);

  /// Generic helper for logging and error handling
  Future<T> _withLog<T>(
    String operation,
    Future<T> Function() fn, [
    T? defaultValue,
  ]) async {
    _logger.d('[DRIFT_SYNC] $operation...');
    try {
      final result = await fn();
      _logger.d('[DRIFT_SYNC] ✅ $operation');
      return result;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error $operation: $e');
      if (defaultValue != null) {
        return defaultValue;
      }
      rethrow;
    }
  }

  /// Get pending sync operations
  Future<List<SyncQueueData>> getPendingOperations({
    int maxRetryCount = defaultMaxRetryCount,
  }) async {
    return _withLog('Getting pending operations', () async {
      final query =
          _database.select(_database.syncQueue)
            ..where(
              (tbl) =>
                  tbl.status.equals(SyncStatus.pending.value) &
                  tbl.retryCount.isSmallerThanValue(maxRetryCount),
            )
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]);

      final results = await query.get();
      _logger.d('[DRIFT_SYNC] Found ${results.length} pending operations');
      return results;
    }, <SyncQueueData>[]);
  }

  /// Persist a sync operation with deduplication (UPSERT pattern)
  /// ✅ OPTIMIZED: One operation per course maximum (Opción C - Simple)
  Future<void> persistOperation({
    required String operationType,
    required String fieldType,
    required String entityKey,
    required Map<String, dynamic> operationData,
    String entityType = 'course_grade_simulator',
  }) async {
    try {
      await _withLog(
        'Persisting operation (UPSERT): $operationType for $entityKey',
        () async {
          await _database.transaction(() async {
            // 🚀 DEDUPLICATION: Delete existing pending operation for this course
            await (_database.delete(_database.syncQueue)..where(
              (tbl) =>
                  tbl.entityKey.equals(entityKey) &
                  tbl.status.equals(SyncStatus.pending.value),
            )).go();

            // Insert new operation (replaces any existing one)
            await _database
                .into(_database.syncQueue)
                .insert(
                  SyncQueueCompanion(
                    operationType: Value(operationType),
                    entityType: Value(entityType),
                    entityKey: Value(entityKey),
                    fieldName: Value(fieldType),
                    operationData: Value(jsonEncode(operationData)),
                    timestamp: Value(DateTime.now().millisecondsSinceEpoch),
                    retryCount: const Value(0),
                    status: Value(SyncStatus.pending.value),
                  ),
                );
          });
        },
      );
    } catch (e) {
      // No crítico - continuar sin persistencia
      _logger.w(
        '[DRIFT_SYNC] Non-critical error persisting operation (UPSERT): $e',
      );
    }
  }

  /// Update operation status
  Future<void> updateOperationStatus({
    required int operationId,
    required String status,
    int? retryCount,
  }) async {
    await _withLog(
      'Updating operation $operationId status to: $status',
      () async {
        final companion = SyncQueueCompanion(
          status: Value(status),
          retryCount:
              retryCount != null ? Value(retryCount) : const Value.absent(),
        );

        await (_database.update(_database.syncQueue)
          ..where((tbl) => tbl.id.equals(operationId))).write(companion);
      },
    );
  }

  /// Mark operation as synced
  Future<void> markAsSynced(int operationId) async {
    await updateOperationStatus(
      operationId: operationId,
      status: SyncStatus.synced.value,
    );
  }

  /// Mark operation as failed
  Future<void> markAsFailed(int operationId, int retryCount) async {
    await updateOperationStatus(
      operationId: operationId,
      status:
          retryCount >= defaultMaxRetryCount
              ? SyncStatus.failed.value
              : SyncStatus.pending.value,
      retryCount: retryCount,
    );
  }

  /// Clean up completed operations
  Future<void> cleanupCompletedOperations({
    Duration retentionPeriod = const Duration(hours: 24),
  }) async {
    await _withLog(
      'Cleaning up completed operations older than $retentionPeriod',
      () async {
        final cutoffTime =
            DateTime.now().subtract(retentionPeriod).millisecondsSinceEpoch;

        final deletedCount =
            await (_database.delete(_database.syncQueue)..where(
              (tbl) =>
                  tbl.status.equals(SyncStatus.synced.value) &
                  tbl.timestamp.isSmallerThanValue(cutoffTime),
            )).go();

        if (deletedCount > 0) {
          _logger.d(
            '[DRIFT_SYNC] Cleaned up $deletedCount completed operations',
          );
        }
      },
    );
  }

  /// Clean up failed operations (older than retention period)
  Future<void> cleanupFailedOperations({
    Duration retentionPeriod = const Duration(days: 7),
  }) async {
    await _withLog(
      'Cleaning up failed operations older than $retentionPeriod',
      () async {
        final cutoffTime =
            DateTime.now().subtract(retentionPeriod).millisecondsSinceEpoch;

        final deletedCount =
            await (_database.delete(_database.syncQueue)..where(
              (tbl) =>
                  tbl.status.equals(SyncStatus.failed.value) &
                  tbl.timestamp.isSmallerThanValue(cutoffTime),
            )).go();

        if (deletedCount > 0) {
          _logger.d('[DRIFT_SYNC] Cleaned up $deletedCount failed operations');
        }
      },
    );
  }

  /// Get sync queue statistics
  Future<QueueStats> getQueueStats() async {
    return _withLog('Getting queue statistics', () async {
      final query = _database.customSelect(
        '''
        SELECT 
          status,
          COUNT(*) as count
        FROM sync_queue 
        GROUP BY status
        ''',
        readsFrom: {_database.syncQueue},
      );

      final results = await query.get();
      int pending = 0, synced = 0, failed = 0;

      for (final row in results) {
        final status = row.data['status'] as String;
        final count = row.data['count'] as int;

        switch (status) {
          case 'pending':
            pending = count;
            break;
          case 'synced':
            synced = count;
            break;
          case 'failed':
            failed = count;
            break;
        }
      }

      final stats = QueueStats(
        pending: pending,
        synced: synced,
        failed: failed,
      );
      _logger.d('[DRIFT_SYNC] Queue stats: $stats');
      return stats;
    }, QueueStats.empty());
  }

  /// Get operations by entity key (useful for debugging)
  Future<List<SyncQueueData>> getOperationsByEntityKey(String entityKey) async {
    return _withLog('Getting operations for entity: $entityKey', () async {
      final query =
          _database.select(_database.syncQueue)
            ..where((tbl) => tbl.entityKey.equals(entityKey))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])
            ..limit(10); // Last 10 operations

      final results = await query.get();
      _logger.d(
        '[DRIFT_SYNC] Found ${results.length} operations for entity: $entityKey',
      );
      return results;
    }, <SyncQueueData>[]);
  }

  /// Delete all operations for a specific entity (useful for cleanup)
  Future<void> deleteOperationsByEntityKey(String entityKey) async {
    await _withLog('Deleting operations for entity: $entityKey', () async {
      final deletedCount =
          await (_database.delete(_database.syncQueue)
            ..where((tbl) => tbl.entityKey.equals(entityKey))).go();

      _logger.d(
        '[DRIFT_SYNC] Deleted $deletedCount operations for entity: $entityKey',
      );
    });
  }

  // 🚀 NUEVAS FUNCIONALIDADES DRIFT-ESPECÍFICAS

  /// Batch mark multiple operations as synced (optimized)
  Future<void> batchMarkAsSynced(List<int> operationIds) async {
    if (operationIds.isEmpty) return;

    await _withLog(
      'Batch marking ${operationIds.length} operations as synced',
      () async {
        await _database.transaction(() async {
          for (final id in operationIds) {
            await (_database.update(_database.syncQueue)
              ..where((tbl) => tbl.id.equals(id))).write(
              SyncQueueCompanion(status: Value(SyncStatus.synced.value)),
            );
          }
        });
      },
    );
  }

  /// Batch persist multiple operations (transactional)
  Future<void> batchPersistOperations(List<SyncOperation> operations) async {
    if (operations.isEmpty) return;

    await _withLog(
      'Batch persisting ${operations.length} operations',
      () async {
        await _database.transaction(() async {
          for (final op in operations) {
            await _database
                .into(_database.syncQueue)
                .insert(
                  SyncQueueCompanion(
                    operationType: Value(op.operationType),
                    entityType: Value(op.entityType),
                    entityKey: Value(op.entityKey),
                    fieldName: Value(op.fieldType),
                    operationData: Value(jsonEncode(op.operationData)),
                    timestamp: Value(DateTime.now().millisecondsSinceEpoch),
                    retryCount: const Value(0),
                    status: Value(SyncStatus.pending.value),
                  ),
                );
          }
        });
      },
    );
  }

  /// Get operations by type (useful for analytics)
  Future<List<SyncQueueData>> getOperationsByType(String operationType) async {
    return _withLog('Getting operations by type: $operationType', () async {
      final query =
          _database.select(_database.syncQueue)
            ..where((tbl) => tbl.operationType.equals(operationType))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)]);

      final results = await query.get();
      _logger.d(
        '[DRIFT_SYNC] Found ${results.length} operations of type: $operationType',
      );
      return results;
    }, <SyncQueueData>[]);
  }

  /// Get failed operations (useful for retry logic)
  Future<List<SyncQueueData>> getFailedOperations() async {
    return _withLog('Getting failed operations', () async {
      final query =
          _database.select(_database.syncQueue)
            ..where((tbl) => tbl.status.equals(SyncStatus.failed.value))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)]);

      final results = await query.get();
      _logger.d('[DRIFT_SYNC] Found ${results.length} failed operations');
      return results;
    }, <SyncQueueData>[]);
  }

  /// Get recent operations within time window
  Future<List<SyncQueueData>> getRecentOperations({
    Duration timeWindow = const Duration(hours: 1),
  }) async {
    return _withLog('Getting recent operations within $timeWindow', () async {
      final cutoffTime =
          DateTime.now().subtract(timeWindow).millisecondsSinceEpoch;

      final query =
          _database.select(_database.syncQueue)
            ..where((tbl) => tbl.timestamp.isBiggerThanValue(cutoffTime))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)]);

      final results = await query.get();
      _logger.d('[DRIFT_SYNC] Found ${results.length} recent operations');
      return results;
    }, <SyncQueueData>[]);
  }

  /// Get detailed queue statistics with breakdown by type
  Future<DetailedQueueStatistics> getDetailedQueueStatistics() async {
    return _withLog(
      'Getting detailed queue statistics',
      () async {
        // Status breakdown
        final statusQuery = _database.customSelect(
          '''
        SELECT 
          status,
          COUNT(*) as count,
          AVG(retry_count) as avg_retry_count
        FROM sync_queue 
        GROUP BY status
        ''',
          readsFrom: {_database.syncQueue},
        );

        // Operation type breakdown
        final typeQuery = _database.customSelect(
          '''
        SELECT 
          operation_type,
          COUNT(*) as count,
          status
        FROM sync_queue 
        GROUP BY operation_type, status
        ''',
          readsFrom: {_database.syncQueue},
        );

        final statusResults = await statusQuery.get();
        final typeResults = await typeQuery.get();

        final statusBreakdown = <String, StatusBreakdown>{};
        int totalOperations = 0;

        // Process status breakdown
        for (final row in statusResults) {
          final status = row.data['status'] as String;
          final count = row.data['count'] as int;
          final avgRetry = row.data['avg_retry_count'] as double? ?? 0.0;

          statusBreakdown[status] = StatusBreakdown(
            count: count,
            avgRetryCount: avgRetry,
          );
          totalOperations += count;
        }

        // Process type breakdown
        final typeBreakdown = <String, Map<String, int>>{};
        for (final row in typeResults) {
          final type = row.data['operation_type'] as String;
          final status = row.data['status'] as String;
          final count = row.data['count'] as int;

          typeBreakdown.putIfAbsent(type, () => {});
          typeBreakdown[type]![status] = count;
        }

        return DetailedQueueStatistics(
          statusBreakdown: statusBreakdown,
          typeBreakdown: typeBreakdown,
          totalOperations: totalOperations,
          generatedAt: DateTime.now().toIso8601String(),
        );
      },
      const DetailedQueueStatistics(
        statusBreakdown: {},
        typeBreakdown: {},
        totalOperations: 0,
        generatedAt: '',
      ),
    );
  }

  /// Performance metrics for monitoring
  Future<PerformanceMetrics> getPerformanceMetrics() async {
    return _withLog(
      'Getting performance metrics',
      () async {
        final query = _database.customSelect(
          '''
        SELECT 
          COUNT(*) as total_count,
          COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_count,
          COUNT(CASE WHEN status = 'failed' THEN 1 END) as failed_count,
          COUNT(CASE WHEN retry_count > 0 THEN 1 END) as retried_count,
          AVG(retry_count) as avg_retry_count,
          MAX(retry_count) as max_retry_count,
          MIN(timestamp) as oldest_timestamp,
          MAX(timestamp) as newest_timestamp
        FROM sync_queue
        ''',
          readsFrom: {_database.syncQueue},
        );

        final result = await query.getSingle();
        final data = result.data;

        return PerformanceMetrics(
          totalOperations: data['total_count'] as int? ?? 0,
          pendingOperations: data['pending_count'] as int? ?? 0,
          failedOperations: data['failed_count'] as int? ?? 0,
          operationsWithRetries: data['retried_count'] as int? ?? 0,
          averageRetryCount: data['avg_retry_count'] as double? ?? 0.0,
          maxRetryCount: data['max_retry_count'] as int? ?? 0,
          queueAgeHours: _calculateQueueAgeHours(
            data['oldest_timestamp'] as int?,
            data['newest_timestamp'] as int?,
          ),
          measuredAt: DateTime.now(),
        );
      },
      PerformanceMetrics(
        totalOperations: 0,
        pendingOperations: 0,
        failedOperations: 0,
        operationsWithRetries: 0,
        averageRetryCount: 0.0,
        maxRetryCount: 0,
        queueAgeHours: 0.0,
        measuredAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
  }

  /// Helper method to calculate queue age in hours
  double _calculateQueueAgeHours(int? oldestTimestamp, int? newestTimestamp) {
    if (oldestTimestamp == null || newestTimestamp == null) return 0.0;

    final ageMs = newestTimestamp - oldestTimestamp;
    return ageMs / (1000 * 60 * 60); // Convert to hours
  }
}
