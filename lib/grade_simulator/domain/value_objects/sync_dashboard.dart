/// Simple health status enum (shared between full and lean implementations)
enum SyncHealthStatus {
  excellent,
  good,
  warning,
  critical,
  offline;

  String get icon {
    switch (this) {
      case SyncHealthStatus.excellent:
        return '🟢';
      case SyncHealthStatus.good:
        return '🔵';
      case SyncHealthStatus.warning:
        return '🟡';
      case SyncHealthStatus.critical:
        return '🔴';
      case SyncHealthStatus.offline:
        return '⚫';
    }
  }
}

class SyncMetricsDashboard {
  final bool isOfflineMode;
  final int pendingOperations;
  final String successRate;
  final int totalOperations;
  final int failedOperations;

  const SyncMetricsDashboard({
    required this.isOfflineMode,
    required this.pendingOperations,
    required this.successRate,
    required this.totalOperations,
    required this.failedOperations,
  });

  /// Compatibility methods for existing UI widgets
  // @override
  Map<String, String> get executiveSummary => {
    'Sync Success Rate': successRate,
    'Total Operations': totalOperations.toString(),
    'Batches Processed': '${totalOperations + failedOperations}',
    'Pending Operations': pendingOperations.toString(),
  };

  // @override
  SyncHealthStatus get healthStatus {
    if (isOfflineMode) return SyncHealthStatus.offline;
    if (failedOperations > 0) return SyncHealthStatus.warning;
    return SyncHealthStatus.good;
  }
}
