import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/courses/infrastructure/services/grade_tracking_cache_service.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Optimized local decorator for CourseTracking operations
/// Leverages enhanced cache repository and coordinator service for maximum performance
///
/// Key improvements:
/// - Uses optimized coordinator facade pattern
/// - Leverages batch operations for better performance
/// - Simplified error handling with consistent logging
/// - Smart cache strategies with fallback mechanisms
@LazySingleton(as: GradeTrackingCourseRepository)
class GradeTrackingCourseRepositoryDecorator
    implements GradeTrackingCourseRepository {
  final GradeTrackingCourseRepository _remoteCourseRepo;
  final GradeTrackingCacheService _coordinator;
  final SyncManager _syncManager;
  final Logger _logger;

  GradeTrackingCourseRepositoryDecorator(
    @Named('remote') this._remoteCourseRepo,
    this._coordinator,
    this._syncManager,
    this._logger,
  );

  // 🚀 OPTIMIZED CACHE-FIRST OPERATIONS

  /// Get course with intelligent cache-first strategy
  Future<CourseTracking?> _getCachedOrRemote({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      // Try optimized coordinator first
      final cached = await _coordinator.getCourseFromComponents(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (cached != null) {
        _logger.d('[COURSE_DECORATOR] ✅ Cache HIT: ${studentCode}_$courseCode');
        return cached;
      }

      // Cache miss → fetch remote with enhanced error handling
      _logger.d(
        '[COURSE_DECORATOR] ⚡ Cache MISS, fetching remote: ${studentCode}_$courseCode',
      );

      final remote = await _remoteCourseRepo.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      // Save to cache using optimized coordinator
      if (remote != null) {
        await _coordinator.saveCourseFromComponents(
          studentCode: studentCode,
          courseCode: courseCode,
          tracking: remote,
        );
        _logger.d(
          '[COURSE_DECORATOR] ✅ Remote data cached: ${studentCode}_$courseCode',
        );
      }

      return remote;
    } catch (e, stackTrace) {
      _logger.e(
        '[COURSE_DECORATOR] ❌ Error in _getCachedOrRemote: ${studentCode}_$courseCode',
        error: e,
        stackTrace: stackTrace,
      );

      // Smart fallback to stale cache
      try {
        final staleCache = await _coordinator.getCourseFromComponents(
          studentCode: studentCode,
          courseCode: courseCode,
        );

        if (staleCache != null) {
          _logger.w(
            '[COURSE_DECORATOR] ⚠️ Using stale cache due to remote error',
          );
          return staleCache;
        }
      } catch (cacheError) {
        _logger.w('[COURSE_DECORATOR] ⚠️ Stale cache also failed: $cacheError');
      }

      return null;
    }
  }

  /// Optimized helper for building sync data from grades
  List<Map<String, dynamic>> _buildSyncGradeData(
    List<GradeCategory> categories,
  ) {
    final grades = <Map<String, dynamic>>[];
    for (final category in categories) {
      for (final grade in category.grades) {
        grades.add({
          'id': grade.id,
          'categoryId': category.id,
          'name': grade.name,
          'score': grade.score,
          'enabled': grade.enabled,
        });
      }
    }
    return grades;
  }

  /// Enhanced optimistic update with coordinator integration
  Future<CourseTracking> _performOptimisticUpdate({
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
    // Delegate to centralized coordinator method
    final updated = await _coordinator.performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: updateFunction,
      operationType: operationType,
      fieldType: fieldType,
      syncDataBuilder: syncDataBuilder,
      remoteFallback: remoteFallback,
      logContext: logContext,
    );

    // Handle sync enqueueing at decorator level
    try {
      final syncData = syncDataBuilder(updated);
      await _syncManager.enqueueSyncOperation(
        operationType: operationType,
        fieldType: fieldType,
        courseKey: '${studentCode}_$courseCode',
        operationData: syncData,
      );

      final contextLog =
          logContext?.entries.map((e) => '${e.key}=${e.value}').join(', ') ??
          '';

      _logger.d(
        '[COURSE_DECORATOR] ✅ $operationType sync enqueued: ${studentCode}_$courseCode'
        '${contextLog.isNotEmpty ? ' ($contextLog)' : ''}',
      );
    } catch (syncError, syncStack) {
      _logger.w(
        '[COURSE_DECORATOR] ⚠️ Sync enqueue failed for $operationType, continuing optimistically',
        error: syncError,
        stackTrace: syncStack,
      );
    }

    return updated;
  } // 🎯 PUBLIC REPOSITORY INTERFACE

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    return _getCachedOrRemote(studentCode: studentCode, courseCode: courseCode);
  }

  @override
  Future<CourseTracking> create(CourseTracking tracking) async {
    return _performOptimisticUpdate(
      studentCode: tracking.studentCode,
      courseCode: tracking.courseCode,
      updateFunction: (_) => tracking,
      operationType: 'create',
      fieldType: 'course',
      syncDataBuilder:
          (updated) => {
            'studentCode': updated.studentCode,
            'courseCode': updated.courseCode,
            'categories':
                updated.categories
                    .map(
                      (cat) => {
                        'id': cat.id,
                        'name': cat.name,
                        'weight': cat.weight,
                      },
                    )
                    .toList(),
            'grades': _buildSyncGradeData(updated.categories),
          },
      remoteFallback: () => _remoteCourseRepo.create(tracking),
      logContext: {
        'courseCode': tracking.courseCode,
        'categoriesCount': tracking.categories.length,
      },
    );
  }

  @override
  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    final courseKeyString = '${studentCode}_$courseCode';

    try {
      // Optimistic deletion using coordinator
      await _coordinator.invalidateCourse(courseKeyString);
      _logger.d(
        '[COURSE_DECORATOR] ✅ Course deleted from cache: $courseKeyString',
      );

      // Enhanced sync enqueue with better error handling
      try {
        await _syncManager.enqueueSyncOperation(
          operationType: 'delete',
          fieldType: 'course',
          courseKey: courseKeyString,
          operationData: {'studentCode': studentCode, 'courseCode': courseCode},
        );
        _logger.d(
          '[COURSE_DECORATOR] ✅ Delete sync enqueued: $courseKeyString',
        );
      } catch (syncError, syncStack) {
        _logger.w(
          '[COURSE_DECORATOR] ⚠️ Delete sync enqueue failed, continuing optimistically',
          error: syncError,
          stackTrace: syncStack,
        );
      }
    } catch (e, stackTrace) {
      _logger.e(
        '[COURSE_DECORATOR] ❌ Optimistic delete failed: $courseKeyString',
        error: e,
        stackTrace: stackTrace,
      );

      // Enhanced fallback to remote
      try {
        await _remoteCourseRepo.deleteCourseTracking(
          studentCode: studentCode,
          courseCode: courseCode,
        );
        _logger.d('[COURSE_DECORATOR] ✅ Remote delete completed');
      } catch (remoteError, remoteStack) {
        _logger.e(
          '[COURSE_DECORATOR] ❌ Remote delete also failed: $courseKeyString',
          error: remoteError,
          stackTrace: remoteStack,
        );
        rethrow;
      }
    }
  }
}
