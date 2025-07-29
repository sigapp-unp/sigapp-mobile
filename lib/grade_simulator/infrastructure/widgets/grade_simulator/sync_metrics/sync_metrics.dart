import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:sigapp/grade_simulator/infrastructure/services/sync_manager.dart';

/// Bypasses complex cubit/dashboard and reads directly from SyncManager
/// Perfect for debugging without over-engineering
class SyncMetricWidget extends StatelessWidget {
  const SyncMetricWidget({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final syncManager = GetIt.instance<GradeSimulatorSyncManager>();
      final stats = syncManager.basicStats;

      return _buildCompactMetrics(stats, syncManager.isOfflineMode);
    } catch (e) {
      return _buildErrorState();
    }
  }

  Widget _buildCompactMetrics(Map<String, dynamic> stats, bool isOffline) {
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
                'Sync Stats (Lean)',
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
                  color: _getStatusColor(isOffline, stats).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusIcon(isOffline, stats),
                  style: TextStyle(
                    fontSize: 10,
                    color: _getStatusColor(isOffline, stats),
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
                value: stats['success_rate'] as String? ?? '0%',
                label: 'Success',
              ),
              _buildMiniMetric(
                icon: '🔄',
                value: _formatCount(
                  stats['total_operations_processed'] as int? ?? 0,
                ),
                label: 'Processed',
              ),
              _buildMiniMetric(
                icon: '📡',
                value: isOffline ? 'OFF' : 'ON',
                label: 'Net',
              ),
              _buildMiniMetric(
                icon: '📦',
                value: stats['pending_operations'].toString(),
                label: 'Pending',
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

  Color _getStatusColor(bool isOffline, Map<String, dynamic> stats) {
    if (isOffline) return Colors.grey;
    final failed = stats['failed_operations'] as int? ?? 0;
    if (failed > 0) return Colors.orange;
    return Colors.green;
  }

  String _getStatusIcon(bool isOffline, Map<String, dynamic> stats) {
    if (isOffline) return '⚫';
    final failed = stats['failed_operations'] as int? ?? 0;
    if (failed > 0) return '🟡';
    return '🟢';
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
