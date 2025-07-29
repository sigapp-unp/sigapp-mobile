import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/grade_simulator/infrastructure/repositories/proxy/base_repository_proxy.dart';

/// Optimized local decorator for CourseTracking operations
/// Leverages local cache repository and mapper for maximum performance
///
/// Key improvements:
/// - Extends BaseGradeTrackingRepositoryDecorator for unified patterns
/// - Uses optimistic updates for better UX
/// - Simplified error handling with consistent logging
/// - Smart cache strategies with fallback mechanisms
@LazySingleton(as: GradeTrackingCourseRepository)
class GradeTrackingCourseRepositoryProxy
    extends BaseGradeSimulatorRepositoryProxy
    implements GradeTrackingCourseRepository {
  @override
  String get decoratorType => 'COURSE';

  GradeTrackingCourseRepositoryProxy(
    super.remoteRepository,
    super.localRepository,
    super.syncManager,
    super.logger,
  );

  // 🎯 PUBLIC REPOSITORY INTERFACE

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    return getCachedOrRemote(studentCode: studentCode, courseCode: courseCode);
  }

  @override
  Future<CourseTracking> create(CourseTracking tracking) async {
    return performOptimisticUpdate(
      studentCode: tracking.studentCode,
      courseCode: tracking.courseCode,
      updateFunction: (_) => tracking,
      operationType: 'create',
      fieldType: 'course',
      syncDataBuilder:
          (updated) => {
            'studentCode': updated.studentCode,
            'courseCode': updated.courseCode,
            'categories': serializeCategoriesForSync(updated.categories),
            'grades': serializeGradesForSync(updated.categories),
          },
      remoteFallback: () => remoteRepository.create(tracking),
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
    try {
      // Delete from local cache first
      await localRepository.invalidateCourse(
        studentCode: studentCode,
        courseCode: courseCode,
      );
      logger.d(
        '[COURSE] ✅ Course invalidated from cache: ${studentCode}_$courseCode',
      );

      // Enqueue sync operation for remote deletion
      await enqueueSyncOperation(
        operationType: 'deleteCourseTracking',
        fieldType: 'course',
        studentCode: studentCode,
        courseCode: courseCode,
        syncDataBuilder:
            () => {'studentCode': studentCode, 'courseCode': courseCode},
      );
    } catch (error, stackTrace) {
      logger.e(
        '[COURSE] ❌ Error deleting course tracking',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
