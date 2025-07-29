import 'package:drift/drift.dart';

/// Sync queue for granular operations per JSONB field
/// Tracks changes to specific fields for efficient synchronization
@DataClassName('SyncQueueData')
class SyncQueue extends Table {
  /// Auto-increment primary key
  IntColumn get id => integer().autoIncrement()();

  /// Type of operation being tracked
  /// Allowed values: create, update_categories_field, update_grades_field, delete
  TextColumn get operationType =>
      text()
          .named('operation_type')
          .check(
            operationType.isIn([
              'create',
              'update_categories_field',
              'update_grades_field',
              'update_metadata_field',
              'delete',
            ]),
          )();

  /// Entity type - currently always 'course_grade_simulator'
  TextColumn get entityType =>
      text()
          .named('entity_type')
          .withDefault(const Constant('course_grade_simulator'))();

  /// Foreign key to course_grade_simulator.course_key
  /// Format: studentCode_courseCode (e.g., "2021001234_MAT101")
  TextColumn get entityKey => text().named('entity_key')();

  /// Field name that was modified (categories, grades, metadata)
  /// NULL for complete operations (create, delete)
  TextColumn get fieldName => text().named('field_name').nullable()();

  /// JSON with operation details for synchronization
  /// Contains the actual data that needs to be synced
  TextColumn get operationData => text().named('operation_data')();

  /// When the operation was created (milliseconds since epoch)
  IntColumn get timestamp =>
      integer().withDefault(
        const CustomExpression("(strftime('%s','now')*1000)"),
      )();

  /// Number of retry attempts (for failed syncs)
  IntColumn get retryCount =>
      integer()
          .named('retry_count')
          .withDefault(const Constant(0))
          .check(retryCount.isBiggerOrEqualValue(0))();

  /// Current status of the sync operation
  /// Allowed values: pending, processing, synced, failed
  TextColumn get status =>
      text()
          .withDefault(const Constant('pending'))
          .check(status.isIn(['pending', 'processing', 'synced', 'failed']))();

  @override
  String get tableName => 'sync_queue';

  @override
  List<Set<Column>>? get uniqueKeys => []; // Empty list instead of null
}
