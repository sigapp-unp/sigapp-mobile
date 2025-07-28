import 'package:injectable/injectable.dart';
import '../../infrastructure/services/sync_manager.dart';

/// 📊 USE CASE: Obtener métricas de performance del SyncManager
///
/// Funcionalidades:
/// - Estadísticas de sincronización (éxito/fallo)
/// - Métricas de performance temporal
/// - Estado de conectividad
/// - Eficiencia del batching
/// - Eventos recientes para debugging
@injectable
class GetSyncMetricsUseCase {
  final SyncManager _syncManager;

  GetSyncMetricsUseCase(this._syncManager);

  /// Obtener todas las métricas en un dashboard completo
  SyncMetricsDashboard execute() {
    return SyncMetricsDashboard(
      syncStats: _syncManager.syncStats,
      performanceStats: _syncManager.performanceStats,
      connectivityStats: _syncManager.connectivityStats,
      batchingStats: _syncManager.batchingStats,
      recentEvents: _syncManager.recentEvents,
      fullDashboard: _syncManager.metricsFullDashboard,
      isOfflineMode: _syncManager.isOfflineMode,
    );
  }

  /// Resetear todas las métricas
  void resetMetrics() {
    _syncManager.resetMetrics();
  }

  /// Exportar métricas para logging/sharing
  String exportMetricsAsString() {
    return _syncManager.metricsLogString;
  }
}

/// 📊 MODELO DE DATOS: Dashboard completo de métricas
class SyncMetricsDashboard {
  final Map<String, dynamic> syncStats;
  final Map<String, dynamic> performanceStats;
  final Map<String, dynamic> connectivityStats;
  final Map<String, dynamic> batchingStats;
  final List<String> recentEvents;
  final Map<String, dynamic> fullDashboard;
  final bool isOfflineMode;

  const SyncMetricsDashboard({
    required this.syncStats,
    required this.performanceStats,
    required this.connectivityStats,
    required this.batchingStats,
    required this.recentEvents,
    required this.fullDashboard,
    required this.isOfflineMode,
  });

  /// Obtener resumen ejecutivo de las métricas más importantes
  Map<String, String> get executiveSummary => {
    'Sync Success Rate': syncStats['success_rate']?.toString() ?? '0%',
    'Average Sync Time': '${performanceStats['average_sync_time_ms']}ms',
    'Connectivity Status': isOfflineMode ? 'Offline' : 'Online',
    'Batching Efficiency':
        batchingStats['batching_efficiency']?.toString() ?? '0%',
    'Total Operations': syncStats['total_operations']?.toString() ?? '0',
    'Batches Processed': batchingStats['batches_processed']?.toString() ?? '0',
  };

  /// Obtener estado general del sistema
  SyncHealthStatus get healthStatus {
    final successRate = _extractPercentage(syncStats['success_rate']);
    final isOnline = !isOfflineMode;
    final hasRecentActivity = (syncStats['total_operations'] as int? ?? 0) > 0;

    if (!isOnline) {
      return SyncHealthStatus.offline;
    } else if (successRate >= 90 && hasRecentActivity) {
      return SyncHealthStatus.excellent;
    } else if (successRate >= 70) {
      return SyncHealthStatus.good;
    } else if (successRate >= 50) {
      return SyncHealthStatus.warning;
    } else {
      return SyncHealthStatus.critical;
    }
  }

  double _extractPercentage(dynamic value) {
    if (value == null) return 0.0;
    final str = value.toString().replaceAll('%', '');
    return double.tryParse(str) ?? 0.0;
  }
}

/// 📊 ENUM: Estado de salud del sistema de sincronización
enum SyncHealthStatus {
  excellent, // > 90% success rate, online
  good, // 70-90% success rate
  warning, // 50-70% success rate
  critical, // < 50% success rate
  offline, // Sin conectividad
}

/// 📊 EXTENSION: Helpers para SyncHealthStatus
extension SyncHealthStatusExtension on SyncHealthStatus {
  String get displayName {
    switch (this) {
      case SyncHealthStatus.excellent:
        return 'Excelente';
      case SyncHealthStatus.good:
        return 'Bueno';
      case SyncHealthStatus.warning:
        return 'Advertencia';
      case SyncHealthStatus.critical:
        return 'Crítico';
      case SyncHealthStatus.offline:
        return 'Sin conexión';
    }
  }

  String get description {
    switch (this) {
      case SyncHealthStatus.excellent:
        return 'Sistema funcionando perfectamente';
      case SyncHealthStatus.good:
        return 'Sistema funcionando bien';
      case SyncHealthStatus.warning:
        return 'Algunos problemas de sincronización';
      case SyncHealthStatus.critical:
        return 'Problemas graves de sincronización';
      case SyncHealthStatus.offline:
        return 'Sin conectividad a internet';
    }
  }

  String get icon {
    switch (this) {
      case SyncHealthStatus.excellent:
        return '🟢';
      case SyncHealthStatus.good:
        return '🟡';
      case SyncHealthStatus.warning:
        return '🟠';
      case SyncHealthStatus.critical:
        return '🔴';
      case SyncHealthStatus.offline:
        return '📡';
    }
  }
}
