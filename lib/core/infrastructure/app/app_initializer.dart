import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sigapp/core/infrastructure/database/sqlite_client_manager.dart';
import 'package:sigapp/core/infrastructure/database/database_health_manager.dart';
import 'package:sigapp/core/config/environment_config.dart';
import 'package:sigapp/firebase_options.dart';

/// Responsible for the entire application initialization
/// - Load environment configuration
/// - Initialize local database
/// - Initialize Firebase (only in production)
@singleton
class AppInitializer {
  final SQLiteClientManager _localDatabase;
  final DatabaseHealthManager _healthManager;
  final Logger _logger;

  AppInitializer(this._localDatabase, this._healthManager, this._logger);

  Future<AppInitializationResult> initializeApp() async {
    _logger.i('[APP_INIT] 🚀 Starting application initialization...');

    try {
      // 1. Configure environment
      await EnvironmentConfig.loadEnvironment();
      _logger.d('[APP_INIT] ✅ Environment loaded');

      // 2. Verify and initialize database
      final dbStatus = await _initializeDatabase();
      _logger.d('[APP_INIT] ✅ Database initialization completed: $dbStatus');

      // 3. Initialize Firebase (only in production)
      await _initializeFirebase();
      _logger.d('[APP_INIT] ✅ Firebase initialization completed');

      _logger.i('[APP_INIT] 🎉 Application initialization successful!');

      return AppInitializationResult(
        success: true,
        databaseStatus: dbStatus,
        message: 'App initialized successfully',
      );
    } catch (e) {
      _logger.e('[APP_INIT] 💥 Application initialization failed: $e');

      return AppInitializationResult(
        success: false,
        databaseStatus: DatabaseHealthStatus.critical,
        message: 'Initialization failed: $e',
        error: e,
      );
    }
  }

  Future<DatabaseHealthStatus> _initializeDatabase() async {
    _logger.d('[APP_INIT] 🗄️ Initializing database...');

    try {
      // Verificar salud de la base de datos
      final healthStatus = await _healthManager.performHealthCheck(
        _localDatabase.db,
        () async {
          _logger.w('[APP_INIT] 🆘 Performing database reset...');
          await _localDatabase.resetDatabase();
          // Re-inicializar después del reset
          await _localDatabase.init();
        },
      );

      switch (healthStatus) {
        case DatabaseHealthStatus.healthy:
          _logger.i('[APP_INIT] ✅ Database is healthy and ready');
          break;
        case DatabaseHealthStatus.recovered:
          _logger.i('[APP_INIT] 🔄 Database was recovered successfully');
          break;
        case DatabaseHealthStatus.critical:
          _logger.e('[APP_INIT] ❌ Database is in critical state');
          break;
      }

      return healthStatus;
    } catch (e) {
      _logger.e('[APP_INIT] 💥 Database initialization failed: $e');
      rethrow;
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
  final DatabaseHealthStatus databaseStatus;
  final String message;
  final Object? error;

  AppInitializationResult({
    required this.success,
    required this.databaseStatus,
    required this.message,
    this.error,
  });

  @override
  String toString() =>
      'AppInitializationResult(success: $success, db: $databaseStatus, message: $message)';
}
