import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/courses/infrastructure/services/grade_tracking_cache_service.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Optimized local decorator for GradeCategory operations
/// Leverages enhanced coordinator service for granular category updates
///
/// Key optimizations:
/// - Uses granular updateCategoriesField for better performance
/// - Leverages optimized coordinator facade pattern
/// - Enhanced error handling and fallback strategies
/// - Smart caching with minimal data transfer
@LazySingleton(as: GradeTrackingCategoryRepository)
class GradeTrackingCategoryRepositoryDecorator
    implements GradeTrackingCategoryRepository {
  final GradeTrackingCategoryRepository _remoteCategoryRepo;
  final GradeTrackingCacheService _coordinator;
  final SyncManager _syncManager;
  final Logger _logger;

  GradeTrackingCategoryRepositoryDecorator(
    @Named('remote') this._remoteCategoryRepo,
    this._coordinator,
    this._syncManager,
    this._logger,
  );

  // 🚀 OPTIMIZED GRANULAR OPERATIONS

  /// Enhanced optimistic update using centralized coordinator
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
    // Delegate to centralized coordinator method
    final updated = await _coordinator.performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: updateFunction,
      operationType: operationType,
      fieldType: 'categories',
      syncDataBuilder: syncDataBuilder,
      remoteFallback: remoteFallback,
      logContext: logContext,
    );

    // Handle sync enqueueing at decorator level
    try {
      final syncData = syncDataBuilder(updated);
      await _syncManager.enqueueSyncOperation(
        operationType: operationType,
        fieldType: 'categories',
        courseKey: '${studentCode}_$courseCode',
        operationData: syncData,
      );

      final contextLog =
          logContext?.entries.map((e) => '${e.key}=${e.value}').join(', ') ??
          '';

      _logger.d(
        '[CATEGORY_DECORATOR] ✅ $operationType sync enqueued: ${studentCode}_$courseCode'
        '${contextLog.isNotEmpty ? ' ($contextLog)' : ''}',
      );
    } catch (syncError, syncStack) {
      _logger.w(
        '[CATEGORY_DECORATOR] ⚠️ Sync enqueue failed for $operationType, continuing optimistically',
        error: syncError,
        stackTrace: syncStack,
      );
    }

    return updated;
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
          () => _remoteCategoryRepo.addCategory(
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
          () => _remoteCategoryRepo.deleteCategory(
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
          () => _remoteCategoryRepo.updateCategory(
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
    try {
      // Use coordinator to update categories field
      await _coordinator.updateCategoriesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categories: categories,
      );

      _logger.d(
        '[CATEGORY_DECORATOR] Categories field updated via coordinator',
      );

      // Enqueue sync operation
      try {
        final courseKey = '${studentCode}_$courseCode';
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
      await _remoteCategoryRepo.updateCategoriesField(
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
