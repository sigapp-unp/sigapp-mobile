import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/courses/infrastructure/services/grade_tracking_local_service.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Local decorator for CourseTracking operations
/// Implements cache-first reads and optimistic updates for course-level operations
@LazySingleton(as: GradeTrackingCourseRepository)
class LocalGradeTrackingCourseDecorator
    implements GradeTrackingCourseRepository {
  final GradeTrackingCourseRepository _remoteRepo;
  final GradeTrackingLocalService _cacheService;
  final SyncManager _syncManager;
  final Logger _logger;

  LocalGradeTrackingCourseDecorator(
    @Named('remote') this._remoteRepo,
    this._cacheService,
    this._syncManager,
    this._logger,
  );

  Future<CourseTracking?> _getCachedOrRemote({
    required String studentCode,
    required String courseCode,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    // Try cache first
    final cached = await _cacheService.getCachedCourse(courseKey);
    if (cached != null) {
      _logger.d('[COURSE_DECORATOR] Cache HIT for $courseKey');
      return cached;
    }

    // Cache miss → fetch remote
    _logger.d(
      '[COURSE_DECORATOR] Cache MISS for $courseKey, fetching remote...',
    );
    try {
      final remote = await _remoteRepo.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      // Update cache with fresh data
      if (remote != null) {
        await _cacheService.saveCourse(courseKey, remote);
      }

      return remote;
    } catch (e, s) {
      _logger.e(
        '[COURSE_DECORATOR] Error in getCourseTracking',
        error: e,
        stackTrace: s,
      );

      // Fallback to stale cache
      final staleCached = await _cacheService.getCachedCourse(courseKey);
      if (staleCached != null) {
        _logger.w('[COURSE_DECORATOR] Using stale cache due to remote error');
        return staleCached;
      }

      return null;
    }
  }

  /// Helper para serializar grades para sync
  List<Map<String, dynamic>> _serializeGradesForSync(
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

  /// Unified helper for optimistic updates
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
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Get current state
      final current = await _getCachedOrRemote(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) throw Exception('Course tracking not found');

      // Apply optimistic update
      final updated = updateFunction(current);

      // Update cache
      await _cacheService.saveCourse(courseKey, updated);
      _logger.d('[COURSE_DECORATOR] Cache updated for $courseKey');

      // Enqueue sync operation
      try {
        final syncData = syncDataBuilder(updated);
        await _syncManager.enqueueSyncOperation(
          operationType: operationType,
          fieldType: fieldType,
          courseKey: courseKey,
          operationData: syncData,
        );

        final contextStr =
            logContext != null
                ? logContext.entries
                    .map((e) => '${e.key}=${e.value}')
                    .join(', ')
                : '';
        _logger.d(
          '[COURSE_DECORATOR] Sync enqueued: $operationType ($contextStr)',
        );
      } catch (syncError, syncStack) {
        _logger.e(
          '[COURSE_DECORATOR] Sync enqueue failed for $operationType, continuing with optimistic state',
          error: syncError,
          stackTrace: syncStack,
        );
      }

      return updated;
    } catch (e, s) {
      _logger.e(
        '[COURSE_DECORATOR] Error in $operationType',
        error: e,
        stackTrace: s,
      );
      // Fallback to remote operation
      final result = await remoteFallback();
      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
  }

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
            'grades': _serializeGradesForSync(updated.categories),
          },
      remoteFallback: () => _remoteRepo.create(tracking),
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
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Remove from cache immediately (optimistic)
      await _cacheService.invalidateCourse(courseKey);
      _logger.d('[COURSE_DECORATOR] Course deleted from cache: $courseKey');

      // Enqueue sync operation
      try {
        await _syncManager.enqueueSyncOperation(
          operationType: 'delete',
          fieldType: 'course',
          courseKey: courseKey,
          operationData: {'studentCode': studentCode, 'courseCode': courseCode},
        );
        _logger.d('[COURSE_DECORATOR] Delete sync enqueued for: $courseKey');
      } catch (syncError, syncStack) {
        _logger.e(
          '[COURSE_DECORATOR] Delete sync enqueue failed, continuing with optimistic state',
          error: syncError,
          stackTrace: syncStack,
        );
      }
    } catch (e, s) {
      _logger.e(
        '[COURSE_DECORATOR] Error in deleteCourseTracking',
        error: e,
        stackTrace: s,
      );
      // Fallback to remote operation
      await _remoteRepo.deleteCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );
    }
  }
}
