import 'dart:async';
import 'package:logger/logger.dart';
import 'package:sigapp/auth/domain/services/toast_service.dart';

/// Manages debounced operations to prevent excessive API calls
/// when users perform rapid actions (like toggling preferences).
class DebounceManager {
  final ToastService? _toastService;
  final Logger? _logger;
  final Duration _defaultDuration;
  final Map<String, Timer> _timers = {};

  DebounceManager({
    ToastService? toastService,
    Logger? logger,
    Duration defaultDuration = const Duration(seconds: 5),
  }) : _toastService = toastService,
       _logger = logger,
       _defaultDuration = defaultDuration;

  /// Executes an operation with debouncing.
  ///
  /// [key] - Unique identifier for this debounced operation
  /// [operation] - The async operation to execute after debounce delay
  /// [duration] - Custom duration (defaults to 5 seconds)
  /// [errorMessage] - Custom error message for toast (optional)
  void debounce({
    required String key,
    required Future<void> Function() operation,
    Duration? duration,
    String? errorMessage,
  }) {
    // Cancel previous timer for this key
    _timers[key]?.cancel();

    // Schedule new operation
    _timers[key] = Timer(duration ?? _defaultDuration, () async {
      try {
        await operation();
        _logger?.d('[DEBOUNCE] Operation completed for key: $key');
      } catch (e, s) {
        _logger?.e(
          '[DEBOUNCE] Error in operation for key: $key',
          error: e,
          stackTrace: s,
        );

        // Show error toast if service available
        if (_toastService != null) {
          final message =
              errorMessage ??
              'Error guardando configuración. El cambio se mantiene localmente.';
          _toastService.show(message, isError: true);
        }
      } finally {
        // Clean up completed timer
        _timers.remove(key);
      }
    });
  }

  /// Cancels a specific debounced operation
  void cancel(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
  }

  /// Cancels all pending operations
  void cancelAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }

  /// Gets count of pending operations (useful for testing)
  int get pendingCount => _timers.length;

  /// Disposes the manager and cancels all timers
  void dispose() {
    cancelAll();
  }
}

/// Mixin that provides debounce functionality to Cubits
mixin DebounceMixin {
  DebounceManager? _debounceManager;

  /// Initializes the debounce manager with optional services
  void initDebounce({
    ToastService? toastService,
    Logger? logger,
    Duration defaultDuration = const Duration(seconds: 5),
  }) {
    _debounceManager = DebounceManager(
      toastService: toastService,
      logger: logger,
      defaultDuration: defaultDuration,
    );
  }

  /// Executes a debounced operation
  void debouncedSave({
    required String key,
    required Future<void> Function() operation,
    Duration? duration,
    String? errorMessage,
  }) {
    if (_debounceManager == null) {
      throw StateError(
        'DebounceManager not initialized. Call initDebounce() first.',
      );
    }

    _debounceManager!.debounce(
      key: key,
      operation: operation,
      duration: duration,
      errorMessage: errorMessage,
    );
  }

  /// Cancels a specific debounced operation
  void cancelDebounce(String key) {
    _debounceManager?.cancel(key);
  }

  /// Must be called in cubit's close() method
  void disposeDebounce() {
    _debounceManager?.dispose();
    _debounceManager = null;
  }
}
