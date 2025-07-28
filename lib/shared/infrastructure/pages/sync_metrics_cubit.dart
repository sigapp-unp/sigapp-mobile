import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../courses/application/use_cases/get_sync_metrics_use_case.dart';

/// State management for synchronization metrics
///
/// Features:
/// - Auto-refresh every 5 seconds
/// - Loading, success and error states
/// - Reset and export actions
@injectable
class SyncMetricsCubit extends Cubit<SyncMetricsState> {
  final GetSyncMetricsUseCase _getSyncMetricsUseCase;
  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(seconds: 5);

  SyncMetricsCubit(this._getSyncMetricsUseCase) : super(SyncMetricsInitial());

  /// Initialize metrics and start auto-refresh
  void initialize() {
    loadMetrics();
    _startAutoRefresh();
  }

  /// Load metrics from SyncManager
  void loadMetrics() {
    emit(SyncMetricsLoading());

    try {
      final dashboard = _getSyncMetricsUseCase.execute();
      emit(SyncMetricsLoaded(dashboard));
    } catch (e) {
      emit(SyncMetricsError('Error al cargar métricas: $e'));
    }
  }

  /// Reset all metrics
  void resetMetrics() {
    try {
      _getSyncMetricsUseCase.resetMetrics();
      emit(SyncMetricsReset());

      // Reload after reset
      Timer(const Duration(milliseconds: 500), () {
        loadMetrics();
      });
    } catch (e) {
      emit(SyncMetricsError('Error resetting metrics: $e'));
    }
  }

  /// Export metrics as string
  String exportMetrics() {
    try {
      return _getSyncMetricsUseCase.exportMetricsAsString();
    } catch (e) {
      return 'Error exporting metrics: $e';
    }
  }

  /// Start auto-refresh of metrics
  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      if (state is SyncMetricsLoaded) {
        loadMetrics();
      }
    });
  }

  /// Pause auto-refresh
  void pauseAutoRefresh() {
    _refreshTimer?.cancel();
  }

  /// Resume auto-refresh
  void resumeAutoRefresh() {
    _startAutoRefresh();
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}

/// CUBIT STATES
abstract class SyncMetricsState {}

class SyncMetricsInitial extends SyncMetricsState {}

class SyncMetricsLoading extends SyncMetricsState {}

class SyncMetricsLoaded extends SyncMetricsState {
  final SyncMetricsDashboard dashboard;

  SyncMetricsLoaded(this.dashboard);
}

class SyncMetricsReset extends SyncMetricsState {}

class SyncMetricsError extends SyncMetricsState {
  final String message;

  SyncMetricsError(this.message);
}
