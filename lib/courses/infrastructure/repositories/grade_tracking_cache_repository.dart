import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/database/sqlite_client_manager.dart';
import 'package:sigapp/courses/domain/value_objects/course_key.dart';

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
class GradeTrackingCacheRepository {
  final SQLiteClientManager _database;
  final Logger _logger;

  GradeTrackingCacheRepository(this._database, this._logger);

  /// Get raw cached course data
  Future<Map<String, dynamic>?> getCachedCourseRaw(CourseKey courseKey) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );

      if (result.isEmpty) return null;
      return result.first;
    } catch (e) {
      _logger.e('[CACHE_REPO] ❌ Error getting cached course: $e');
      return null;
    }
  }

  /// Save complete course data to cache
  Future<void> saveCourseRaw({
    required CourseKey courseKey,
    required Map<String, dynamic> categoriesData,
    required Map<String, dynamic> gradesData,
    Map<String, dynamic>? metadataData,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      await _database.db.rawInsert(
        '''
        INSERT OR REPLACE INTO course_grade_simulator (
          course_key,
          categories_json,
          grades_json,
          metadata_json,
          last_modified_categories,
          last_modified_grades,
          last_modified_metadata
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
        [
          courseKey.value,
          jsonEncode(categoriesData),
          jsonEncode(gradesData),
          jsonEncode(metadataData ?? {}),
          now,
          now,
          now,
        ],
      );

      _logger.d('[CACHE_REPO] ✅ Saved complete course: ${courseKey.value}');
    } catch (e) {
      _logger.e('[CACHE_REPO] ❌ Error saving course: $e');
      rethrow;
    }
  }

  /// Invalidate/delete course tracking from cache
  Future<void> invalidateCourse(CourseKey courseKey) async {
    try {
      await _database.db.delete(
        'course_grade_simulator',
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );
      _logger.d('[CACHE_REPO] ✅ Invalidated course cache: ${courseKey.value}');
    } catch (e) {
      _logger.e('[CACHE_REPO] ❌ Error invalidating course: $e');
      rethrow;
    }
  }

  /// Check if course exists in cache
  Future<bool> existsInCache(CourseKey courseKey) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        columns: ['course_key'],
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );
      return result.isNotEmpty;
    } catch (e) {
      _logger.e('[CACHE_REPO] Error checking cache existence: $e');
      return false;
    }
  }

  /// Update only categories field (granular update)
  Future<void> updateCategoriesField({
    required CourseKey courseKey,
    required List<Map<String, dynamic>> categoriesData,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      await _database.db.update(
        'course_grade_simulator',
        {
          'categories_json': jsonEncode(categoriesData),
          'last_modified_categories': now,
        },
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );

      _logger.d('[CACHE_REPO] ✅ Updated categories field: ${courseKey.value}');
    } catch (e) {
      _logger.e('[CACHE_REPO] ❌ Error updating categories field: $e');
      rethrow;
    }
  }

  /// Update only grades field (granular update)
  Future<void> updateGradesField({
    required CourseKey courseKey,
    required Map<String, dynamic> gradesData,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      await _database.db.update(
        'course_grade_simulator',
        {'grades_json': jsonEncode(gradesData), 'last_modified_grades': now},
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );

      _logger.d('[CACHE_REPO] ✅ Updated grades field: ${courseKey.value}');
    } catch (e) {
      _logger.e('[CACHE_REPO] ❌ Error updating grades field: $e');
      rethrow;
    }
  }

  /// Get cached grades data only
  Future<Map<String, dynamic>?> getCachedGrades(CourseKey courseKey) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        columns: ['grades_json'],
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );

      if (result.isEmpty) return null;

      final gradesJson = result.first['grades_json'] as String?;
      if (gradesJson == null) return {};

      return jsonDecode(gradesJson) as Map<String, dynamic>;
    } catch (e) {
      _logger.e('[CACHE_REPO] Error getting cached grades: $e');
      return null;
    }
  }

  // 🚀 PERFORMANCE OPTIMIZED METHODS

  /// Get only categories data (minimal data transfer)
  Future<List<Map<String, dynamic>>?> getCachedCategoriesOnly(
    CourseKey courseKey,
  ) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        columns: ['categories_json'],
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );

      if (result.isEmpty) return null;

      final categoriesJson = result.first['categories_json'] as String?;
      if (categoriesJson == null) return [];

      final decoded = jsonDecode(categoriesJson) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      _logger.e('[CACHE_REPO] Error getting cached categories: $e');
      return null;
    }
  }

  /// Get course metadata for sync status checks
  Future<Map<String, dynamic>?> getCourseMetadata(CourseKey courseKey) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        columns: [
          'last_modified_categories',
          'last_modified_grades',
          'last_modified_metadata',
          'course_key',
        ],
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );

      return result.isEmpty ? null : result.first;
    } catch (e) {
      _logger.e('[CACHE_REPO] Error getting course metadata: $e');
      return null;
    }
  }

  /// Check multiple courses existence in batch (performance optimized)
  Future<Map<String, bool>> batchExistsInCache(
    List<CourseKey> courseKeys,
  ) async {
    if (courseKeys.isEmpty) return {};

    try {
      final whereClause = List.filled(courseKeys.length, '?').join(',');
      final result = await _database.db.query(
        'course_grade_simulator',
        columns: ['course_key'],
        where: 'course_key IN ($whereClause)',
        whereArgs: courseKeys.map((key) => key.value).toList(),
      );

      final existingKeys =
          result.map((row) => row['course_key'] as String).toSet();

      return {
        for (final key in courseKeys)
          key.value: existingKeys.contains(key.value),
      };
    } catch (e) {
      _logger.e('[CACHE_REPO] Error in batch exists check: $e');
      return {for (final key in courseKeys) key.value: false};
    }
  }

  /// Batch invalidate multiple courses (performance optimized)
  Future<void> batchInvalidateCourses(List<CourseKey> courseKeys) async {
    if (courseKeys.isEmpty) return;

    try {
      final whereClause = List.filled(courseKeys.length, '?').join(',');
      await _database.db.delete(
        'course_grade_simulator',
        where: 'course_key IN ($whereClause)',
        whereArgs: courseKeys.map((key) => key.value).toList(),
      );

      _logger.d(
        '[CACHE_REPO] ✅ Batch invalidated ${courseKeys.length} courses',
      );
    } catch (e) {
      _logger.e('[CACHE_REPO] ❌ Error in batch invalidation: $e');
      rethrow;
    }
  }

  /// Get all cached course keys for a student (useful for sync operations)
  Future<List<String>> getCachedCourseKeysForStudent(String studentCode) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        columns: ['course_key'],
        where: 'course_key LIKE ?',
        whereArgs: ['${studentCode}_%'],
      );

      return result.map((row) => row['course_key'] as String).toList();
    } catch (e) {
      _logger.e('[CACHE_REPO] Error getting course keys for student: $e');
      return [];
    }
  }

  /// Get cache statistics for monitoring
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      final totalResult = await _database.db.rawQuery(
        'SELECT COUNT(*) as total FROM course_grade_simulator',
      );
      final sizeResult = await _database.db.rawQuery('''
        SELECT 
          AVG(LENGTH(categories_json)) as avg_categories_size,
          AVG(LENGTH(grades_json)) as avg_grades_size,
          MAX(last_modified_categories) as latest_categories_update,
          MAX(last_modified_grades) as latest_grades_update
        FROM course_grade_simulator
      ''');

      return {
        'total_courses': totalResult.first['total'] ?? 0,
        'avg_categories_size': sizeResult.first['avg_categories_size'] ?? 0,
        'avg_grades_size': sizeResult.first['avg_grades_size'] ?? 0,
        'latest_categories_update':
            sizeResult.first['latest_categories_update'] ?? 0,
        'latest_grades_update': sizeResult.first['latest_grades_update'] ?? 0,
      };
    } catch (e) {
      _logger.e('[CACHE_REPO] Error getting cache statistics: $e');
      return {};
    }
  }

  /// Smart cache cleanup - remove old unused courses
  Future<int> cleanupOldCourses({int maxAgeMilliseconds = 2592000000}) async {
    // 30 days default
    try {
      final cutoffTime =
          DateTime.now().millisecondsSinceEpoch - maxAgeMilliseconds;

      final deletedCount = await _database.db.delete(
        'course_grade_simulator',
        where: 'last_modified_categories < ? AND last_modified_grades < ?',
        whereArgs: [cutoffTime, cutoffTime],
      );

      _logger.d('[CACHE_REPO] ✅ Cleaned up $deletedCount old courses');
      return deletedCount;
    } catch (e) {
      _logger.e('[CACHE_REPO] ❌ Error during cache cleanup: $e');
      return 0;
    }
  }

  // 🔧 INTERNAL OPTIMIZATION HELPERS

  /// Optimize specific fields for a course (used by sync operations)
  Future<void> touchCourseTimestamp(
    CourseKey courseKey, {
    bool updateCategories = false,
    bool updateGrades = false,
    bool updateMetadata = false,
  }) async {
    if (!updateCategories && !updateGrades && !updateMetadata) return;

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final updates = <String, dynamic>{};

      if (updateCategories) updates['last_modified_categories'] = now;
      if (updateGrades) updates['last_modified_grades'] = now;
      if (updateMetadata) updates['last_modified_metadata'] = now;

      await _database.db.update(
        'course_grade_simulator',
        updates,
        where: 'course_key = ?',
        whereArgs: [courseKey.value],
      );
    } catch (e) {
      _logger.w('[CACHE_REPO] Warning: Could not touch timestamps: $e');
    }
  }
}
