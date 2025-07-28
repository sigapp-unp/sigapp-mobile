import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';

/// Remote repository for Grade operations
/// Handles grade-specific operations with single-write strategy
@Named('remote')
@LazySingleton(as: GradeTrackingGradeRepository)
class RemoteGradeTrackingGradeRepository
    implements GradeTrackingGradeRepository {
  final ApiGatewayClient _workerClient;
  final Logger _logger;
  final GradeTrackingCourseRepository _courseRepository;

  const RemoteGradeTrackingGradeRepository(
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
      _logger.e('[REMOTE_GRADE] PATCH failed: $e');
      rethrow;
    }
  }

  /// Build complete grades list from CourseTracking
  List<Map<String, dynamic>> _buildGradesList(CourseTracking courseTracking) {
    final allGrades = <Map<String, dynamic>>[];
    for (final category in courseTracking.categories) {
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
    return allGrades;
  }

  // ✨ REPOSITORY METHODS

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    _logger.d(
      '[REMOTE_GRADE] Adding grade: $gradeName to category $categoryId',
    );

    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final newGrade = Grade(
      id: 'grade_${DateTime.now().millisecondsSinceEpoch}',
      name: gradeName,
      score: score,
    );

    // Find the category and add the grade
    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            return cat.copyWith(grades: [...cat.grades, newGrade]);
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);
    final allGrades = _buildGradesList(updatedCourse);

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
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    _logger.d(
      '[REMOTE_GRADE] Deleting grade: $gradeId from category $categoryId',
    );

    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    // Find the category and remove the grade
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
    final allGrades = _buildGradesList(updatedCourse);

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
  Future<CourseTracking> updateGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  }) async {
    _logger.d(
      '[REMOTE_GRADE] Updating grade: $gradeId in category $categoryId',
    );

    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    // Find the category and update the grade
    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            return cat.copyWith(
              grades:
                  cat.grades.map((grade) {
                    if (grade.id == gradeId) {
                      return grade.copyWith(name: newName, score: newScore);
                    }
                    return grade;
                  }).toList(),
            );
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);
    final allGrades = _buildGradesList(updatedCourse);

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
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    _logger.d('[REMOTE_GRADE] Toggling grade enabled: $gradeId to $enabled');

    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    // Find the category and toggle the grade enabled state
    final updatedCategories =
        current.categories.map((cat) {
          if (cat.id == categoryId) {
            return cat.copyWith(
              grades:
                  cat.grades.map((grade) {
                    if (grade.id == gradeId) {
                      return grade.copyWith(enabled: enabled);
                    }
                    return grade;
                  }).toList(),
            );
          }
          return cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);
    final allGrades = _buildGradesList(updatedCourse);

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
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    _logger.d('[REMOTE_GRADE] Updating grades field for category: $categoryId');

    // Get current tracking to preserve other categories' grades
    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    // Build complete grades list
    final allGrades = <Map<String, dynamic>>[];
    for (final category in current.categories) {
      final categoryGrades =
          category.id == categoryId ? grades : category.grades;
      for (final grade in categoryGrades) {
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
  }

  @override
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) async {
    _logger.d('[REMOTE_GRADE] Updating multiple categories grades');

    final current = await _courseRepository.getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    // Build complete grades list with updates
    final allGrades = <Map<String, dynamic>>[];
    for (final category in current.categories) {
      final categoryGrades =
          gradesByCategory.containsKey(category.id)
              ? gradesByCategory[category.id]!
              : category.grades;

      for (final grade in categoryGrades) {
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
  }
}
