import 'package:drift/drift.dart';

/// Course Grade Simulator table - JSONB hybrid approach for performance
/// Stores categories, grades, and metadata as JSON for flexible schema
@DataClassName('CourseGradeSimulatorData')
class LocalCourseGradeSimulator extends Table {
  /// Primary key UUID
  TextColumn get id =>
      text().named('id').withDefault(const Constant('uuid_generate_v4()'))();

  /// Student code (e.g., "2021001234")
  TextColumn get studentCode => text().named('student_code')();

  /// Course code (e.g., "MAT101")
  TextColumn get courseCode => text().named('course_code')();

  /// Categories: [{"id": "uuid", "name": "Exámenes", "weight": 0.6}, ...]
  TextColumn get categories =>
      text().named('categories').withDefault(const Constant('[]'))();

  /// Grades: [{"id": "uuid", "categoryId": "uuid", "name": "Parcial 1", "score": 85, "enabled": true}, ...]
  TextColumn get grades =>
      text().named('grades').withDefault(const Constant('[]'))();

  /// Metadata: {"passScore": 60, "semester": "2025-1", "notifications": true, ...}
  TextColumn get metadata =>
      text().named('metadata').withDefault(const Constant('{}'))();

  /// Timestamp when record was created
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();

  /// Timestamp when record was last updated
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'course_grade_simulator';

  @override
  List<Set<Column>> get uniqueKeys => [
    {studentCode, courseCode},
  ];
}
