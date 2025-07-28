/// Performance metrics for synchronization operations
///
/// Tracks:
/// - Batching efficiency and operations saved
/// - Connectivity status and failures
/// - Sync performance and timing
/// - System health dashboard
class SyncPerformanceMetrics {
  // MAIN COUNTERS
  int _totalSyncOperations = 0;
  int _successfulSyncs = 0;
  int _failedSyncs = 0;
  int _batchesProcessed = 0;
  int _conflictsResolved = 0;

  // TIMING METRICS
  int _totalSyncTimeMs = 0;
  int _averageSyncTimeMs = 0;
  List<int> _recentSyncTimes = [];
  static const int _maxRecentSyncTimes = 10;

  // CONNECTIVITY METRICS
  int _connectivityFailures = 0;
  int _connectivityRecoveries = 0;
  DateTime? _lastConnectivityCheck;
  bool _isCurrentlyOnline = true;

  // BATCHING METRICS
  int _totalOperationsEnqueued = 0;
  int _operationsSavedByBatching = 0;
  Map<String, int> _batchSizeDistribution = {};

  // INTERNAL STATE
  final List<String> _recentEvents = [];
  static const int _maxRecentEvents = 20;

  // 📊 GETTERS PÚBLICOS PARA DASHBOARD

  /// Estadísticas generales de sincronización
  Map<String, dynamic> get syncStats => {
    'total_operations': _totalSyncOperations,
    'successful_syncs': _successfulSyncs,
    'failed_syncs': _failedSyncs,
    'success_rate':
        _totalSyncOperations > 0
            ? (_successfulSyncs / _totalSyncOperations * 100).toStringAsFixed(
                  1,
                ) +
                '%'
            : '0%',
    'conflicts_resolved': _conflictsResolved,
  };

  /// Métricas de performance temporal
  Map<String, dynamic> get performanceStats => {
    'average_sync_time_ms': _averageSyncTimeMs,
    'total_sync_time_ms': _totalSyncTimeMs,
    'recent_sync_times': List.from(_recentSyncTimes),
  };

  /// Estado de conectividad
  Map<String, dynamic> get connectivityStats => {
    'is_online': _isCurrentlyOnline,
    'connectivity_failures': _connectivityFailures,
    'connectivity_recoveries': _connectivityRecoveries,
    'last_connectivity_check': _lastConnectivityCheck?.toIso8601String(),
  };

  /// Eficiencia del batching
  Map<String, dynamic> get batchingStats => {
    'batches_processed': _batchesProcessed,
    'total_operations_enqueued': _totalOperationsEnqueued,
    'operations_saved_by_batching': _operationsSavedByBatching,
    'batching_efficiency':
        _totalOperationsEnqueued > 0
            ? (_operationsSavedByBatching / _totalOperationsEnqueued * 100)
                    .toStringAsFixed(1) +
                '%'
            : '0%',
    'batch_size_distribution': Map.from(_batchSizeDistribution),
  };

  /// Eventos recientes para debugging
  List<String> get recentEvents => List.from(_recentEvents);

  /// Dashboard completo
  Map<String, dynamic> get fullDashboard => {
    'sync_stats': syncStats,
    'performance_stats': performanceStats,
    'connectivity_stats': connectivityStats,
    'batching_stats': batchingStats,
    'recent_events': recentEvents,
    'generated_at': DateTime.now().toIso8601String(),
  };

  // 🔧 MÉTODOS PARA REGISTRAR EVENTOS

  /// Registra el inicio de una operación de sincronización
  void recordSyncStart() {
    _totalSyncOperations++;
    _addEvent('Sync operation started');
  }

  /// Registra una sincronización exitosa
  void recordSyncSuccess(int durationMs) {
    _successfulSyncs++;
    _recordSyncTime(durationMs);
    _addEvent('Sync completed successfully in ${durationMs}ms');
  }

  /// Registra un fallo de sincronización
  void recordSyncFailure(String reason) {
    _failedSyncs++;
    _addEvent('Sync failed: $reason');
  }

  /// Registra operaciones encoladas para batching
  void recordOperationsEnqueued(int count) {
    _totalOperationsEnqueued += count;
    _addEvent('$count operations enqueued for batching');
  }

