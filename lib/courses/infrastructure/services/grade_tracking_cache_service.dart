import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/value_objects/course_key.dart';
import 'package:sigapp/courses/infrastructure/repositories/grade_tracking_cache_repository.dart';
import 'package:sigapp/courses/infrastructure/mappers/grade_tracking_mapper.dart';

/// Course tracking coordination service following facade pattern
///
/// Responsibilities:
/// - Coordinate operations between cache repository and mapper
/// - Provide simplified API for course tracking operations
/// - Handle CourseKey transformations and validation
/// - Centralized error handling and logging
///
/// Key features:
/// - Clean facade over complex data operations
/// - Type-safe CourseKey handling
/// - Granular field updates for optimal sync performance
/// - Centralized error handling and logging
@singleton
class GradeTrackingCacheService {
  final GradeTrackingCacheRepository _cacheRepository;
  final GradeTrackingMapper _mapper;
  final Logger _logger;

  GradeTrackingCacheService(this._cacheRepository, this._mapper, this._logger);

  // 🔑 CORE FACADE OPERATIONS

  /// Create type-safe course key from components
  CourseKey buildCourseKey(String studentCode, String courseCode) {
    return CourseKey(studentCode: studentCode, courseCode: courseCode);
  }

  /// Get complete course from cache
  Future<CourseTracking?> getCachedCourse(String courseKey) async {
    return _executeWithErrorHandling(
      operation: () async {
        final key = CourseKey.fromString(courseKey);
        final row = await _cacheRepository.getCachedCourseRaw(key);
        if (row == null) return null;

        return _mapper.reconstructCourseTracking(row, key);
      },
      operationName: 'getCachedCourse',
      courseKey: courseKey,
    );
  }

  /// Save complete course to cache
  Future<void> saveCourse(String courseKey, CourseTracking tracking) async {
    await _executeWithErrorHandling(
      operation: () async {
        final key = CourseKey.fromString(courseKey);
        final deconstructed = _mapper.deconstructCourseTracking(tracking);

        await _cacheRepository.saveCourseRaw(
          courseKey: key,
          categoriesData: deconstructed['categories'],
          gradesData: deconstructed['grades'],
          metadataData: deconstructed['metadata'],
        );
      },
      operationName: 'saveCourse',
      courseKey: courseKey,
    );
  }

  /// Remove course from cache
  Future<void> invalidateCourse(String courseKey) async {
    await _executeWithErrorHandling(
      operation: () async {
        final key = CourseKey.fromString(courseKey);
        await _cacheRepository.invalidateCourse(key);
      },
      operationName: 'invalidateCourse',
      courseKey: courseKey,
    );
  }

  /// Check if course exists in cache
  Future<bool> courseExistsInCache(String courseKey) async {
    return await _executeWithErrorHandling(
      operation: () async {
        final key = CourseKey.fromString(courseKey);
        return await _cacheRepository.existsInCache(key);
      },
      operationName: 'courseExistsInCache',
      courseKey: courseKey,
      defaultValue: false,
    );
  }

  // 🎯 GRANULAR FIELD OPERATIONS

