import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';

/// Unified remote repository for CourseTracking operations
/// Serves as the single source of truth for remote data access
///
/// This repository consolidates the functionality of:
/// - GradeTrackingCourseRepository (course-level operations)
/// - GradeTrackingCategoryRepository (category-level operations)
/// - GradeTrackingGradeRepository (grade-level operations)
///
/// Key features:
/// - HTTP-based operations using ApiGatewayClient
/// - Comprehensive error handling with DioException
/// - Optimized data serialization for Supabase backend
/// - Consistent logging and debugging support
@singleton
class RemoteGradeTrackingRepository
    implements
        GradeTrackingCourseRepository,
        GradeTrackingCategoryRepository,
        GradeTrackingGradeRepository {
  final ApiGatewayClient _workerClient;
  final Logger _logger;

  const RemoteGradeTrackingRepository(this._workerClient, this._logger);

  // 🌐 HTTP HELPERS

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
      _logger.d(
        '[REMOTE_TRACKING] ✅ PATCH successful: ${studentCode}_$courseCode',
      );
    } on DioException catch (e) {
      _logger.e('[REMOTE_TRACKING] ❌ PATCH failed: $e');
      rethrow;
    }
  }

  /// Generic GET request with error handling
  Future<Map<String, dynamic>?> _apiGet({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      final response = await _workerClient.http.get(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
          'select': '*',
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      final data = response.data as List<dynamic>;
      if (data.isEmpty) {
        _logger.d(
          '[REMOTE_TRACKING] ❌ Course not found: ${studentCode}_$courseCode',
        );
        return null;
      }

      _logger.d(
        '[REMOTE_TRACKING] ✅ GET successful: ${studentCode}_$courseCode',
      );
      return data.first as Map<String, dynamic>;
    } on DioException catch (e) {
      _logger.e('[REMOTE_TRACKING] ❌ GET failed: $e');
      rethrow;
    }
  }

  /// Generic POST request for creating new records
  Future<void> _apiPost({
    required String studentCode,
    required String courseCode,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _workerClient.http.post(
        '/rest/v1/course_grade_simulator',
        data: {'student_code': studentCode, 'course_code': courseCode, ...data},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
      _logger.d(
        '[REMOTE_TRACKING] ✅ POST successful: ${studentCode}_$courseCode',
      );
    } on DioException catch (e) {
      _logger.e('[REMOTE_TRACKING] ❌ POST failed: $e');
      rethrow;
    }
  }

  /// Generic DELETE request
  Future<void> _apiDelete({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      await _workerClient.http.delete(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
      _logger.d(
        '[REMOTE_TRACKING] ✅ DELETE successful: ${studentCode}_$courseCode',
      );
    } on DioException catch (e) {
      _logger.e('[REMOTE_TRACKING] ❌ DELETE failed: $e');
      rethrow;
    }
  }

  // 🗂️ DATA TRANSFORMATION HELPERS

  /// Build grades list for API payload
  List<Map<String, dynamic>> _buildGradesList(CourseTracking course) {
    final grades = <Map<String, dynamic>>[];
    for (final category in course.categories) {
      for (final grade in category.grades) {
        grades.add({
          'id': grade.id,
          'category_id': category.id,
          'name': grade.name,
          'score': grade.score,
          'enabled': grade.enabled,
        });
      }
    }
    return grades;
  }

  /// Build categories list for API payload
  List<Map<String, dynamic>> _buildCategoriesList(CourseTracking course) {
    return course.categories
        .map(
          (category) => {
            'id': category.id,
            'name': category.name,
            'weight': category.weight,
          },
        )
        .toList();
  }

  /// Reconstruct CourseTracking from API response
  CourseTracking? _reconstructCourseFromApiResponse(
    Map<String, dynamic> data,
    String studentCode,
    String courseCode,
  ) {
    try {
      final categoriesData = data['categories'] as List<dynamic>? ?? [];
      final gradesData = data['grades'] as List<dynamic>? ?? [];

      // Group grades by category_id
      final gradesByCategory = <String, List<Grade>>{};
      for (final gradeData in gradesData) {
        final categoryId = gradeData['category_id'] as String;
        final grade = Grade(
          id: gradeData['id'],
          name: gradeData['name'],
          score: (gradeData['score'] as num).toDouble(),
          enabled: gradeData['enabled'] ?? true,
        );

        gradesByCategory.putIfAbsent(categoryId, () => []).add(grade);
      }

      // Build categories with their grades
      final categories =
          categoriesData.map((categoryData) {
            final categoryId = categoryData['id'] as String;
            final grades = gradesByCategory[categoryId] ?? <Grade>[];

            return GradeCategory(
              id: categoryId,
              name: categoryData['name'],
              weight: (categoryData['weight'] as num).toDouble(),
              grades: grades,
            );
          }).toList();

      return CourseTracking(
        id: data['id']?.toString(),
        studentCode: studentCode,
        courseCode: courseCode,
        categories: categories,
      );
    } catch (e) {
      _logger.e('[REMOTE_TRACKING] ❌ Error reconstructing course: $e');
      return null;
    }
  }

  // 🎓 COURSE REPOSITORY IMPLEMENTATION

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    _logger.d('[REMOTE_TRACKING] Getting course: ${studentCode}_$courseCode');

    final data = await _apiGet(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (data == null) return null;

    return _reconstructCourseFromApiResponse(data, studentCode, courseCode);
  }

  @override
  Future<CourseTracking> create(CourseTracking tracking) async {
    _logger.d(
      '[REMOTE_TRACKING] Creating course: ${tracking.studentCode}_${tracking.courseCode}',
    );

    await _apiPost(
      studentCode: tracking.studentCode,
      courseCode: tracking.courseCode,
      data: {
        'categories': _buildCategoriesList(tracking),
        'grades': _buildGradesList(tracking),
        'metadata': <String, dynamic>{},
      },
    );

    // Return the created course
    final result = await getCourseTracking(
      studentCode: tracking.studentCode,
      courseCode: tracking.courseCode,
    );
    return result!;
  }

  @override
  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    _logger.d('[REMOTE_TRACKING] Deleting course: ${studentCode}_$courseCode');

    await _apiDelete(studentCode: studentCode, courseCode: courseCode);
  }

  // 📂 CATEGORY REPOSITORY IMPLEMENTATION

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    _logger.d(
      '[REMOTE_TRACKING] Adding category: $categoryName to ${studentCode}_$courseCode',
    );

    final current = await getCourseTracking(
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

    final updatedCourse = current.copyWith(
      categories: [...current.categories, newCategory],
    );

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {
        'categories': _buildCategoriesList(updatedCourse),
        'grades': _buildGradesList(updatedCourse),
      },
    );

    // Return updated course
    final result = await getCourseTracking(
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
    _logger.d(
      '[REMOTE_TRACKING] Deleting category: $categoryId from ${studentCode}_$courseCode',
    );

    final current = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCourse = current.copyWith(
      categories:
          current.categories.where((cat) => cat.id != categoryId).toList(),
    );

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {
        'categories': _buildCategoriesList(updatedCourse),
        'grades': _buildGradesList(updatedCourse),
      },
    );

    // Return updated course
    final result = await getCourseTracking(
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
    _logger.d(
      '[REMOTE_TRACKING] Updating category: $categoryId in ${studentCode}_$courseCode',
    );

    final current = await getCourseTracking(
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

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {
        'categories': _buildCategoriesList(updatedCourse),
        'grades': _buildGradesList(updatedCourse),
      },
    );

    // Return updated course
    final result = await getCourseTracking(
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
    _logger.d(
      '[REMOTE_TRACKING] Updating categories field for ${studentCode}_$courseCode',
    );

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {
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
  }

  // 🎯 GRADE REPOSITORY IMPLEMENTATION

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    _logger.d(
      '[REMOTE_TRACKING] Adding grade: $gradeName to category $categoryId',
    );

    final current = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final newGrade = Grade(
      id: 'grade_${DateTime.now().millisecondsSinceEpoch}',
      name: gradeName,
      score: score,
    );

    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            return cat.copyWith(grades: [...cat.grades, newGrade]);
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {'grades': _buildGradesList(updatedCourse)},
    );

    // Return updated course
    final result = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    return result!;
  }

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    _logger.d(
      '[REMOTE_TRACKING] Deleting grade: $gradeId from category $categoryId',
    );

    final current = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            return cat.copyWith(
              grades: cat.grades.where((grade) => grade.id != gradeId).toList(),
            );
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {'grades': _buildGradesList(updatedCourse)},
    );

    // Return updated course
    final result = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    return result!;
  }

  @override
  Future<CourseTracking> updateGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  }) async {
    _logger.d(
      '[REMOTE_TRACKING] Updating grade: $gradeId in category $categoryId',
    );

    final current = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            final updatedGrades =
                cat.grades.map((grade) {
                  if (grade.id == gradeId) {
                    return grade.copyWith(name: newName, score: newScore);
                  }
                  return grade;
                }).toList();
            return cat.copyWith(grades: updatedGrades);
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {'grades': _buildGradesList(updatedCourse)},
    );

    // Return updated course
    final result = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    return result!;
  }

  @override
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    _logger.d(
      '[REMOTE_TRACKING] Toggling grade enabled: $gradeId (enabled: $enabled)',
    );

    final current = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            final updatedGrades =
                cat.grades.map((grade) {
                  if (grade.id == gradeId) {
                    return grade.copyWith(enabled: enabled);
                  }
                  return grade;
                }).toList();
            return cat.copyWith(grades: updatedGrades);
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {'grades': _buildGradesList(updatedCourse)},
    );

    // Return updated course
    final result = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    return result!;
  }

  @override
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    _logger.d(
      '[REMOTE_TRACKING] Updating grades field for category: $categoryId',
    );

    final current = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            return cat.copyWith(grades: grades);
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {'grades': _buildGradesList(updatedCourse)},
    );
  }

  @override
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) async {
    _logger.d('[REMOTE_TRACKING] Updating multiple categories grades');

    final current = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id != null && gradesByCategory.containsKey(cat.id!)) {
            return cat.copyWith(grades: gradesByCategory[cat.id!]!);
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _apiPatch(
      studentCode: studentCode,
      courseCode: courseCode,
      data: {'grades': _buildGradesList(updatedCourse)},
    );
  }
}
