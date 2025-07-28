import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

@singleton
class SQLiteClientManager {
  static const String _dbName = 'sigapp.db';
  static const int _dbVersion = 2;

  Database? _database;

  final Logger _logger;

  SQLiteClientManager(this._logger);

  @PostConstruct()
  Future<void> init() async {
    _logger.d('[LOCAL_DB] Initializing JSONB hybrid database...');
    final String path = join(await getDatabasesPath(), _dbName);

    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    _logger.i('[LOCAL_DB] ✅ Database initialized successfully');
  }

  Database get db {
    if (_database == null) {
      throw Exception('[LOCAL_DB] Database not initialized! Call init() first');
    }
    return _database!;
  }

  /// Handles DB upgrades if there was a previous version.
  /// If there was a previous DB, here we would handle the migration.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _logger.i('[LOCAL_DB] 🔄 Migrating database from v$oldVersion to v$newVersion');
    
    if (oldVersion == 1) {
      // Migration from SQLiteClientManagerOld (v1) to SQLiteClientManager JSONB hybrid (v2)
      _logger.w('[LOCAL_DB] Migrating from SQLiteClientManagerOld to JSONB hybrid schema...');
      await _dropAllTables(db);
      await _onCreate(db, newVersion);
      _logger.i('[LOCAL_DB] ✅ Migration from SQLiteClientManagerOld completed successfully');
    }
    
    // Future migrations would go here when we increment _dbVersion > 2
    // if (oldVersion < 3) { ... }
  }

  /// Removes all tables (safe reset)
  Future<void> _dropAllTables(Database db) async {
    try {
      // Drop new JSONB hybrid tables
      await db.execute('DROP TABLE IF EXISTS course_grade_simulator');
      await db.execute('DROP TABLE IF EXISTS sync_queue');
      await db.execute('DROP TABLE IF EXISTS grade_tracking_cache');
      await db.execute('DROP TABLE IF EXISTS cache_table');
      
      // Drop legacy SQLiteClientManagerOld tables (migration cleanup)
      await db.execute('DROP TABLE IF EXISTS grades');
      await db.execute('DROP TABLE IF EXISTS grade_categories');
      await db.execute('DROP TABLE IF EXISTS course_tracking');
      
      _logger.d('[LOCAL_DB] ✅ All legacy and current tables dropped');
    } catch (e) {
      _logger.w('[DB_MIGRATION] Warning dropping tables: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    _logger.d('[LOCAL_DB] Creating JSONB hybrid database schema...');

    // Use transaction to create schema (sqflite best practices)
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE IF NOT EXISTS course_grade_simulator (
          course_key TEXT PRIMARY KEY,              -- studentCode_courseCode
          categories_json TEXT,                     -- Lista de GradeCategory serializada
          grades_json TEXT,                         -- Map<categoryId, List<Grade>> serializado
          metadata_json TEXT,                       -- Metadatos del curso serializado
          last_modified_categories INTEGER,         -- Timestamp última modificación categorías
          last_modified_grades INTEGER,             -- Timestamp última modificación notas
          last_modified_metadata INTEGER,           -- Timestamp última modificación metadata
          created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now') * 1000)
        )
      ''');

      // Sync queue para operaciones granulares por campo JSONB
      await txn.execute('''
        CREATE TABLE IF NOT EXISTS sync_queue (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          operation_type TEXT NOT NULL,         -- create, update_categories_field, update_grades_field, delete
          entity_type TEXT NOT NULL,            -- course_grade_simulator  
          entity_key TEXT NOT NULL,             -- course_key (studentCode_courseCode)
          field_name TEXT,                      -- categories, grades, metadata (null para operaciones completas)
          operation_data TEXT NOT NULL,         -- JSON con detalles del cambio
          timestamp INTEGER NOT NULL,           -- cuando se creó la operación
          retry_count INTEGER DEFAULT 0,
          status TEXT DEFAULT 'pending'         -- pending, processing, synced, failed
        )
      ''');
    });

    // Create indexes in batch for better performance
    await _createIndexesBatch(db);

    _logger.i('[LOCAL_DB] ✅ Database schema created successfully');
  }

  Future<void> _createIndexesBatch(Database db) async {
    final batch = db.batch();

    batch.execute('''
      CREATE INDEX IF NOT EXISTS idx_course_tracking_categories_modified
      ON course_grade_simulator(last_modified_categories)
    ''');

    batch.execute('''
      CREATE INDEX IF NOT EXISTS idx_course_tracking_grades_modified
      ON course_grade_simulator(last_modified_grades)
    ''');

    batch.execute('''
      CREATE INDEX IF NOT EXISTS idx_course_tracking_metadata_modified
      ON course_grade_simulator(last_modified_metadata)
    ''');

    // Composed index for efficient processing of sync queue
    batch.execute('''
      CREATE INDEX IF NOT EXISTS idx_sync_queue_status_field
      ON sync_queue(status, field_name, timestamp)
    ''');

    // Index for retry logic
    batch.execute('''
      CREATE INDEX IF NOT EXISTS idx_sync_queue_retry
      ON sync_queue(retry_count, timestamp)
    ''');

    // Commit batch for better performance
    try {
      await batch.commit(
        continueOnError: true,
      ); // Continues the batch even if some operations fail
      _logger.d('[LOCAL_DB] ✅ All indexes created successfully');
    } catch (e) {
      _logger.w('[LOCAL_DB] ⚠️ Some indexes failed to create: $e');
    }
  }

  // TODO: this is not being used, consider removing
  Future<List<Object?>> executeBatchOperations(
    List<Map<String, dynamic>> operations,
  ) async {
    final batch = db.batch();

    for (final operation in operations) {
      final type = operation['type'] as String;
      final table = operation['table'] as String;
      final data = operation['data'] as Map<String, dynamic>?;
      final where = operation['where'] as String?;
      final whereArgs = operation['whereArgs'] as List<dynamic>?;

      switch (type) {
        case 'insert':
          batch.insert(table, data!);
          break;
        case 'update':
          batch.update(table, data!, where: where, whereArgs: whereArgs);
          break;
        case 'delete':
          batch.delete(table, where: where, whereArgs: whereArgs);
          break;
      }
    }

    try {
      final results = await batch.commit();
      _logger.d(
        '[LOCAL_DB] ✅ Batch operations completed: ${operations.length} ops',
      );
      return results;
    } catch (e) {
      _logger.e('[LOCAL_DB] ❌ Batch operations failed: $e');
      rethrow;
    }
  }

  // TODO: this is not being used, consider removing
  Future<T> executeInTransaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    try {
      final result = await db.transaction(action);
      _logger.d('[LOCAL_DB] ✅ Transaction completed successfully');
      return result;
    } catch (e) {
      _logger.e('[LOCAL_DB] ❌ Transaction failed: $e');
      rethrow;
    }
  }

  Future<void> resetDatabase() async {
    try {
      _logger.w('[LOCAL_DB] 🆘 Performing emergency database reset...');
      final String path = join(await getDatabasesPath(), _dbName);
      await deleteDatabase(path);
      _database = null; // Force recreation
      await init(); // Re-inicializar después del reset
      _logger.i('[LOCAL_DB] ✅ Database reset completed');
    } catch (e) {
      _logger.e('[LOCAL_DB] ❌ Error resetting database: $e');
      rethrow;
    }
  }
}
