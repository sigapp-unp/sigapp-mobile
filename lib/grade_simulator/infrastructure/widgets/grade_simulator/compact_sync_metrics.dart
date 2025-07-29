import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sigapp/grade_simulator/application/usecases/get_sync_metrics_use_case.dart';
import 'package:sigapp/grade_simulator/infrastructure/widgets/grade_simulator/sync_metrics_cubit.dart';

/// Compact synchronization metrics widget for dialogs
///
/// Features:
/// - Minimal, geek-friendly display
/// - Single row with key metrics
/// - No refresh/reset buttons (discrete)
/// - Perfect for help dialogs
class CompactSyncMetricsWidget extends StatelessWidget {
  const CompactSyncMetricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncMetricsCubit, SyncMetricsState>(
      builder: (context, state) {
        if (state is SyncMetricsLoaded) {
          return _buildCompactMetrics(context, state.dashboard);
        } else if (state is SyncMetricsError) {
          return _buildErrorState();
        } else if (state is SyncMetricsLoading) {
          return _buildLoadingState();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCompactMetrics(
    BuildContext context,
    SyncMetricsDashboard dashboard,
  ) {
    final summary = dashboard.executiveSummary;
    final status = dashboard.healthStatus;

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header discreto
          Row(
            children: [
              Icon(MdiIcons.chartLine, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Sync Stats',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              // Status indicator compacto
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.icon,
                  style: TextStyle(
                    fontSize: 10,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Métricas clave en una sola fila
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniMetric(
                icon: '✅',
                value: summary['Sync Success Rate'] ?? '0%',
                label: 'Success',
              ),
              _buildMiniMetric(
                icon: '🔄',
                value: _formatOperationsCount(
                  summary['Total Operations'] ?? '0',
                ),
                label: 'Ops',
              ),
              _buildMiniMetric(
                icon: '📡',
                value: dashboard.isOfflineMode ? 'OFF' : 'ON',
                label: 'Net',
              ),
              _buildMiniMetric(
                icon: '📦',
                value: summary['Batches Processed'] ?? '0',
                label: 'Batches',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric({
    required String icon,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 10)),
            const SizedBox(width: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading sync stats...',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 12, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Text(
            'Sync stats unavailable',
            style: TextStyle(fontSize: 11, color: Colors.red.shade600),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(SyncHealthStatus status) {
    switch (status) {
      case SyncHealthStatus.excellent:
        return Colors.green;
      case SyncHealthStatus.good:
        return Colors.blue;
      case SyncHealthStatus.warning:
        return Colors.orange;
      case SyncHealthStatus.critical:
        return Colors.red;
      case SyncHealthStatus.offline:
        return Colors.grey;
    }
  }

  String _formatOperationsCount(String count) {
    final num = int.tryParse(count) ?? 0;
    if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}k';
    }
    return count;
  }
}
