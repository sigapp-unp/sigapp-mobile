import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/database/drift/app_database.dart';

/// Repository for managing sync queue operations
/// Handles all SQLite operations related to the sync_queue table
@singleton
class SyncQueueRepository {
  final AppDatabase _database;
  final Logger _logger;

  SyncQueueRepository(this._database, this._logger);

  /// Get pending sync operations
  Future<List<SyncQueueData>> getPendingOperations({
    int maxRetryCount = 3,
  }) async {
    try {
      _logger.d('[DRIFT_SYNC] Getting pending operations...');

      final query =
          _database.select(_database.syncQueue)
            ..where(
              (tbl) =>
                  tbl.status.equals('pending') &
                  tbl.retryCount.isSmallerThanValue(maxRetryCount),
            )
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]);

      final results = await query.get();
      _logger.d('[DRIFT_SYNC] ✅ Found ${results.length} pending operations');
      return results;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error getting pending operations: $e');
      return [];
    }
  }

  /// Persist a sync operation
  Future<void> persistOperation({
    required String operationType,
    required String fieldType,
    required String entityKey,
    required Map<String, dynamic> operationData,
    String entityType = 'course_grade_simulator',
  }) async {
    try {
      _logger.d(
        '[DRIFT_SYNC] Persisting operation: $operationType for $entityKey',
      );

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
              status: const Value('pending'),
            ),
          );

      _logger.d(
        '[DRIFT_SYNC] ✅ Persisted operation: $operationType for $entityKey',
      );
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error persisting operation: $e');
      // No crítico - continuar sin persistencia
    }
  }

  /// Update operation status
  Future<void> updateOperationStatus({
    required int operationId,
    required String status,
    int? retryCount,
  }) async {
    try {
      _logger.d(
        '[DRIFT_SYNC] Updating operation $operationId status to: $status',
      );

      final companion = SyncQueueCompanion(
        status: Value(status),
        retryCount:
            retryCount != null ? Value(retryCount) : const Value.absent(),
      );

      await (_database.update(_database.syncQueue)
        ..where((tbl) => tbl.id.equals(operationId))).write(companion);

      _logger.d(
        '[DRIFT_SYNC] ✅ Updated operation $operationId status to: $status',
      );
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error updating operation status: $e');
    }
  }

  /// Mark operation as synced
  Future<void> markAsSynced(int operationId) async {
    await updateOperationStatus(operationId: operationId, status: 'synced');
  }

  /// Mark operation as failed
  Future<void> markAsFailed(int operationId, int retryCount) async {
    await updateOperationStatus(
      operationId: operationId,
      status: retryCount >= 3 ? 'failed' : 'pending',
      retryCount: retryCount,
    );
  }

  /// Clean up completed operations
  Future<void> cleanupCompletedOperations({
    Duration retentionPeriod = const Duration(hours: 24),
  }) async {
    try {
      final cutoffTime =
          DateTime.now().subtract(retentionPeriod).millisecondsSinceEpoch;

      _logger.d(
        '[DRIFT_SYNC] Cleaning up completed operations older than $retentionPeriod',
      );

      final deletedCount =
          await (_database.delete(_database.syncQueue)..where(
            (tbl) =>
                tbl.status.equals('synced') &
                tbl.timestamp.isSmallerThanValue(cutoffTime),
          )).go();

      if (deletedCount > 0) {
        _logger.d(
          '[DRIFT_SYNC] ✅ Cleaned up $deletedCount completed operations',
        );
      }
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error cleaning up operations: $e');
    }
  }

  /// Clean up failed operations (older than retention period)
  Future<void> cleanupFailedOperations({
    Duration retentionPeriod = const Duration(days: 7),
  }) async {
    try {
      final cutoffTime =
          DateTime.now().subtract(retentionPeriod).millisecondsSinceEpoch;

      _logger.d(
        '[DRIFT_SYNC] Cleaning up failed operations older than $retentionPeriod',
      );

      final deletedCount =
          await (_database.delete(_database.syncQueue)..where(
            (tbl) =>
                tbl.status.equals('failed') &
                tbl.timestamp.isSmallerThanValue(cutoffTime),
          )).go();

      if (deletedCount > 0) {
        _logger.d('[DRIFT_SYNC] ✅ Cleaned up $deletedCount failed operations');
      }
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error cleaning up failed operations: $e');
    }
  }

  /// Get sync queue statistics
  Future<Map<String, int>> getQueueStats() async {
    try {
      _logger.d('[DRIFT_SYNC] Getting queue statistics...');

      // Using custom query for aggregation
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
      final stats = <String, int>{'pending': 0, 'synced': 0, 'failed': 0};

      for (final row in results) {
        final status = row.data['status'] as String;
        final count = row.data['count'] as int;
        stats[status] = count;
      }

      _logger.d('[DRIFT_SYNC] ✅ Queue stats: $stats');
      return stats;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error getting queue stats: $e');
      return {'pending': 0, 'synced': 0, 'failed': 0};
    }
  }

  /// Get operations by entity key (useful for debugging)
  Future<List<SyncQueueData>> getOperationsByEntityKey(String entityKey) async {
    try {
      _logger.d('[DRIFT_SYNC] Getting operations for entity: $entityKey');

      final query =
          _database.select(_database.syncQueue)
            ..where((tbl) => tbl.entityKey.equals(entityKey))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])
            ..limit(10); // Last 10 operations

      final results = await query.get();
      _logger.d(
        '[DRIFT_SYNC] ✅ Found ${results.length} operations for entity: $entityKey',
      );
      return results;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error getting operations by entity key: $e');
      return [];
    }
  }

  /// Delete all operations for a specific entity (useful for cleanup)
  Future<void> deleteOperationsByEntityKey(String entityKey) async {
    try {
      _logger.d('[DRIFT_SYNC] Deleting operations for entity: $entityKey');

      final deletedCount =
          await (_database.delete(_database.syncQueue)
            ..where((tbl) => tbl.entityKey.equals(entityKey))).go();

      _logger.d(
        '[DRIFT_SYNC] ✅ Deleted $deletedCount operations for entity: $entityKey',
      );
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error deleting operations by entity key: $e');
    }
  }

  // 🚀 NUEVAS FUNCIONALIDADES DRIFT-ESPECÍFICAS

  /// Batch mark multiple operations as synced (optimized)
  Future<void> batchMarkAsSynced(List<int> operationIds) async {
    if (operationIds.isEmpty) return;

    try {
      _logger.d(
        '[DRIFT_SYNC] Batch marking ${operationIds.length} operations as synced',
      );

      await _database.transaction(() async {
        for (final id in operationIds) {
          await (_database.update(_database.syncQueue)..where(
            (tbl) => tbl.id.equals(id),
          )).write(const SyncQueueCompanion(status: Value('synced')));
        }
      });

      _logger.d(
        '[DRIFT_SYNC] ✅ Batch marked ${operationIds.length} operations as synced',
      );
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error in batch mark as synced: $e');
      rethrow;
    }
  }

  /// Batch persist multiple operations (transactional)
  Future<void> batchPersistOperations(
    List<Map<String, dynamic>> operations,
  ) async {
    if (operations.isEmpty) return;

    try {
      _logger.d(
        '[DRIFT_SYNC] Batch persisting ${operations.length} operations',
      );

      await _database.transaction(() async {
        for (final op in operations) {
          await _database
              .into(_database.syncQueue)
              .insert(
                SyncQueueCompanion(
                  operationType: Value(op['operationType'] as String),
                  entityType: Value(
                    op['entityType'] as String? ?? 'course_grade_simulator',
                  ),
                  entityKey: Value(op['entityKey'] as String),
                  fieldName: Value(op['fieldType'] as String),
                  operationData: Value(
                    jsonEncode(op['operationData'] as Map<String, dynamic>),
                  ),
                  timestamp: Value(DateTime.now().millisecondsSinceEpoch),
                  retryCount: const Value(0),
                  status: const Value('pending'),
                ),
              );
        }
      });

      _logger.d(
        '[DRIFT_SYNC] ✅ Batch persisted ${operations.length} operations',
      );
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error in batch persist operations: $e');
      rethrow;
    }
  }

  /// Get operations by type (useful for analytics)
  Future<List<SyncQueueData>> getOperationsByType(String operationType) async {
    try {
      _logger.d('[DRIFT_SYNC] Getting operations by type: $operationType');

      final query =
          _database.select(_database.syncQueue)
            ..where((tbl) => tbl.operationType.equals(operationType))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)]);

      final results = await query.get();
      _logger.d(
        '[DRIFT_SYNC] ✅ Found ${results.length} operations of type: $operationType',
      );
      return results;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error getting operations by type: $e');
      return [];
    }
  }

  /// Get failed operations (useful for retry logic)
  Future<List<SyncQueueData>> getFailedOperations() async {
    try {
      _logger.d('[DRIFT_SYNC] Getting failed operations...');

      final query =
          _database.select(_database.syncQueue)
            ..where((tbl) => tbl.status.equals('failed'))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)]);

      final results = await query.get();
      _logger.d('[DRIFT_SYNC] ✅ Found ${results.length} failed operations');
      return results;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error getting failed operations: $e');
      return [];
    }
  }

  /// Get recent operations within time window
  Future<List<SyncQueueData>> getRecentOperations({
    Duration timeWindow = const Duration(hours: 1),
  }) async {
    try {
      final cutoffTime =
          DateTime.now().subtract(timeWindow).millisecondsSinceEpoch;

      _logger.d('[DRIFT_SYNC] Getting recent operations within $timeWindow');

      final query =
          _database.select(_database.syncQueue)
            ..where((tbl) => tbl.timestamp.isBiggerThanValue(cutoffTime))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)]);

      final results = await query.get();
      _logger.d('[DRIFT_SYNC] ✅ Found ${results.length} recent operations');
      return results;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error getting recent operations: $e');
      return [];
    }
  }

  /// Get detailed queue statistics with breakdown by type
  Future<Map<String, dynamic>> getDetailedQueueStatistics() async {
    try {
      _logger.d('[DRIFT_SYNC] Getting detailed queue statistics...');

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

      final stats = <String, dynamic>{
        'status_breakdown': {},
        'type_breakdown': {},
        'total_operations': 0,
        'generated_at': DateTime.now().toIso8601String(),
      };

      // Process status breakdown
      for (final row in statusResults) {
        final status = row.data['status'] as String;
        final count = row.data['count'] as int;
        final avgRetry = row.data['avg_retry_count'] as double?;

        stats['status_breakdown'][status] = {
          'count': count,
          'avg_retry_count': avgRetry ?? 0.0,
        };
        stats['total_operations'] = (stats['total_operations'] as int) + count;
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
      stats['type_breakdown'] = typeBreakdown;

      _logger.d('[DRIFT_SYNC] ✅ Generated detailed statistics');
      return stats;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error getting detailed statistics: $e');
      return {
        'status_breakdown': {},
        'type_breakdown': {},
        'total_operations': 0,
        'error': e.toString(),
      };
    }
  }

  /// Performance metrics for monitoring
  Future<Map<String, dynamic>> getPerformanceMetrics() async {
    try {
      _logger.d('[DRIFT_SYNC] Getting performance metrics...');

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

      final metrics = <String, dynamic>{
        'total_operations': data['total_count'] ?? 0,
        'pending_operations': data['pending_count'] ?? 0,
        'failed_operations': data['failed_count'] ?? 0,
        'operations_with_retries': data['retried_count'] ?? 0,
        'average_retry_count': data['avg_retry_count'] ?? 0.0,
        'max_retry_count': data['max_retry_count'] ?? 0,
        'queue_age_hours': _calculateQueueAgeHours(
          data['oldest_timestamp'] as int?,
          data['newest_timestamp'] as int?,
        ),
        'measured_at': DateTime.now().toIso8601String(),
      };

      _logger.d('[DRIFT_SYNC] ✅ Performance metrics generated');
      return metrics;
    } catch (e) {
      _logger.e('[DRIFT_SYNC] ❌ Error getting performance metrics: $e');
      return {'error': e.toString()};
    }
  }

  /// Helper method to calculate queue age in hours
  double _calculateQueueAgeHours(int? oldestTimestamp, int? newestTimestamp) {
    if (oldestTimestamp == null || newestTimestamp == null) return 0.0;

    final ageMs = newestTimestamp - oldestTimestamp;
    return ageMs / (1000 * 60 * 60); // Convert to hours
  }
}