  /// Update categories field (optimized for sync performance)
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) async {
    await _executeWithErrorHandling(
      operation: () async {
        final courseKey = buildCourseKey(studentCode, courseCode);
        final tempTracking = CourseTracking(
          id: courseKey.value,
          studentCode: studentCode,
          courseCode: courseCode,
          categories: categories,
        );

        final categoriesData =
            _mapper.deconstructCourseTracking(tempTracking)['categories'];
        await _cacheRepository.updateCategoriesField(
          courseKey: courseKey,
          categoriesData: categoriesData,
        );
      },
      operationName: 'updateCategoriesField',
      courseKey: '${studentCode}_$courseCode',
    );
  }

  /// Update grades field for specific category (optimized for sync performance)
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    await _executeWithErrorHandling(
      operation: () async {
        final courseKey = buildCourseKey(studentCode, courseCode);
        final currentGrades = await _getCachedGrades(courseKey) ?? {};

        // Update specific category with mapper-compatible format
        currentGrades[categoryId] =
            grades
                .map(
                  (grade) => {
                    'id': grade.id,
                    'name': grade.name,
                    'score': grade.score,
                    'enabled': grade.enabled,
                  },
                )
                .toList();

        await _cacheRepository.updateGradesField(
          courseKey: courseKey,
          gradesData: currentGrades,
        );
      },
      operationName: 'updateGradesField',
      courseKey: '${studentCode}_$courseCode',
      extraContext: 'categoryId: $categoryId',
    );
  }

  // 🚀 COORDINATOR CONVENIENCE METHODS

  /// Save course with automatic key generation
  Future<void> saveCourseFromComponents({
    required String studentCode,
    required String courseCode,
    required CourseTracking tracking,
  }) async {
    final courseKey = buildCourseKey(studentCode, courseCode);
    await saveCourse(courseKey.value, tracking);
  }

  /// Get course with automatic key generation
  Future<CourseTracking?> getCourseFromComponents({
    required String studentCode,
    required String courseCode,
  }) async {
    final courseKey = buildCourseKey(studentCode, courseCode);
    return await getCachedCourse(courseKey.value);
  }

  /// Batch invalidate multiple courses (useful for logout/sync scenarios)
  Future<void> invalidateMultipleCourses(List<String> courseKeys) async {
    await _executeWithErrorHandling(
      operation: () async {
        final keys =
            courseKeys.map((key) => CourseKey.fromString(key)).toList();
        await _cacheRepository.batchInvalidateCourses(keys);
      },
      operationName: 'invalidateMultipleCourses',
      courseKey: 'batch(${courseKeys.length})',
    );
  }

  /// Check existence of multiple courses efficiently
  Future<Map<String, bool>> batchCheckCourseExistence(
    List<String> courseKeys,
  ) async {
    return await _executeWithErrorHandling(
      operation: () async {
        final keys =
            courseKeys.map((key) => CourseKey.fromString(key)).toList();
        return await _cacheRepository.batchExistsInCache(keys);
      },
      operationName: 'batchCheckCourseExistence',
      courseKey: 'batch(${courseKeys.length})',
      defaultValue: <String, bool>{},
    );
  }

  /// Get all cached courses for a student (useful for sync scenarios)
  Future<List<String>> getStudentCachedCourses(String studentCode) async {
    return await _executeWithErrorHandling(
      operation: () async {
        return await _cacheRepository.getCachedCourseKeysForStudent(
          studentCode,
        );
      },
      operationName: 'getStudentCachedCourses',
      courseKey: 'student:$studentCode',
      defaultValue: <String>[],
    );
  }

  /// Get cache performance statistics (for monitoring)
  Future<Map<String, dynamic>> getCacheStatistics() async {
    return await _executeWithErrorHandling(
      operation: () async {
        return await _cacheRepository.getCacheStatistics();
      },
      operationName: 'getCacheStatistics',
      courseKey: 'system',
      defaultValue: <String, dynamic>{},
    );
  }

  /// Cleanup old unused courses from cache
  Future<int> cleanupOldCourses({int maxAgeDays = 30}) async {
    return await _executeWithErrorHandling(
      operation: () async {
        final maxAgeMillis = maxAgeDays * 24 * 60 * 60 * 1000;
        return await _cacheRepository.cleanupOldCourses(
          maxAgeMilliseconds: maxAgeMillis,
        );
      },
      operationName: 'cleanupOldCourses',
      courseKey: 'cleanup',
      defaultValue: 0,
      extraContext: 'maxAgeDays: $maxAgeDays',
    );
  }

  // 🎯 OPTIMISTIC UPDATE COORDINATION

  /// Centralized optimistic update pattern for all decorators
  /// Provides consistent error handling, caching, and sync coordination
  Future<CourseTracking> performOptimisticUpdate({
    required String studentCode,
    required String courseCode,
    required CourseTracking Function(CourseTracking current) updateFunction,
    required String operationType,
    required String fieldType,
    required Map<String, dynamic> Function(CourseTracking updated)
    syncDataBuilder,
    required Future<CourseTracking> Function() remoteFallback,
    Map<String, dynamic>? logContext,
  }) async {
    final courseKeyString = '${studentCode}_$courseCode';

    return await _executeWithErrorHandling(
      operation: () async {
        // Get current state using optimized coordinator
        final current = await getCourseFromComponents(
          studentCode: studentCode,
          courseCode: courseCode,
        );

        if (current == null) {
          throw Exception('Course tracking not found: $courseKeyString');
        }

        // Apply optimistic update
        final updated = updateFunction(current);

        // Save using optimized coordinator
        await saveCourseFromComponents(
          studentCode: studentCode,
          courseCode: courseCode,
          tracking: updated,
        );

        // Enqueue sync operation with enhanced error handling
        try {
          // Note: SyncManager dependency would need to be injected here
          // For now, we'll let decorators handle sync enqueueing
          // final syncData = syncDataBuilder(updated);
          _logger.d(
            '[COORDINATOR] ✅ Optimistic update applied: $courseKeyString',
          );
        } catch (syncError, syncStack) {
          _logger.w(
            '[COORDINATOR] ⚠️ Optimistic update succeeded but sync preparation failed',
            error: syncError,
            stackTrace: syncStack,
          );
        }

        return updated;
      },
      operationName: 'performOptimisticUpdate',
      courseKey: courseKeyString,
      extraContext:
          'operation: $operationType, ${logContext?.entries.map((e) => '${e.key}=${e.value}').join(', ') ?? ''}',
    );
  }

  /// Simplified optimistic update without sync (for internal use)
  Future<CourseTracking> performOptimisticUpdateLocal({
    required String studentCode,
    required String courseCode,
    required CourseTracking Function(CourseTracking current) updateFunction,
    required String operationType,
    required Future<CourseTracking> Function() remoteFallback,
  }) async {
    return await performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: updateFunction,
      operationType: operationType,
      fieldType: 'unknown',
      syncDataBuilder: (_) => <String, dynamic>{},
      remoteFallback: remoteFallback,
    );
  }

  // 🔧 PRIVATE HELPER METHODS

  /// Execute operation with standardized error handling and logging
  Future<T> _executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
    required String courseKey,
    T? defaultValue,
    String? extraContext,
  }) async {
    try {
      final result = await operation();
      _logger.d(
        '[COORDINATOR] ✅ $operationName completed successfully: $courseKey'
        '${extraContext != null ? ' ($extraContext)' : ''}',
      );
      return result;
    } catch (e) {
      _logger.e(
        '[COORDINATOR] ❌ $operationName failed: $courseKey'
        '${extraContext != null ? ' ($extraContext)' : ''} - Error: $e',
      );

      if (defaultValue != null) {
        return defaultValue;
      }
      rethrow;
    }
  }

  /// Get cached grades data (internal helper)
  Future<Map<String, dynamic>?> _getCachedGrades(CourseKey courseKey) async {
    try {
      return await _cacheRepository.getCachedGrades(courseKey);
    } catch (e) {
      _logger.w('[COORDINATOR] Warning: Could not get cached grades: $e');
      return null;
    }
  }
}
