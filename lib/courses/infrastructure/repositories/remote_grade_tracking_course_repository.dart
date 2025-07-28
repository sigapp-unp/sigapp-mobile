import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';

/// Remote repository for CourseTracking operations
/// Handles CRUD operations for complete course tracking entities
@Named('remote')
@LazySingleton(as: GradeTrackingCourseRepository)
class RemoteGradeTrackingCourseRepository
    implements GradeTrackingCourseRepository {
  final ApiGatewayClient _workerClient;
  final Logger _logger;

  const RemoteGradeTrackingCourseRepository(this._workerClient, this._logger);

  // ✨ HTTP HELPERS

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
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.isNotEmpty ? Map<String, dynamic>.from(data.first) : null;
      }
      return null;
    } on DioException catch (e) {
      _logger.e('[REMOTE_COURSE] GET failed: $e');
      return null;
    }
  }

  /// Generic POST request with error handling
  Future<void> _apiPost(Map<String, dynamic> data) async {
    try {
      await _workerClient.http.post(
        '/rest/v1/course_grade_simulator',
        data: data,
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
    } on DioException catch (e) {
      _logger.e('[REMOTE_COURSE] POST failed: $e');
      rethrow;
    }
  }

  /// Generic DELETE request with error handling
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
    } on DioException catch (e) {
      _logger.e('[REMOTE_COURSE] DELETE failed: $e');
      rethrow;
    }
  }

  // ✨ DATA TRANSFORMATIONS

  /// Convert API data to CourseTracking
  CourseTracking _toCourseTracking(Map<String, dynamic> data) {
    final categoriesJson = data['categories'] as List? ?? [];
    final gradesJson = data['grades'] as List? ?? [];

    // Build grades map by category
    final gradesByCategory = <String, List<Grade>>{};
    for (final gradeData in gradesJson) {
      final categoryId = gradeData['categoryId'] as String? ?? '';
      gradesByCategory
          .putIfAbsent(categoryId, () => [])
          .add(
            Grade(
              id: gradeData['id']?.toString(),
              name: gradeData['name'] ?? '',
              score: (gradeData['score'] ?? 0).toDouble(),
              enabled: gradeData['enabled'] ?? true,
            ),
          );
    }

    // Build categories with their grades
    final categories =
        categoriesJson.map((categoryData) {
          final categoryId = categoryData['id']?.toString() ?? '';
          return GradeCategory(
            id: categoryId,
            name: categoryData['name'] ?? '',
            weight: (categoryData['weight'] ?? 0).toDouble(),
            grades: gradesByCategory[categoryId] ?? [],
          );
        }).toList();

    return CourseTracking(
      id: data['id']?.toString(),
      studentCode: data['student_code'] ?? '',
      courseCode: data['course_code'] ?? '',
      categories: categories,
    );
  }

  /// Convert CourseTracking to API data
  Map<String, dynamic> _fromCourseTracking(CourseTracking tracking) {
    final categories =
        tracking.categories
            .map(
              (cat) => {'id': cat.id, 'name': cat.name, 'weight': cat.weight},
            )
            .toList();

    final grades = <Map<String, dynamic>>[];
    for (final category in tracking.categories) {
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

    return {
      'student_code': tracking.studentCode,
      'course_code': tracking.courseCode,
      'categories': categories,
      'grades': grades,
      'metadata': {'passScore': 60, 'semester': '2025-1'},
    };
  }

  // ✨ REPOSITORY METHODS

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    _logger.d(
      '[REMOTE_COURSE] Getting course tracking: $studentCode-$courseCode',
    );

    final data = await _apiGet(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    return data != null ? _toCourseTracking(data) : null;
  }

  @override
  Future<CourseTracking> create(CourseTracking tracking) async {
    _logger.d(
      '[REMOTE_COURSE] Creating course: ${tracking.studentCode}-${tracking.courseCode}',
    );

    final apiData = _fromCourseTracking(tracking);
    await _apiPost(apiData);

    // Return created tracking
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
    _logger.d(
      '[REMOTE_COURSE] Deleting course tracking: $studentCode-$courseCode',
    );

    await _apiDelete(studentCode: studentCode, courseCode: courseCode);
  }
}
