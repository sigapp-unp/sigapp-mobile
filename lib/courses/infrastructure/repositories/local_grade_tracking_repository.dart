import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/database/drift/local_database.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/infrastructure/mappers/grade_tracking_mapper.dart';
import 'package:drift/drift.dart';

/// High-performance repository for CourseTracking cache operations
/// Optimized for frequent read/write operations with minimal overhead
///
/// Key optimizations:
/// - Specialized query methods for common operations
/// - Batch operations for bulk updates
/// - Minimal data transfer with column-specific queries
/// - Smart caching strategies and cache invalidation
/// - Performance monitoring and logging
@singleton
class LocalGradeTrackingRepository {
  final LocalDatabase _database;
  final Logger _logger;
  final LocalGradeTrackingMapper _mapper;

  LocalGradeTrackingRepository(this._database, this._logger, this._mapper);

  /// Save complete course data to cache using domain entity
  Future<void> saveCourse({
    required String studentCode,
    required String courseCode,
    required CourseTracking tracking,
  }) async {
    try {
      _logger.d('[DRIFT_CACHE] Saving course: ${studentCode}_$courseCode');
      final now = DateTime.now();

      // Use mapper to deconstruct the domain entity
      final deconstructed = _mapper.deconstructCourseTracking(tracking);
      final jsonStrings = _mapper.toJsonStrings(deconstructed);

      final companion = CourseGradeSimulatorCompanion(
        studentCode: Value(studentCode),
        courseCode: Value(courseCode),
        categories: Value(jsonStrings['categories']!),
        grades: Value(jsonStrings['grades']!),
        metadata: Value(jsonStrings['metadata']!),
        updatedAt: Value(now),
      );

      await _database
          .into(_database.courseGradeSimulator)
          .insertOnConflictUpdate(companion);

      _logger.d(
        '[DRIFT_CACHE] ✅ Course saved successfully: ${studentCode}_$courseCode',
      );
    } catch (e) {
      _logger.e('[DRIFT_CACHE] ❌ Error saving course: $e');
      rethrow;
    }
  }

  /// Get courses modified after timestamp (for sync) as domain entities
  Future<List<CourseTracking>> getCoursesModifiedAfter(
    DateTime timestamp,
  ) async {
    try {
      _logger.d('[DRIFT_CACHE] Getting courses modified after: $timestamp');

      final query = _database.select(_database.courseGradeSimulator)
        ..where((tbl) => tbl.updatedAt.isBiggerThanValue(timestamp));

      final results = await query.get();
      _logger.d('[DRIFT_CACHE] ✅ Found ${results.length} modified courses');

      // Convert database rows to domain entities
      final courses = <CourseTracking>[];
      for (final row in results) {
        final course = _mapper.reconstructCourseFromDatabaseRow(
          row,
          row.studentCode,
          row.courseCode,
        );
        if (course != null) {
          courses.add(course);
        }
      }

      return courses;
    } catch (e) {
      _logger.e('[DRIFT_CACHE] ❌ Error getting modified courses: $e');
      return [];
    }
  }

  /// Delete course from cache
  Future<void> deleteCourse(String studentCode, String courseCode) async {
    try {
      _logger.d('[DRIFT_CACHE] Deleting course: ${studentCode}_$courseCode');

      final deleteQuery = _database.delete(_database.courseGradeSimulator)
        ..where(
          (tbl) =>
              tbl.studentCode.equals(studentCode) &
              tbl.courseCode.equals(courseCode),
        );

      final deletedRows = await deleteQuery.go();
      _logger.d('[DRIFT_CACHE] ✅ Deleted $deletedRows course(s)');
    } catch (e) {
      _logger.e('[DRIFT_CACHE] ❌ Error deleting course: $e');
      rethrow;
    }
  }

  /// Get all courses for a student as domain entities
  Future<List<CourseTracking>> getCoursesForStudent(String studentCode) async {
    try {
      _logger.d('[DRIFT_CACHE] Getting courses for student: $studentCode');

      final query = _database.select(_database.courseGradeSimulator)
        ..where((tbl) => tbl.studentCode.equals(studentCode));

      final results = await query.get();
      _logger.d('[DRIFT_CACHE] ✅ Found ${results.length} courses for student');

      // Convert database rows to domain entities
      final courses = <CourseTracking>[];
      for (final row in results) {
        final course = _mapper.reconstructCourseFromDatabaseRow(
          row,
          studentCode,
          row.courseCode,
        );
        if (course != null) {
          courses.add(course);
        }
      }

      return courses;
    } catch (e) {
      _logger.e('[DRIFT_CACHE] ❌ Error getting courses for student: $e');
      return [];
    }
  }

