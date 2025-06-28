import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

/// Gestiona el ciclo de vida de la aplicación
class AppLifecycleManager with WidgetsBindingObserver {
  DateTime? _lastBackgroundTime;
  final Function(Duration) onAppResumed;
  final Function() onAppPaused;
  final Logger _logger;

  AppLifecycleManager({
    required this.onAppResumed,
    required this.onAppPaused,
    required Logger logger,
  }) : _logger = logger {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastBackgroundTime = DateTime.now();
      onAppPaused();
      _logger.i('[INFRASTRUCTURE] App entró en segundo plano');
    } else if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      final timeSinceBackground =
          _lastBackgroundTime != null
              ? now.difference(_lastBackgroundTime!)
              : const Duration(seconds: 0);

      _logger.i(
        '[INFRASTRUCTURE] App volvió a primer plano después de ${timeSinceBackground.inSeconds} segundos',
      );

      onAppResumed(timeSinceBackground);
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
