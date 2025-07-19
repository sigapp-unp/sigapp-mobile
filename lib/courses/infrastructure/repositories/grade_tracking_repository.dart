import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart';

@LazySingleton(as: GradeTrackingRepository)
class GradeTrackingRepositoryImpl implements GradeTrackingRepository {
  final ApiGatewayClient _workerClient;
  final Logger _logger;

  GradeTrackingRepositoryImpl(this._workerClient, this._logger);

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      final queryParams = {
        'student_code': 'eq.$studentCode',
        'course_code': 'eq.$courseCode',
        'select': '*,gt_grade_categories(*,gt_grades(*))',
      };

      final response = await _workerClient.http.get(
        '/rest/v1/gt_course_tracking',
        queryParameters: queryParams,
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      final List<dynamic> data = response.data;
      if (data.isEmpty) {
        return null;
      }

      final courseData = data[0];

      // Transform categories data
      final List<Map<String, dynamic>> categoriesData =
          (courseData['gt_grade_categories'] as List)
              .cast<Map<String, dynamic>>();

      final categories =
          categoriesData.map<GradeCategory>((categoryData) {
            final List<Map<String, dynamic>> gradesData =
                (categoryData['gt_grades'] as List)
                    .cast<Map<String, dynamic>>();

            // Transform grades data
            final grades =
                gradesData.map<Grade>((gradeData) {
                  return Grade(
                    id: gradeData['id'],
                    name: gradeData['name'],
                    score: (gradeData['score'] as num).toDouble(),
                    enabled: gradeData['enabled'],
                  );
                }).toList();

            return GradeCategory(
              id: categoryData['id'],
              name: categoryData['name'],
              weight: (categoryData['weight'] as num).toDouble(),
              grades: grades,
            );
          }).toList();

      return CourseTracking(
        id: courseData['id'],
        courseCode: courseData['course_code'],
        studentCode: courseData['student_code'],
        categories: categories,
      );
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in getCourseTracking',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  @override
  Future<CourseTracking> create(CourseTracking data) async {
    try {
      // 1. Insert course tracking record
      final Map<String, dynamic> courseData = {
        'student_code': data.studentCode,
        'course_code': data.courseCode,
      };

      final createResponse = await _workerClient.http.post(
        '/rest/v1/gt_course_tracking',
        data: courseData,
        options: Options(
          headers: {
            'Prefer': 'return=representation',
            'X-Upstream': 'supabase',
          },
        ),
      );

      final courseResponse = createResponse.data[0];
      final String courseTrackingId = courseResponse['id'];

      // List to store categories with their IDs
      final List<GradeCategory> categoriesWithIds = [];

      // 2. Insert categories and collect their data
      for (final category in data.categories) {
        final categoryResponse = await _workerClient.http.post(
          '/rest/v1/gt_grade_categories',
          data: {
            'course_tracking_id': courseTrackingId,
            'name': category.name,
            'weight': category.weight,
          },
          options: Options(
            headers: {
              'Prefer': 'return=representation',
              'X-Upstream': 'supabase',
            },
          ),
        );

        final categoryData = categoryResponse.data[0];
        final String categoryId = categoryData['id'];

        // List to store grades with their IDs
        final List<Grade> gradesWithIds = [];

        // 3. Insert grades for each category and collect their data
        for (final grade in category.grades) {
          final gradeResponse = await _workerClient.http.post(
            '/rest/v1/gt_grades',
            data: {
              'category_id': categoryId,
              'name': grade.name,
              'score': grade.score,
              'enabled': grade.enabled,
            },
            options: Options(
              headers: {
                'Prefer': 'return=representation',
                'X-Upstream': 'supabase',
              },
            ),
          );

          final gradeData = gradeResponse.data[0];
          final String gradeId = gradeData['id'];

          // Add grade with ID to the list
          gradesWithIds.add(
            Grade(
              id: gradeId,
              name: grade.name,
              score: grade.score,
              enabled: grade.enabled,
            ),
          );
        }

        // Add category with ID and its grades to the list
        categoriesWithIds.add(
          GradeCategory(
            id: categoryId,
            name: category.name,
            weight: category.weight,
            grades: gradesWithIds,
          ),
        );
      }

      // Return the complete CourseTracking object with all IDs
      return CourseTracking(
        id: courseTrackingId,
        courseCode: data.courseCode,
        studentCode: data.studentCode,
        categories: categoriesWithIds,
      );
    } catch (e, s) {
      _logger.e('[INFRASTRUCTURE] Error in create', error: e, stackTrace: s);
      throw Exception('Failed to create course tracking data: $e');
    }
  }

  @override
  Future<CourseTracking> createWithDefaults({
    required String studentCode,
    required String courseCode,
    required String courseName,
  }) async {
    try {
      return await create(
        CourseTracking.createWithDefaults(
          courseCode: courseCode,
          studentCode: studentCode,
        ),
      );
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in createWithDefaults',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to create course with defaults: $e');
    }
  }

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    final course = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    if (course == null) {
      throw Exception('Course not found');
    }