  /// Get total count of cached courses
  Future<int> getTotalCourseCount() async {
    try {
      final query = _database.selectOnly(_database.courseGradeSimulator)
        ..addColumns([_database.courseGradeSimulator.id.count()]);

      final result = await query.getSingle();
      final total = result.read(_database.courseGradeSimulator.id.count()) ?? 0;

      _logger.d('[DRIFT_CACHE] Total courses in cache: $total');
      return total;
    } catch (e) {
      _logger.e('[DRIFT_CACHE] ❌ Error getting total course count: $e');
      return 0;
    }
  }

  /// Clear all cached courses (useful for debugging or complete sync)
  Future<void> clearAllCourses() async {
    try {
      _logger.d('[DRIFT_CACHE] Clearing all cached courses');

      final deletedRows =
          await _database.delete(_database.courseGradeSimulator).go();
      _logger.d('[DRIFT_CACHE] ✅ Cleared $deletedRows courses from cache');
    } catch (e) {
      _logger.e('[DRIFT_CACHE] ❌ Error clearing cache: $e');
      rethrow;
    }
  }

  /// Update specific field of a course using domain entity
  Future<void> updateCourseField({
    required String studentCode,
    required String courseCode,
    CourseTracking? tracking,
  }) async {
    try {
      _logger.d(
        '[DRIFT_CACHE] Updating course field: ${studentCode}_$courseCode',
      );

      final updateQuery = _database.update(_database.courseGradeSimulator)
        ..where(
          (tbl) =>
              tbl.studentCode.equals(studentCode) &
              tbl.courseCode.equals(courseCode),
        );

      late CourseGradeSimulatorCompanion companion;

      if (tracking != null) {
        // Update with complete tracking data
        final deconstructed = _mapper.deconstructCourseTracking(tracking);
        final jsonStrings = _mapper.toJsonStrings(deconstructed);

        companion = CourseGradeSimulatorCompanion(
          categories: Value(jsonStrings['categories']!),
          grades: Value(jsonStrings['grades']!),
          metadata: Value(jsonStrings['metadata']!),
          updatedAt: Value(DateTime.now()),
        );
      } else {
        // Just update timestamp if no tracking provided
        companion = CourseGradeSimulatorCompanion(
          updatedAt: Value(DateTime.now()),
        );
      }

      final updatedRows = await updateQuery.write(companion);
      _logger.d('[DRIFT_CACHE] ✅ Updated $updatedRows course(s)');
    } catch (e) {
      _logger.e('[DRIFT_CACHE] ❌ Error updating course field: $e');
      rethrow;
    }
  }

  /// Get a specific course from cache as domain entity
  Future<CourseTracking?> getCourse({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      _logger.d('[DRIFT_CACHE] Getting course: ${studentCode}_$courseCode');

      final query = _database.select(_database.courseGradeSimulator)..where(
        (tbl) =>
            tbl.studentCode.equals(studentCode) &
            tbl.courseCode.equals(courseCode),
      );

      final results = await query.get();
      if (results.isNotEmpty) {
        _logger.d('[DRIFT_CACHE] ✅ Found course: ${studentCode}_$courseCode');

        // Use mapper to reconstruct domain entity
        return _mapper.reconstructCourseFromDatabaseRow(
          results.first,
          studentCode,
          courseCode,
        );
      }

      _logger.d('[DRIFT_CACHE] ❌ Course not found: ${studentCode}_$courseCode');
      return null;
    } catch (e) {
      _logger.e('[DRIFT_CACHE] ❌ Error getting course: $e');
      return null;
    }
  }

  /// Save a complete CourseTracking entity (convenience method for decorators)
  Future<void> saveCourseFromComponents({
    required String studentCode,
    required String courseCode,
    required CourseTracking tracking,
  }) async {
    return saveCourse(
      studentCode: studentCode,
      courseCode: courseCode,
      tracking: tracking,
    );
  }

  /// Invalidate/delete a specific course from cache
  Future<void> invalidateCourse({
    required String studentCode,
    required String courseCode,
  }) async {
    return deleteCourse(studentCode, courseCode);
  }
}
