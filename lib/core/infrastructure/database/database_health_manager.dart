import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

/// Responsible for the health, verification and recovery of the database
@singleton
class DatabaseHealthManager {
  final Logger _logger;

  DatabaseHealthManager(this._logger);

  /// Verify the basic health
  /// - Check if the required tables exist
  Future<bool> _isDatabaseHealthy(Database database) async {
    try {
      final tables = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );

      final tableNames = tables.map((t) => t['name'] as String).toSet();
      final requiredTables = {'course_grade_simulator', 'sync_queue'};

      final isHealthy = requiredTables.every(
        (table) => tableNames.contains(table),
      );
      _logger.d(
        '[DB_HEALTH] Health check result: ${isHealthy ? '✅ Healthy' : '❌ Unhealthy'}',
      );
      return isHealthy;
    } catch (e) {
      _logger.e('[DB_HEALTH] ❌ Database health check failed: $e');
      return false;
    }
  }

  /// Diagnostic with auto-recovery
  /// - Check if the required tables exist
  /// - If the database is unhealthy, attempt to recover it
  Future<DatabaseHealthStatus> performHealthCheck(
    Database database,
    Future<void> Function() resetDatabaseCallback,
  ) async {
    try {
      _logger.d('[DB_HEALTH] 🔍 Starting database health check...');

      final isHealthy = await _isDatabaseHealthy(database);

      if (isHealthy) {
        _logger.i('[DB_HEALTH] ✅ Database is healthy');
        return DatabaseHealthStatus.healthy;
      }

      _logger.w('[DB_HEALTH] ⚠️ Database is unhealthy, attempting recovery...');

      await resetDatabaseCallback();

      final isHealthyAfterReset = await _isDatabaseHealthy(database);

      if (isHealthyAfterReset) {
        _logger.i('[DB_HEALTH] 🔄 Database recovered successfully');
        return DatabaseHealthStatus.recovered;
      } else {
        _logger.e('[DB_HEALTH] ❌ Database could not be recovered');
        return DatabaseHealthStatus.critical;
      }
    } catch (e) {
      _logger.e('[DB_HEALTH] 💥 Critical error during health check: $e');
      return DatabaseHealthStatus.critical;
    }
  }
}

enum DatabaseHealthStatus { healthy, recovered, critical }
