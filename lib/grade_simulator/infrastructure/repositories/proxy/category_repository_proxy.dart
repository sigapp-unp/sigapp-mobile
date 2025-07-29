import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/grade_simulator/infrastructure/repositories/proxy/base_repository_proxy.dart';

/// Optimized local decorator for GradeCategory operations
/// Leverages local cache repository and mapper for granular category updates
///
/// Key optimizations:
/// - Extends BaseGradeTrackingRepositoryDecorator for unified patterns
/// - Uses optimistic updates for better UX
/// - Enhanced error handling and fallback strategies
/// - Smart caching with minimal data transfer
@LazySingleton(as: GradeTrackingCategoryRepository)
class GradeTrackingCategoryRepositoryProxy
    extends BaseGradeSimulatorRepositoryProxy
    implements GradeTrackingCategoryRepository {
  @override
  String get decoratorType => 'CATEGORY';

  GradeTrackingCategoryRepositoryProxy(
    super.remoteRepository,
    super.localRepository,
    super.syncManager,
    super.logger,
  );

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    return performOptimisticUpdate(
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
      fieldType: 'categories',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryName': categoryName,
            'weight': weight,
            'categories': serializeCategoriesForSync(updated.categories),
          },
      remoteFallback:
          () => remoteRepository.addCategory(
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
    return performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        return current.copyWith(
          categories:
              current.categories.where((cat) => cat.id != categoryId).toList(),
        );
      },
      operationType: 'deleteCategory',
      fieldType: 'categories',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'categories': serializeCategoriesForSync(updated.categories),
            // Also send updated grades (excluding deleted category)
            'grades': serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => remoteRepository.deleteCategory(
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
    return performOptimisticUpdate(
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
      fieldType: 'categories',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'newName': newName,
            'newWeight': newWeight,
            'categories': serializeCategoriesForSync(updated.categories),
          },
      remoteFallback:
          () => remoteRepository.updateCategory(
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
    await performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        // Replace all categories with new ones
        return current.copyWith(categories: categories);
      },
      operationType: 'updateCategoriesField',
      fieldType: 'categories',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categories': serializeCategoriesForSync(categories),
          },
      remoteFallback: () async {
        await remoteRepository.updateCategoriesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categories: categories,
        );
        // Return updated course from local cache after successful remote update
        final cached = await localRepository.getCourse(
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
}
