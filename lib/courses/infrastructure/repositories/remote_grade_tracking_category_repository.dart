import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';

/// Remote repository for GradeCategory operations
/// Handles category-specific operations with single-write strategy
@Named('remote')
@LazySingleton(as: GradeTrackingCategoryRepository)
class RemoteGradeTrackingCategoryRepository
    implements GradeTrackingCategoryRepository {
  final ApiGatewayClient _workerClient;
  final Logger _logger;
  final GradeTrackingCourseRepository _courseRepository;

  const RemoteGradeTrackingCategoryRepository(
    this._workerClient,
    this._logger,
    @Named('remote') this._courseRepository,
  );

  // ✨ HTTP HELPERS

  /// Generic PATCH request with error handling
  Future<void> _apiPatch({
    required String studentCode,
    required String courseCode,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _workerClient.http.patch(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        data: data,
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
    } on DioException catch (e) {
      _logger.e('[REMOTE_CATEGORY] PATCH failed: $e');
      rethrow;
    }
  }

  // ✨ REPOSITORY METHODS

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    _logger.d('[REMOTE_CATEGORY] Adding category: $categoryName');

    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final newCategory = GradeCategory(
      id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
      name: categoryName,
      weight: weight,
      grades: [],
    );

    final updatedCategories = [...current.categories, newCategory];

    await updateCategoriesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categories: updatedCategories,
    );

    // Return updated course tracking
    final result = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    return result!;
  }

  @override
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) async {
    _logger.d('[REMOTE_CATEGORY] Deleting category: $categoryId');

    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.where((cat) => cat.id != categoryId).toList();

    await updateCategoriesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categories: updatedCategories,
    );

    // Also need to remove grades for this category
    final allGrades = <Map<String, dynamic>>[];
    for (final category in updatedCategories) {
      for (final grade in category.grades) {
        allGrades.add({
          'id': grade.id,
          'categoryId': category.id,
          'name': grade.name,
          'score': grade.score,
          'enabled': grade.enabled,
        });
      }
    }

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {'grades': allGrades},
    );

    // Return updated course tracking
    final result = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    return result!;
  }

  @override
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    _logger.d('[REMOTE_CATEGORY] Updating category: $categoryId');

    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            return cat.copyWith(name: newName, weight: newWeight);
          }
          return cat;
        }).toList();

    await updateCategoriesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categories: updatedCategories,
    );

    // Return updated course tracking
    final result = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    return result!;
  }

  @override
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) async {
    _logger.d('[REMOTE_CATEGORY] Updating categories field');

    final categoriesData =
        categories
            .map(
              (cat) => {'id': cat.id, 'name': cat.name, 'weight': cat.weight},
            )
            .toList();

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {'categories': categoriesData},
    );
  }
}
