import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../shared/infrastructure/pages/sync_metrics_cubit.dart';
import '../../application/use_cases/get_sync_metrics_use_case.dart';

/// Synchronization metrics dashboard widget
///
/// Features:
/// - Executive view with key metrics
/// - Auto-refresh every 5 seconds
/// - System health indicator
/// - Expandable details
/// - Reset and export actions
class SyncMetricsWidget extends StatelessWidget {
  const SyncMetricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncMetricsCubit, SyncMetricsState>(
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, state),
              const Divider(),
              _buildContent(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, SyncMetricsState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(MdiIcons.chartLine, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Métricas de Sincronización',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          _buildStatusIndicator(state),
          const SizedBox(width: 8),
          _buildActionButtons(context, state),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(SyncMetricsState state) {
    if (state is SyncMetricsLoaded) {
      final status = state.dashboard.healthStatus;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(status).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getStatusColor(status).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(status.icon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              status.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(status),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildActionButtons(BuildContext context, SyncMetricsState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Manual refresh button
        IconButton(
          icon: Icon(MdiIcons.refresh, size: 20),
          onPressed:
              state is SyncMetricsLoading
                  ? null
                  : () => context.read<SyncMetricsCubit>().loadMetrics(),
          tooltip: 'Refresh metrics',
        ),
        // Reset button
        IconButton(
          icon: Icon(MdiIcons.broom, size: 20),
          onPressed:
              state is SyncMetricsLoading
                  ? null
                  : () => _showResetDialog(context),
          tooltip: 'Reset metrics',
        ),
        // Export button
        IconButton(
          icon: Icon(MdiIcons.export, size: 20),
          onPressed:
              state is SyncMetricsLoading
                  ? null
                  : () => _exportMetrics(context),
          tooltip: 'Export metrics',
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, SyncMetricsState state) {
    if (state is SyncMetricsLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando métricas...'),
            ],
          ),
        ),
      );
    }

    if (state is SyncMetricsError) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(MdiIcons.alertCircle, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<SyncMetricsCubit>().loadMetrics(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is SyncMetricsLoaded) {
      return _buildMetricsDashboard(context, state.dashboard);
    }

    if (state is SyncMetricsReset) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.check_circle, size: 48, color: Colors.green),
              SizedBox(height: 16),
              Text('Métricas reseteadas exitosamente'),
            ],
          ),
        ),
      );
    }

    // Initial state
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(MdiIcons.chartBox, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Presiona el botón de actualizar para cargar métricas'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<SyncMetricsCubit>().initialize(),
              child: const Text('Cargar métricas'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsDashboard(
    BuildContext context,
    SyncMetricsDashboard dashboard,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthOverview(dashboard),
          const SizedBox(height: 16),
          _buildExecutiveSummary(dashboard),
          const SizedBox(height: 16),
          _buildDetailedMetrics(dashboard),
          const SizedBox(height: 16),
          _buildRecentEvents(dashboard),
        ],
      ),
    );
  }

  Widget _buildHealthOverview(SyncMetricsDashboard dashboard) {
    final status = dashboard.healthStatus;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(status.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'Estado: ${status.displayName}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(status),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            status.description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummary(SyncMetricsDashboard dashboard) {
    final summary = dashboard.executiveSummary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen Ejecutivo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              summary.entries.map((entry) {
                return _buildMetricChip(entry.key, entry.value);
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildMetricChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics(SyncMetricsDashboard dashboard) {
    return ExpansionTile(
      title: const Text('Métricas Detalladas'),
      leading: Icon(MdiIcons.chartBoxOutline),
      children: [
        _buildMetricSection('Sincronización', dashboard.syncStats),
        _buildMetricSection('Performance', dashboard.performanceStats),
        _buildMetricSection('Conectividad', dashboard.connectivityStats),
        _buildMetricSection('Batching', dashboard.batchingStats),
      ],
    );
  }

  Widget _buildMetricSection(String title, Map<String, dynamic> metrics) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 4),
          ...metrics.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.key.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                  Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRecentEvents(SyncMetricsDashboard dashboard) {
    if (dashboard.recentEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExpansionTile(
      title: const Text('Eventos Recientes'),
      leading: Icon(MdiIcons.history),
      children: [
        Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: dashboard.recentEvents.length,
            itemBuilder: (context, index) {
              final event = dashboard.recentEvents[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  event,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: Colors.grey[700],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
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

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resetear Métricas'),
          content: const Text(
            '¿Estás seguro de que quieres resetear todas las métricas de sincronización? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<SyncMetricsCubit>().resetMetrics();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Resetear'),
            ),
          ],
        );
      },
    );
  }

  void _exportMetrics(BuildContext context) {
    final cubit = context.read<SyncMetricsCubit>();
    final metricsString = cubit.exportMetrics();

    Clipboard.setData(ClipboardData(text: metricsString));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Métricas copiadas al portapapeles'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
