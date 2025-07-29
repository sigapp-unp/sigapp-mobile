import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';

/// Remote data source for course-level operations
/// Handles GET, POST, DELETE operations for CourseTracking entities
class CourseRemoteSource {
  final ApiGatewayClient _client;
  final Logger _logger;

  const CourseRemoteSource(this._client, this._logger);

  /// Fetch a course tracking record from remote database
  Future<CourseTracking?> fetch({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      final response = await _client.http.get(
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
          '[COURSE_REMOTE_SOURCE] ❌ Course not found: ${studentCode}_$courseCode',
        );
        return null;
      }

      _logger.d(
        '[COURSE_REMOTE_SOURCE] ✅ GET successful: ${studentCode}_$courseCode',
      );
      return _reconstructCourseFromApiResponse(
        data.first as Map<String, dynamic>,
        studentCode,
        courseCode,
      );
    } on DioException catch (e) {
      _logger.e('[COURSE_REMOTE_SOURCE] ❌ GET failed: $e');
      rethrow;
    }
  }

  /// Create a new course tracking record
  Future<CourseTracking> create(CourseTracking tracking) async {
    try {
      await _client.http.post(
        '/rest/v1/course_grade_simulator',
        data: {
          'student_code': tracking.studentCode,
          'course_code': tracking.courseCode,
          'categories': _buildCategoriesList(tracking.categories),
          'grades': _buildGradesList(tracking),
          'metadata': <String, dynamic>{},
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
      _logger.d(
        '[COURSE_REMOTE_SOURCE] ✅ POST successful: ${tracking.studentCode}_${tracking.courseCode}',
      );

      // Return the created course
      final result = await fetch(
        studentCode: tracking.studentCode,
        courseCode: tracking.courseCode,
      );
      return result!;
    } on DioException catch (e) {
      _logger.e('[COURSE_REMOTE_SOURCE] ❌ POST failed: $e');
      rethrow;
    }
  }

  /// Delete a course tracking record
  Future<void> delete({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      await _client.http.delete(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
      _logger.d(
        '[COURSE_REMOTE_SOURCE] ✅ DELETE successful: ${studentCode}_$courseCode',
      );
    } on DioException catch (e) {
      _logger.e('[COURSE_REMOTE_SOURCE] ❌ DELETE failed: $e');
      rethrow;
    }
  }

  // 🗂️ DATA TRANSFORMATION HELPERS

  /// Build grades list for API payload (from all categories)
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
  List<Map<String, dynamic>> _buildCategoriesList(
    List<GradeCategory> categories,
  ) {
    return categories
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
      _logger.e('[COURSE_REMOTE_SOURCE] ❌ Error reconstructing course: $e');
      return null;
    }
  }
}
