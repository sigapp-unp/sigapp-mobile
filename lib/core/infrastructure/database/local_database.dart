import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sigapp/grade_simulator/infrastructure/database/local_course_grade_simulator.dart';
import 'package:sigapp/grade_simulator/infrastructure/database/sync_queue.dart';

part 'local_database.g.dart';

/// Main Drift database class for SigApp
/// Handles course grade simulation with JSONB hybrid approach for performance
@DriftDatabase(tables: [LocalCourseGradeSimulator, SyncQueue])
@singleton
class LocalDatabase extends _$LocalDatabase {
  final Logger _logger;

  LocalDatabase(this._logger) : super(_openConnection());

  @override
  int get schemaVersion => 2; // v1=old sqflite, v2=Drift (current and new)

  MigrationStrategy get migrationStrategy => MigrationStrategy(
    onCreate: (Migrator m) async {
      _logger.d('[DRIFT_DB] Creating all tables and triggers...');
      await m.createAll();
      await _createCustomIndexes();
      await _createTriggers();
      _logger.i('[DRIFT_DB] ✅ Database schema created successfully');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      _logger.i('[DRIFT_DB] 🔄 Migrating database from v$from to v$to');

      if (from == 1) {
        // Migration from old sqflite (v1) to Drift (v2)
        await _migrateFromSqfliteV1ToDrift(m);
      }

      // Future Drift-only migrations would go here
      // if (from < 3) { ... }
    },
  );

  /// Open database connection with Flutter-optimized settings
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name:
          'sigapp.db', // Same name as before - Drift will handle migration automatically
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  /// Create custom indexes for performance optimization
  Future<void> _createCustomIndexes() async {
    _logger.d('[DRIFT_DB] Creating performance indexes...');

    // Index for last_modified_categories queries
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_course_tracking_categories_modified
      ON course_grade_simulator(last_modified_categories)
    ''');

    // Index for last_modified_grades queries
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_course_tracking_grades_modified
      ON course_grade_simulator(last_modified_grades)
    ''');

    // Index for last_modified_metadata queries
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_course_tracking_metadata_modified
      ON course_grade_simulator(last_modified_metadata)
    ''');

    // Composite index for efficient sync queue processing
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_queue_status_field
      ON sync_queue(status, field_name, timestamp)
    ''');

    // Index for retry logic in sync queue
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_queue_retry
      ON sync_queue(retry_count, timestamp)
    ''');

    _logger.d('[DRIFT_DB] ✅ All performance indexes created');
  }

  /// Create database triggers for automatic timestamp updates
  Future<void> _createTriggers() async {
    _logger.d('[DRIFT_DB] Creating automatic timestamp triggers...');

    // Trigger: Update last_modified_categories when categories_json changes
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS trg_update_last_modified_categories
      AFTER UPDATE OF categories_json ON course_grade_simulator
      BEGIN
        UPDATE course_grade_simulator
          SET last_modified_categories = (strftime('%s','now')*1000)
        WHERE course_key = NEW.course_key;
      END;
    ''');

    // Trigger: Update last_modified_grades when grades_json changes
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS trg_update_last_modified_grades
      AFTER UPDATE OF grades_json ON course_grade_simulator
      BEGIN
        UPDATE course_grade_simulator
          SET last_modified_grades = (strftime('%s','now')*1000)
        WHERE course_key = NEW.course_key;
      END;
    ''');

    // Trigger: Update last_modified_metadata when metadata_json changes
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS trg_update_last_modified_metadata
      AFTER UPDATE OF metadata_json ON course_grade_simulator
      BEGIN
        UPDATE course_grade_simulator
          SET last_modified_metadata = (strftime('%s','now')*1000)
        WHERE course_key = NEW.course_key;
      END;
    ''');

    // Verify triggers were created
    final triggerCount =
        await customSelect(
          "SELECT COUNT(*) as count FROM sqlite_master WHERE type='trigger'",
        ).getSingle();

    _logger.d('[DRIFT_DB] ✅ Created ${triggerCount.data['count']} triggers');
  }

  /// Migration from old sqflite v1 to Drift v2
  Future<void> _migrateFromSqfliteV1ToDrift(Migrator m) async {
    _logger.w('[DRIFT_DB] 🔄 Migrating from old sqflite v1 to Drift v2...');

    try {
      // Enable foreign key constraints
      await customStatement('PRAGMA foreign_keys = ON');

      // Check if tables from old implementation exist and have data
      final courseTableExists = await _checkTableExists(
        'course_grade_simulator',
      );
      final syncTableExists = await _checkTableExists('sync_queue');

      if (courseTableExists) {
        _logger.d(
          '[DRIFT_DB] Found existing course_grade_simulator table from sqflite v1',
        );
        // Table structure should be compatible, just ensure indexes exist
      } else {
        _logger.d('[DRIFT_DB] Creating new course_grade_simulator table');
        await m.createTable(localCourseGradeSimulator);
      }

      if (syncTableExists) {
        _logger.d('[DRIFT_DB] Found existing sync_queue table from sqflite v1');
      } else {
        _logger.d('[DRIFT_DB] Creating new sync_queue table');
        await m.createTable(syncQueue);
      }

      // Ensure all indexes and triggers are created
      await _createCustomIndexes();
      await _createTriggers();

      _logger.i(
        '[DRIFT_DB] ✅ Migration from sqflite v1 to Drift v2 completed successfully',
      );
    } catch (e) {
      _logger.e('[DRIFT_DB] ❌ Migration failed: $e');
      rethrow;
    }
  }

  /// Check if a table exists in the database
  Future<bool> _checkTableExists(String tableName) async {
    final result =
        await customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
          variables: [Variable.withString(tableName)],
        ).get();

    return result.isNotEmpty;
  }

  /// Emergency database reset (for development)
  Future<void> resetDatabase() async {
    try {
      _logger.w('[DRIFT_DB] 🆘 Performing emergency database reset...');

      // Drop all tables
      await customStatement('DROP TABLE IF EXISTS course_grade_simulator');
      await customStatement('DROP TABLE IF EXISTS sync_queue');

      // Recreate schema
      final migrator = createMigrator();
      await migrator.createAll();
      await _createCustomIndexes();
      await _createTriggers();

      _logger.i('[DRIFT_DB] ✅ Database reset completed');
    } catch (e) {
      _logger.e('[DRIFT_DB] ❌ Error resetting database: $e');
      rethrow;
    }
  }

  /// Get database statistics for monitoring
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final courseCount = await (select(localCourseGradeSimulator).get()).then(
        (rows) => rows.length,
      );
      final syncQueueCount = await (select(syncQueue).get()).then(
        (rows) => rows.length,
      );
      final pendingSyncCount = await (select(syncQueue)..where(
        (tbl) => tbl.status.equals('pending'),
      )).get().then((rows) => rows.length);

      return {
        'courses': courseCount,
        'sync_queue_total': syncQueueCount,
        'sync_queue_pending': pendingSyncCount,
        'database_version': schemaVersion,
      };
    } catch (e) {
      _logger.e('[DRIFT_DB] ❌ Error getting database stats: $e');
      return {};
    }
  }

  @postConstruct
  Future<void> init() async {
    _logger.d('[DRIFT_DB] Initializing Drift database...');
    // Database will be opened automatically when first accessed
    // But we can run a simple query to ensure it's working
    try {
      await getDatabaseStats();
      _logger.i('[DRIFT_DB] ✅ Drift database initialized successfully');
    } catch (e) {
      _logger.e('[DRIFT_DB] ❌ Failed to initialize database: $e');
      rethrow;
    }
  }
}
