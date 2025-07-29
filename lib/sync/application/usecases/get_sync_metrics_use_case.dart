import 'package:injectable/injectable.dart';
import 'package:sigapp/sync/domain/value_objects/sync_dashboard.dart';
import 'package:sigapp/sync/infrastructure/services/sync_manager.dart';

/// Provides just enough stats for compact_sync_metrics.dart to work
/// without complex tracking or performance overhead
@injectable
class GetSyncMetricsUseCase {
  final GradeSimulatorSyncManager _syncManager;

  GetSyncMetricsUseCase(this._syncManager);

  /// Get minimal dashboard for UI widgets
  SyncMetricsDashboard execute() {
    final stats = _syncManager.basicStats;

    return SyncMetricsDashboard(
      isOfflineMode: _syncManager.isOfflineMode,
      pendingOperations: _syncManager.pendingOperationsCount,
      successRate: stats['success_rate'] as String,
      totalOperations: stats['total_operations_processed'] as int,
      failedOperations: stats['failed_operations'] as int,
    );
  }

  /// Reset minimal metrics (no complex state to reset)
  void resetMetrics() {
    // In lean version, we don't track complex metrics to reset
    // This method exists for compatibility but does nothing
  }

  /// Export basic stats as string for debugging
  String exportMetricsAsString() {
    final stats = _syncManager.basicStats;
    return '''
=== SYNC STATS ===
Success Rate: ${stats['success_rate']}
Total Processed: ${stats['total_operations_processed']}
Failed: ${stats['failed_operations']}
Pending: ${stats['pending_operations']}
Offline: ${stats['is_offline']}
''';
  }
}
