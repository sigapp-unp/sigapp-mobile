import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/courses/infrastructure/repositories/local_grade_tracking_repository.dart';
import 'package:sigapp/courses/infrastructure/repositories/remote_grade_tracking_repository.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Optimized local decorator for GradeCategory operations
/// Leverages local cache repository and mapper for granular category updates
///
/// Key optimizations:
/// - Direct integration with LocalGradeTrackingRepository
/// - Uses LocalGradeTrackingMapper for data transformations
/// - Enhanced error handling and fallback strategies
/// - Smart caching with minimal data transfer
@LazySingleton(as: GradeTrackingCategoryRepository)
class GradeTrackingCategoryRepositoryDecorator
    implements GradeTrackingCategoryRepository {
  final RemoteGradeTrackingRepository _remoteCategoryRepo;
  final LocalGradeTrackingRepository _localRepository;
  final SyncManager _syncManager;
  final Logger _logger;

  GradeTrackingCategoryRepositoryDecorator(
    this._remoteCategoryRepo,
    this._localRepository,
    this._syncManager,
    this._logger,
  );

  // 🚀 OPTIMIZED GRANULAR OPERATIONS

  /// Get course with intelligent cache-first strategy
  Future<CourseTracking?> _getCachedOrRemote({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      // Try local cache first
      final cached = await _localRepository.getCourse(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (cached != null) {
        _logger.d(
          '[CATEGORY_DECORATOR] ✅ Cache HIT: ${studentCode}_$courseCode',
        );
        return cached;
      }

      _logger.d(
        '[CATEGORY_DECORATOR] ❌ Cache MISS: ${studentCode}_$courseCode',
      );
      return null; // Let calling methods handle remote fetch
    } catch (error, stackTrace) {
      _logger.e(
        '[CATEGORY_DECORATOR] ❌ Error in cache-first strategy',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Save course to local cache using mapper
  Future<void> _saveCourseToLocal({
    required String studentCode,
    required String courseCode,
    required CourseTracking tracking,
  }) async {
    try {
      await _localRepository.saveCourseFromComponents(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: tracking,
      );

      _logger.d(
        '[CATEGORY_DECORATOR] ✅ Saved to cache: ${studentCode}_$courseCode',
      );
    } catch (error, stackTrace) {
      _logger.e(
        '[CATEGORY_DECORATOR] ❌ Error saving to cache',
        error: error,
        stackTrace: stackTrace,
      );
      // Don't rethrow - cache errors shouldn't block operations
    }
  }

  /// Enhanced optimistic update with local cache integration
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
    try {
      // Get current tracking from cache
      CourseTracking? current = await _getCachedOrRemote(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) {
        _logger.w(
          '[CATEGORY_DECORATOR] ⚠️ No current tracking found, using remote fallback',
        );
        return await remoteFallback();
      }

      // Apply optimistic update
      final updated = updateFunction(current);

      // Save updated tracking to local cache
      await _saveCourseToLocal(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: updated,
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
    } catch (e, stackTrace) {
      _logger.e(
        '[CATEGORY_DECORATOR] ❌ Optimistic update failed, using remote fallback',
        error: e,
        stackTrace: stackTrace,
      );
      return await remoteFallback();
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
    await _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        // Replace all categories with new ones
        return current.copyWith(categories: categories);
      },
      operationType: 'updateCategoriesField',
      syncDataBuilder:
          (updated) => {
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
      remoteFallback: () async {
        await _remoteCategoryRepo.updateCategoriesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categories: categories,
        );
        // Return updated course from local cache after successful remote update
        final cached = await _localRepository.getCourse(
          studentCode: studentCode,
          courseCode: courseCode,
        );
        if (cached == null) {
          throw Exception('Course not found after remote update');
        }
        return cached;
      },
    );
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