    try {
      final categoryResponse = await _workerClient.http.post(
        '/rest/v1/gt_grade_categories',
        data: {
          'course_tracking_id': course.id,
          'name': categoryName,
          'weight': weight,
        },
        options: Options(
          headers: {
            'Prefer': 'return=representation',
            'X-Upstream': 'supabase',
          },
        ),
      );

      final categoryData = categoryResponse.data[0];
      final String categoryId = categoryData['id'];

      final newCategory = GradeCategory(
        id: categoryId,
        name: categoryName,
        weight: weight,
        grades: [],
      );

      final updatedCategories = [...course.categories, newCategory];
      final updatedTracking = CourseTracking(
        id: course.id,
        courseCode: course.courseCode,
        studentCode: course.studentCode,
        categories: updatedCategories,
      );

      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in addCategory',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to add category: $e');
    }
  }

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    final course = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    if (course == null) {
      throw Exception('Course not found');
    }

    try {
      final gradeResponse = await _workerClient.http.post(
        '/rest/v1/gt_grades',
        data: {
          'category_id': categoryId,
          'name': gradeName,
          'score': score,
          'enabled': true,
        },
        options: Options(
          headers: {
            'Prefer': 'return=representation',
            'X-Upstream': 'supabase',
          },
        ),
      );

      final gradeData = gradeResponse.data[0];
      final String gradeId = gradeData['id'];

      final newGrade = Grade(id: gradeId, name: gradeName, score: score);

      final updatedCategories =
          course.categories.map((category) {
            if (category.id == categoryId) {
              return GradeCategory(
                id: category.id,
                name: category.name,
                weight: category.weight,
                grades: [...category.grades, newGrade],
              );
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: course.id,
        courseCode: course.courseCode,
        studentCode: course.studentCode,
        categories: updatedCategories,
      );

      return updatedTracking;
    } catch (e, s) {
      _logger.e('[INFRASTRUCTURE] Error in addGrade', error: e, stackTrace: s);
      throw Exception('Failed to add grade: $e');
    }
  }

  @override
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) async {
    final course = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    if (course == null) {
      throw Exception('Course not found');
    }

    try {
      await _workerClient.http.delete(
        '/rest/v1/gt_grade_categories',
        queryParameters: {
          'id': 'eq.$categoryId',
          'course_tracking_id': 'eq.${course.id}',
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      final updatedCategories =
          course.categories
              .where((category) => category.id != categoryId)
              .toList();

      final updatedTracking = CourseTracking(
        id: course.id,
        courseCode: course.courseCode,
        studentCode: course.studentCode,
        categories: updatedCategories,
      );

      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in deleteCategory',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to delete category: $e');
    }
  }

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    final course = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    if (course == null) {
      throw Exception('Course not found');
    }

    try {
      await _workerClient.http.delete(
        '/rest/v1/gt_grades',
        queryParameters: {'id': 'eq.$gradeId', 'category_id': 'eq.$categoryId'},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      final updatedCategories =
          course.categories.map((category) {
            if (category.id == categoryId) {
              final updatedGrades =
                  category.grades
                      .where((grade) => grade.id != gradeId)
                      .toList();

              return GradeCategory(
                id: category.id,
                name: category.name,
                weight: category.weight,
                grades: updatedGrades,
              );
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: course.id,
        courseCode: course.courseCode,
        studentCode: course.studentCode,
        categories: updatedCategories,
      );

      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in deleteGrade',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to delete grade: $e');
    }
  }

  @override
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    final course = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    if (course == null) {
      throw Exception('Course not found');
    }

    try {
      await _workerClient.http.patch(
        '/rest/v1/gt_grade_categories',
        data: {'name': newName, 'weight': newWeight},
        queryParameters: {
          'id': 'eq.$categoryId',
          'course_tracking_id': 'eq.${course.id}',
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      final updatedCategories =
          course.categories.map((category) {
            if (category.id == categoryId) {
              return GradeCategory(
                id: category.id,
                name: newName,
                weight: newWeight,
                grades: category.grades,
              );
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: course.id,
        courseCode: course.courseCode,
        studentCode: course.studentCode,
        categories: updatedCategories,
      );

      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in updateCategory',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to update category: $e');
    }
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
    final course = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    if (course == null) {
      throw Exception('Course not found');
    }

    try {
      await _workerClient.http.patch(
        '/rest/v1/gt_grades',
        data: {'name': newName, 'score': newScore},
        queryParameters: {'id': 'eq.$gradeId', 'category_id': 'eq.$categoryId'},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      final updatedCategories =
          course.categories.map((category) {
            if (category.id == categoryId) {
              final updatedGrades =
                  category.grades.map((grade) {
                    if (grade.id == gradeId) {
                      return Grade(
                        id: grade.id,
                        name: newName,
                        score: newScore,
                        enabled: grade.enabled,
                      );
                    }
                    return grade;
                  }).toList();

              return GradeCategory(
                id: category.id,
                name: category.name,
                weight: category.weight,
                grades: updatedGrades,
              );
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: course.id,
        courseCode: course.courseCode,
        studentCode: course.studentCode,
        categories: updatedCategories,
      );

      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in updateGrade',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to update grade: $e');
    }
  }

  @override
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    final course = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    if (course == null) {
      throw Exception('Course not found');
    }

    try {
      await _workerClient.http.patch(
        '/rest/v1/gt_grades',
        data: {'enabled': enabled},
        queryParameters: {'id': 'eq.$gradeId', 'category_id': 'eq.$categoryId'},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      final updatedCategories =
          course.categories.map((category) {
            if (category.id == categoryId) {
              final updatedGrades =
                  category.grades.map((grade) {
                    if (grade.id == gradeId) {
                      return grade.copyWith(enabled: enabled);
                    }
                    return grade;
                  }).toList();

              return category.copyWith(grades: updatedGrades);
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: course.id,
        courseCode: course.courseCode,
        studentCode: course.studentCode,
        categories: updatedCategories,
      );

      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in toggleGradeEnabled',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to toggle grade enabled state: $e');
    }
  }

  @override
  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      _logger.d(
        '[INFRASTRUCTURE] Deleting course tracking for student: $studentCode, course: $courseCode',
      );

      final queryParams = {
        'student_code': 'eq.$studentCode',
        'course_code': 'eq.$courseCode',
      };

      await _workerClient.http.delete(
        '/rest/v1/gt_course_tracking',
        queryParameters: queryParams,
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      _logger.d('[INFRASTRUCTURE] Course tracking deleted successfully');
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error in deleteCourseTracking',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to delete course tracking: $e');
    }
  }
}