  /// Registra un batch procesado
  void recordBatchProcessed(int batchSize, int operationsSaved) {
    _batchesProcessed++;
    _operationsSavedByBatching += operationsSaved;

    // Actualizar distribución de tamaños de batch
    final sizeKey = _getBatchSizeCategory(batchSize);
    _batchSizeDistribution[sizeKey] =
        (_batchSizeDistribution[sizeKey] ?? 0) + 1;

    _addEvent(
      'Batch processed: $batchSize operations, saved $operationsSaved DB calls',
    );
  }

  /// Registra un conflicto resuelto
  void recordConflictResolved(String conflictType) {
    _conflictsResolved++;
    _addEvent('Conflict resolved: $conflictType');
  }

  /// Registra fallo de conectividad
  void recordConnectivityFailure() {
    _connectivityFailures++;
    _isCurrentlyOnline = false;
    _lastConnectivityCheck = DateTime.now();
    _addEvent('Connectivity failure detected');
  }

  /// Registra recuperación de conectividad
  void recordConnectivityRecovery() {
    _connectivityRecoveries++;
    _isCurrentlyOnline = true;
    _lastConnectivityCheck = DateTime.now();
    _addEvent('Connectivity recovered');
  }

  /// Actualiza estado de conectividad
  void updateConnectivityStatus(bool isOnline) {
    final wasOnline = _isCurrentlyOnline;
    _isCurrentlyOnline = isOnline;
    _lastConnectivityCheck = DateTime.now();

    if (wasOnline != isOnline) {
      if (isOnline) {
        recordConnectivityRecovery();
      } else {
        recordConnectivityFailure();
      }
    }
  }

  // 🛠️ MÉTODOS INTERNOS

  void _recordSyncTime(int durationMs) {
    _totalSyncTimeMs += durationMs;
    _recentSyncTimes.add(durationMs);

    // Mantener solo los últimos N tiempos
    if (_recentSyncTimes.length > _maxRecentSyncTimes) {
      _recentSyncTimes.removeAt(0);
    }

    // Recalcular promedio
    if (_successfulSyncs > 0) {
      _averageSyncTimeMs = _totalSyncTimeMs ~/ _successfulSyncs;
    }
  }

  String _getBatchSizeCategory(int size) {
    if (size == 1) return '1_operation';
    if (size <= 5) return '2-5_operations';
    if (size <= 10) return '6-10_operations';
    if (size <= 20) return '11-20_operations';
    return '20+_operations';
  }

  void _addEvent(String event) {
    final timestamp = DateTime.now().toIso8601String().substring(
      11,
      19,
    ); // HH:mm:ss
    _recentEvents.add('[$timestamp] $event');

    // Mantener solo los últimos N eventos
    if (_recentEvents.length > _maxRecentEvents) {
      _recentEvents.removeAt(0);
    }
  }

  // 🧹 MÉTODOS DE ADMINISTRACIÓN

  /// Resetea todas las métricas
  void reset() {
    _totalSyncOperations = 0;
    _successfulSyncs = 0;
    _failedSyncs = 0;
    _batchesProcessed = 0;
    _conflictsResolved = 0;
    _totalSyncTimeMs = 0;
    _averageSyncTimeMs = 0;
    _recentSyncTimes.clear();
    _connectivityFailures = 0;
    _connectivityRecoveries = 0;
    _lastConnectivityCheck = null;
    _isCurrentlyOnline = true;
    _totalOperationsEnqueued = 0;
    _operationsSavedByBatching = 0;
    _batchSizeDistribution.clear();
    _recentEvents.clear();
  }

  /// Exporta métricas para logging
  String toLogString() {
    return '''
SyncPerformanceMetrics Summary:
- Sync Operations: $_totalSyncOperations (Success: $_successfulSyncs, Failed: $_failedSyncs)
- Average Sync Time: ${_averageSyncTimeMs}ms
- Batches: $_batchesProcessed processed, ${_operationsSavedByBatching} operations saved
- Connectivity: Online=${_isCurrentlyOnline}, Failures=${_connectivityFailures}
- Conflicts Resolved: $_conflictsResolved
''';
  }
}
