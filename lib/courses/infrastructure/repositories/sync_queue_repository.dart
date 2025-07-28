import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/database/sqlite_client_manager.dart';

/// Repository for managing sync queue operations
/// Handles all SQLite operations related to the sync_queue table
@singleton
class SyncQueueRepository {
  final SQLiteClientManager _database;
  final Logger _logger;

  SyncQueueRepository(this._database, this._logger);

  /// Get pending sync operations
  Future<List<Map<String, dynamic>>> getPendingOperations({
    int maxRetryCount = 3,
  }) async {
    try {
      return await _database.db.query(
        'sync_queue',
        where: 'status = ? AND retry_count < ?',
        whereArgs: ['pending', maxRetryCount],
        orderBy: 'timestamp ASC',
      );
    } catch (e) {
      _logger.e('[SYNC_QUEUE_REPO] Error getting pending operations: $e');
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
      await _database.db.insert('sync_queue', {
        'operation_type': operationType,
        'entity_type': entityType,
        'entity_key': entityKey,
        'field_name': fieldType,
        'operation_data': jsonEncode(operationData),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'retry_count': 0,
        'status': 'pending',
      });

      _logger.d(
        '[SYNC_QUEUE_REPO] Persisted operation: $operationType for $entityKey',
      );
    } catch (e) {
      _logger.e('[SYNC_QUEUE_REPO] Error persisting operation: $e');
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
      final updateData = <String, dynamic>{'status': status};
      if (retryCount != null) {
        updateData['retry_count'] = retryCount;
      }

      await _database.db.update(
        'sync_queue',
        updateData,
        where: 'id = ?',
        whereArgs: [operationId],
      );

      _logger.d(
        '[SYNC_QUEUE_REPO] Updated operation $operationId status to: $status',
      );
    } catch (e) {
      _logger.e('[SYNC_QUEUE_REPO] Error updating operation status: $e');
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

      final deletedCount = await _database.db.delete(
        'sync_queue',
        where: 'status = ? AND timestamp < ?',
        whereArgs: ['synced', cutoffTime],
      );

      if (deletedCount > 0) {
        _logger.d(
          '[SYNC_QUEUE_REPO] Cleaned up $deletedCount completed operations',
        );
      }
    } catch (e) {
      _logger.e('[SYNC_QUEUE_REPO] Error cleaning up operations: $e');
    }
  }

  /// Clean up failed operations (older than retention period)
  Future<void> cleanupFailedOperations({
    Duration retentionPeriod = const Duration(days: 7),
  }) async {
    try {
      final cutoffTime =
          DateTime.now().subtract(retentionPeriod).millisecondsSinceEpoch;

      final deletedCount = await _database.db.delete(
        'sync_queue',
        where: 'status = ? AND timestamp < ?',
        whereArgs: ['failed', cutoffTime],
      );

      if (deletedCount > 0) {
        _logger.d(
          '[SYNC_QUEUE_REPO] Cleaned up $deletedCount failed operations',
        );
      }
    } catch (e) {
      _logger.e('[SYNC_QUEUE_REPO] Error cleaning up failed operations: $e');
    }
  }

  /// Get sync queue statistics
  Future<Map<String, int>> getQueueStats() async {
    try {
      final results = await _database.db.rawQuery('''
        SELECT 
          status,
          COUNT(*) as count
        FROM sync_queue 
        GROUP BY status
      ''');

      final stats = <String, int>{'pending': 0, 'synced': 0, 'failed': 0};

      for (final row in results) {
        final status = row['status'] as String;
        final count = row['count'] as int;
        stats[status] = count;
      }

      return stats;
    } catch (e) {
      _logger.e('[SYNC_QUEUE_REPO] Error getting queue stats: $e');
      return {'pending': 0, 'synced': 0, 'failed': 0};
    }
  }

  /// Get operations by entity key (useful for debugging)
  Future<List<Map<String, dynamic>>> getOperationsByEntityKey(
    String entityKey,
  ) async {
    try {
      return await _database.db.query(
        'sync_queue',
        where: 'entity_key = ?',
        whereArgs: [entityKey],
        orderBy: 'timestamp DESC',
        limit: 10, // Last 10 operations
      );
    } catch (e) {
      _logger.e('[SYNC_QUEUE_REPO] Error getting operations by entity key: $e');
      return [];
    }
  }

  /// Delete all operations for a specific entity (useful for cleanup)
  Future<void> deleteOperationsByEntityKey(String entityKey) async {
    try {
      final deletedCount = await _database.db.delete(
        'sync_queue',
        where: 'entity_key = ?',
        whereArgs: [entityKey],
      );

      _logger.d(
        '[SYNC_QUEUE_REPO] Deleted $deletedCount operations for entity: $entityKey',
      );
    } catch (e) {
      _logger.e(
        '[SYNC_QUEUE_REPO] Error deleting operations by entity key: $e',
      );
    }
  }
}
