import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/database/local_database.dart';
import 'package:sigapp/sync/domain/sync_constants.dart';

@singleton
class SyncQueueRepository {
  final LocalDatabase _database;
  final Logger _logger;

  SyncQueueRepository(this._database, this._logger);

  /// Persist operation to SQLite (with deduplication)
  Future<void> persistOperation({
    required String entityType,
    required String operationType,
    required String fieldType,
    required String entityKey,
    required Map<String, dynamic> operationData,
  }) async {
    try {
      await _database.transaction(() async {
        await (_database.delete(_database.syncQueue)..where(
          (tbl) =>
              tbl.entityType.equals(entityType) &
              tbl.entityKey.equals(entityKey),
        )).go();

        // Insert new operation
        await _database
            .into(_database.syncQueue)
            .insert(
              SyncQueueCompanion(
                entityType: Value(entityType),
                entityKey: Value(entityKey),
                operationType: Value(operationType),
                fieldName: Value(fieldType),
                operationData: Value(jsonEncode(operationData)),
                timestamp: Value(DateTime.now().millisecondsSinceEpoch),
                retryCount: const Value(0),
                status: Value(SyncStatus.pending.value),
              ),
            );
      });
      _logger.d(
        '[SYNC_QUEUE] Persisted $operationType for $entityType.$entityKey',
      );
    } catch (e) {
      _logger.e('[SYNC_QUEUE] Error persisting operation: $e');
      rethrow;
    }
  }

  /// Get pending operations for sync processing
  Future<List<SyncQueueData>> getPendingOperations({
    required String entityType,
    int maxRetryCount = defaultMaxRetryCount,
  }) async {
    try {
      final query =
          _database.select(_database.syncQueue)
            ..where(
              (tbl) =>
                  tbl.entityType.equals(entityType) &
                  tbl.status.equals(SyncStatus.pending.value) &
                  tbl.retryCount.isSmallerThanValue(maxRetryCount),
            )
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]);

      final result = await query.get();
      _logger.d('[SYNC_QUEUE] Found ${result.length} pending operations');
      return result;
    } catch (e) {
      _logger.e('[SYNC_QUEUE] Error getting pending operations: $e');
      return [];
    }
  }

  /// Mark operation as successfully synced
  Future<void> markAsSynced(int operationId) async {
    try {
      await (_database.update(_database.syncQueue)..where(
        (tbl) => tbl.id.equals(operationId),
      )).write(SyncQueueCompanion(status: Value(SyncStatus.synced.value)));
      _logger.d('[SYNC_QUEUE] Marked operation $operationId as synced');
    } catch (e) {
      _logger.e('[SYNC_QUEUE] Error marking as synced: $e');
    }
  }

  /// Mark operation as failed (increment retry count)
  Future<void> markAsFailed(int operationId) async {
    try {
      final operation =
          await (_database.select(_database.syncQueue)
            ..where((tbl) => tbl.id.equals(operationId))).getSingleOrNull();

      if (operation != null) {
        await (_database.update(_database.syncQueue)
          ..where((tbl) => tbl.id.equals(operationId))).write(
          SyncQueueCompanion(
            retryCount: Value(operation.retryCount + 1),
            status: Value(SyncStatus.failed.value),
          ),
        );
        _logger.d('[SYNC_QUEUE] Marked operation $operationId as failed');
      }
    } catch (e) {
      _logger.e('[SYNC_QUEUE] Error marking as failed: $e');
    }
  }

  /// Clean up completed operations to prevent SQLite bloat
  Future<void> cleanupCompletedOperations({String? entityTypeFilter}) async {
    try {
      final deleter = _database.delete(_database.syncQueue)
        ..where((tbl) => tbl.status.equals(SyncStatus.synced.value));
      if (entityTypeFilter != null) {
        deleter.where((tbl) => tbl.entityType.equals(entityTypeFilter));
      }
      final deletedCount = await deleter.go();

      if (deletedCount > 0) {
        _logger.d('[SYNC_QUEUE] Cleaned up $deletedCount completed operations');
      }
    } catch (e) {
      _logger.e('[SYNC_QUEUE] Error during cleanup: $e');
    }
  }
}
