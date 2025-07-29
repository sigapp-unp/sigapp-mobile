import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sigapp/core/infrastructure/database/local_database.dart';
import 'package:sigapp/core/config/environment_config.dart';
import 'package:sigapp/firebase_options.dart';

/// Responsible for the entire application initialization
/// - Load environment configuration
/// - Initialize Drift database
/// - Initialize Firebase (only in production)
@singleton
class AppInitializer {
  final LocalDatabase _database;
  final Logger _logger;

  AppInitializer(this._database, this._logger);

  Future<AppInitializationResult> initializeApp() async {
    _logger.i('[APP_INIT] 🚀 Starting application initialization...');

    try {
      // 1. Configure environment
      await EnvironmentConfig.loadEnvironment();
      _logger.d('[APP_INIT] ✅ Environment loaded');

      // 2. Initialize database (LocalDatabase handles migration automatically)
      await _database.init();
      _logger.d('[APP_INIT] ✅ Drift database initialization completed');

      // 3. Initialize Firebase (only in production)
      await _initializeFirebase();
      _logger.d('[APP_INIT] ✅ Firebase initialization completed');

      _logger.i('[APP_INIT] 🎉 Application initialization successful!');

      return AppInitializationResult(
        success: true,
        message: 'App initialized successfully',
      );
    } catch (e) {
      _logger.e('[APP_INIT] 💥 Application initialization failed: $e');

      return AppInitializationResult(
        success: false,
        message: 'Initialization failed: $e',
        error: e,
      );
    }
  }

  Future<void> _initializeFirebase() async {
    if (kDebugMode) {
      _logger.d('[APP_INIT] 🧪 Debug mode: Skipping Firebase initialization');
      return;
    }

    try {
      _logger.d('[APP_INIT] 🔥 Initializing Firebase...');

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Capture unhandled async errors
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      _logger.i('[APP_INIT] ✅ Firebase initialized successfully');
    } catch (e) {
      _logger.e('[APP_INIT] ❌ Firebase initialization failed: $e');
      rethrow;
    }
  }
}

/// Resultado de la inicialización de la aplicación
class AppInitializationResult {
  final bool success;
  final String message;
  final Object? error;

  AppInitializationResult({
    required this.success,
    required this.message,
    this.error,
  });

  @override
  String toString() =>
      'AppInitializationResult(success: $success, message: $message)';
}
