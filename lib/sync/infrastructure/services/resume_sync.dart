import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:sigapp/sync/infrastructure/services/sync_manager.dart';

/// Integrates with Flutter lifecycle for automatic sync on app resume
/// Handles connectivity recovery and background sync scenarios
@Singleton()
class GradeSimulatorResumeSync with WidgetsBindingObserver {
  final GradeSimulatorSyncManager _syncManager;
  final Logger _logger;
  DateTime? _lastSyncAttempt;
  DateTime? _lastBackgroundTime;

  GradeSimulatorResumeSync(this._syncManager, this._logger);

  /// Initialize lifecycle observer
  @PostConstruct()
  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    _logger.i('[LIFECYCLE_SYNC] Observer initialized');
  }

  /// Cleanup
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _logger.i('[LIFECYCLE_SYNC] Observer disposed');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastBackgroundTime = DateTime.now();
      _logger.d('[LIFECYCLE_SYNC] App went to background');
    } else if (state == AppLifecycleState.resumed) {
      final timeSinceBackground =
          _lastBackgroundTime != null
              ? DateTime.now().difference(_lastBackgroundTime!)
              : const Duration(seconds: 0);

      _handleAppResumeSync(timeSinceBackground);
    }
  }

  /// Manejar sync cuando app vuelve de background
  Future<void> _handleAppResumeSync(Duration timeSinceBackground) async {
    try {
      final now = DateTime.now();

      // Debounce: evitar múltiples syncs en quick resume (< 3s)
      if (_lastSyncAttempt != null &&
          now.difference(_lastSyncAttempt!) < const Duration(seconds: 3)) {
        _logger.d('[LIFECYCLE_SYNC] Skipping sync due to debounce');
        return;
      }

      _lastSyncAttempt = now;

      _logger.i(
        '[LIFECYCLE_SYNC] App resumed after ${timeSinceBackground.inSeconds}s, triggering sync...',
      );

      // ✅ MEJORADO: Primero intentar recovery de conectividad, luego sync
      await _syncManager.checkConnectivityRecovery();

      _logger.i('[LIFECYCLE_SYNC] App resume sync completed');
    } catch (e, s) {
      _logger.e(
        '[LIFECYCLE_SYNC] Error during app resume sync',
        error: e,
        stackTrace: s,
      );
      // No rethrow - sync failures shouldn't crash app resume
    }
  }

  /// Trigger manual sync (para debugging/testing)
  Future<void> triggerManualSync() async {
    _logger.i('[LIFECYCLE_SYNC] Manual sync triggered');
    await _syncManager.processPendingOperations();
  }
}
