import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/courses/infrastructure/services/grade_tracking_local_service.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Local decorator for GradeCategory operations
/// Implements cache-first reads and optimistic updates for category operations
@LazySingleton(as: GradeTrackingCategoryRepository)
class LocalGradeTrackingCategoryDecorator
    implements GradeTrackingCategoryRepository {
  final GradeTrackingCategoryRepository _remoteRepo;
  final GradeTrackingCourseRepository _courseRepo;
  final GradeTrackingLocalService _cacheService;
  final SyncManager _syncManager;
  final Logger _logger;

  LocalGradeTrackingCategoryDecorator(
    @Named('remote') this._remoteRepo,
    @Named('remote') this._courseRepo,
    this._cacheService,
    this._syncManager,
    this._logger,
  );

  /// Unified helper for optimistic updates
  Future<CourseTracking> _performOptimisticUpdate({
    required String studentCode,
    required String courseCode,
    required CourseTracking Function(CourseTracking current) updateFunction,
    required String operationType,
    required Map<String, dynamic> Function(CourseTracking updated)
    syncDataBuilder,
    required Future<CourseTracking> Function() remoteFallback,
    Map<String, dynamic>? logContext,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Get current state from cache or remote
      final current = await _courseRepo.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) throw Exception('Course tracking not found');

      // Apply optimistic update
      final updated = updateFunction(current);

      // Update cache
      await _cacheService.saveCourse(courseKey, updated);
      _logger.d('[CATEGORY_DECORATOR] Cache updated for $courseKey');

      // Enqueue sync operation
      try {
        final syncData = syncDataBuilder(updated);
        await _syncManager.enqueueSyncOperation(
          operationType: operationType,
          fieldType: 'categories',
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
          '[CATEGORY_DECORATOR] Sync enqueued: $operationType ($contextStr)',
        );
      } catch (syncError, syncStack) {
        _logger.e(
          '[CATEGORY_DECORATOR] Sync enqueue failed for $operationType, continuing with optimistic state',
          error: syncError,
          stackTrace: syncStack,
        );
      }

      return updated;
    } catch (e, s) {
      _logger.e(
        '[CATEGORY_DECORATOR] Error in $operationType',
        error: e,
        stackTrace: s,
      );
      // Fallback to remote operation
      final result = await remoteFallback();
      final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);
      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
  }

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final newCategory = GradeCategory(
          id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
          name: categoryName,
          weight: weight,
          grades: [],
        );
        return current.copyWith(
          categories: [...current.categories, newCategory],
        );
      },
      operationType: 'addCategory',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryName': categoryName,
            'weight': weight,
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
          },
      remoteFallback:
          () => _remoteRepo.addCategory(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryName: categoryName,
            weight: weight,
          ),
      logContext: {'categoryName': categoryName, 'weight': weight},
    );
  }

  @override
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        return current.copyWith(
          categories:
              current.categories.where((cat) => cat.id != categoryId).toList(),
        );
      },
      operationType: 'deleteCategory',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
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
            // Also send updated grades (excluding deleted category)
            'grades': _serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => _remoteRepo.deleteCategory(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
          ),
      logContext: {'categoryId': categoryId},
    );
  }

  @override
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                return cat.copyWith(name: newName, weight: newWeight);
              }
              return cat;
            }).toList();
        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'updateCategory',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'newName': newName,
            'newWeight': newWeight,
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
          },
      remoteFallback:
          () => _remoteRepo.updateCategory(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            newName: newName,
            newWeight: newWeight,
          ),
      logContext: {
        'categoryId': categoryId,
        'newName': newName,
        'newWeight': newWeight,
      },
    );
  }

  @override
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Get current course to preserve other data
      final current = await _courseRepo.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) throw Exception('Course tracking not found');

      // Apply update with new categories
      final updated = current.copyWith(categories: categories);

      // Update cache
      await _cacheService.saveCourse(courseKey, updated);
      _logger.d('[CATEGORY_DECORATOR] Categories field updated in cache');

      // Enqueue sync operation
      try {
        await _syncManager.enqueueSyncOperation(
          operationType: 'updateCategoriesField',
          fieldType: 'categories',
          courseKey: courseKey,
          operationData: {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categories':
                categories
                    .map(
                      (cat) => {
                        'id': cat.id,
                        'name': cat.name,
                        'weight': cat.weight,
                      },
                    )
                    .toList(),
          },
        );
        _logger.d('[CATEGORY_DECORATOR] Categories field sync enqueued');
      } catch (syncError, syncStack) {
        _logger.e(
          '[CATEGORY_DECORATOR] Categories field sync enqueue failed',
          error: syncError,
          stackTrace: syncStack,
        );
      }
    } catch (e, s) {
      _logger.e(
        '[CATEGORY_DECORATOR] Error in updateCategoriesField',
        error: e,
        stackTrace: s,
      );
      // Fallback to remote operation
      await _remoteRepo.updateCategoriesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categories: categories,
      );
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
}
