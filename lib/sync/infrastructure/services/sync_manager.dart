import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/sync/infrastructure/repositories/sync_queue_repository.dart';
import 'dart:convert';
import 'dart:async';

/// --- SYNC OPERATION MODEL ---

enum SyncOperationStatus { pending, synced, failed }

class SyncOperation {
  final String operationType;
  final String fieldType;
  final String entityKey;
  final Map<String, dynamic> operationData;
  final int timestamp;
  int retryCount;
  SyncOperationStatus status;

  SyncOperation({
    required this.operationType,
    required this.fieldType,
    required this.entityKey,
    required this.operationData,
    required this.timestamp,
    this.retryCount = 0,
    this.status = SyncOperationStatus.pending,
  });
}

/// --- SYNC ENGINE INTERFACES ---

abstract class ISyncManager {
  bool get isOfflineMode;
  int get pendingOperationsCount;
  Future<void> enqueueSyncOperation({
    required String operationType,
    required String fieldType,
    required String entityKey,
    required Map<String, dynamic> operationData,
  });
  Future<void> processPendingOperations();
  Future<void> checkConnectivityRecovery();
  void dispose();
  Map<String, dynamic> get syncStats;
}

abstract class DomainSyncAdapter {
  (String, String) parseKey(String entityKey);
  Future<void> executeOperation(
    String operationType,
    String studentCode,
    String courseCode,
    Map<String, dynamic> operationData,
  );
  Future<void> testConnectivity();
}

/// --- SYNC ENGINE ---

class SyncEngine implements ISyncManager {
  final SyncQueueRepository _queueRepo;
  final Logger _logger;
  final DomainSyncAdapter _adapter;
  final String _entityType;

  bool _isOffline = false;
  Timer? _timer;
  final List<SyncOperation> _pending = [];
  static const _debounce = Duration(seconds: 8);
  static const _maxRetries = 2;
  static const _retryDelay = Duration(milliseconds: 500);

  int _operationsProcessed = 0;
  int _failedOperations = 0;

  bool _isProcessing = false;

  // SyncEngine(this._queueRepo, this._logger, this._adapter);
  SyncEngine({
    required SyncQueueRepository queueRepo,
    required Logger logger,
    required DomainSyncAdapter adapter,
    required String entityType,
  }) : _queueRepo = queueRepo,
       _logger = logger,
       _adapter = adapter,
       _entityType = entityType;

  /// Bootstrap automático: procesa la cola persistente al iniciar
  @PostConstruct()
  Future<void> bootstrap() async {
    _logger.i('[SYNC] Bootstrap: processing stored operations');
    await processPendingOperations();
  }

  @override
  bool get isOfflineMode => _isOffline;

  @override
  int get pendingOperationsCount => _pending.length;

  @override
  Map<String, dynamic> get syncStats => {
    'is_offline': _isOffline,
    'pending_operations': _pending.length,
    'total_operations_processed': _operationsProcessed,
    'failed_operations': _failedOperations,
    'success_rate': _calculateSuccessRate(),
  };

  @override
  Future<void> enqueueSyncOperation({
    required String operationType,
    required String fieldType,
    required String entityKey,
    required Map<String, dynamic> operationData,
  }) async {
    final op = SyncOperation(
      operationType: operationType,
      fieldType: fieldType,
      entityKey: entityKey,
      operationData: operationData,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    final idx = _pending.indexWhere((o) => o.entityKey == entityKey);
    if (idx != -1) {
      _pending[idx] = op;
      _logger.d('[SYNC] Replaced operation for $entityKey');
    } else {
      _pending.add(op);
      _logger.d('[SYNC] Queued $operationType for $entityKey');
    }

    await _queueRepo.persistOperation(
      entityType: _entityType,
      operationType: operationType,
      fieldType: fieldType,
      entityKey: entityKey,
      operationData: operationData,
    );

    _timer?.cancel();
    if (!_isOffline) {
      _timer = Timer(_debounce, _processPending);
    }
  }

  Future<void> _processPending() async {
    if (_pending.isEmpty) return;
    if (_isProcessing) {
      _logger.w(
        '[SYNC] _processPending called while already processing. Waiting...',
      );
      while (_isProcessing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }
    _isProcessing = true;
    _logger.i('[SYNC] Processing ${_pending.length} operations');
    try {
      final grouped = <String, SyncOperation>{};
      for (final op in _pending) {
        grouped[op.entityKey] = op;
      }

      for (final entry in grouped.entries) {
        await _processSingle(entry.key, entry.value);
      }

      _pending.clear();
      await _queueRepo.cleanupCompletedOperations(
        entityTypeFilter: _entityType,
      );
      _operationsProcessed++;
      final storedCount =
          (await _queueRepo.getPendingOperations(
            entityType: _entityType,
          )).length;
      _logger.i('[SYNC] Batch completed. Remaining in SQLite: $storedCount');
    } catch (e) {
      _failedOperations++;
      _logger.e('[SYNC] Batch failed: $e');
      _isOffline = true;
      _timer?.cancel();
      _logger.w('[SYNC] Entering offline mode');
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processSingle(String entityKey, SyncOperation op) async {
    final (studentCode, courseCode) = _adapter.parseKey(entityKey);
    for (var attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        await _adapter.executeOperation(
          op.operationType,
          studentCode,
          courseCode,
          op.operationData,
        );
        return;
      } catch (e) {
        if (attempt == _maxRetries) {
          _logger.e('[SYNC] Final retry failed for $entityKey: $e');
          rethrow;
        }
        _logger.w('[SYNC] Retry $attempt failed for $entityKey: $e');
        await Future.delayed(_retryDelay);
      }
    }
  }

  Future<void> _processStored() async {
    if (_isProcessing) {
      _logger.w(
        '[SYNC] _processStored called while already processing. Waiting...',
      );
      while (_isProcessing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }
    _isProcessing = true;
    final operations = await _queueRepo.getPendingOperations(
      entityType: _entityType,
    );
    if (operations.isEmpty) {
      _isProcessing = false;
      return;
    }

    _logger.d('[SYNC] Processing ${operations.length} stored operations');
    for (final op in operations) {
      try {
        final operationData = jsonDecode(op.operationData);
        final (studentCode, courseCode) = _adapter.parseKey(op.entityKey);

        await _adapter.executeOperation(
          op.operationType,
          studentCode,
          courseCode,
          operationData,
        );
        await _queueRepo.markAsSynced(op.id);
      } catch (e) {
        await _queueRepo.markAsFailed(op.id);
        _logger.e('[SYNC] Stored operation failed: $e');
      }
    }
    final left =
        (await _queueRepo.getPendingOperations(entityType: _entityType)).length;
    _logger.i('[SYNC] After cleanup, $left operations remain in SQLite');
    _isProcessing = false;
  }

  @override
  Future<void> processPendingOperations() async {
    await _processPending();
    await _processStored();
  }

  @override
  Future<void> checkConnectivityRecovery() async {
    if (!_isOffline) return;
    try {
      await _adapter.testConnectivity();
      _isOffline = false;
      _logger.i('[SYNC] Connectivity restored');
      await processPendingOperations();
    } catch (e) {
      _logger.d('[SYNC] Still offline: ${e.runtimeType}');
    }
  }

  @override
  void dispose() => _timer?.cancel();

  String _calculateSuccessRate() {
    final total = _operationsProcessed + _failedOperations;
    if (total == 0) return '100%';
    return '${((_operationsProcessed / total) * 100).toStringAsFixed(0)}%';
  }
}
