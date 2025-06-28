import 'package:sigapp/courses/domain/entities/grade_tracking.dart';

abstract class GradeTrackingRepository {
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  });
  Future<CourseTracking> create(CourseTracking data);
  Future<CourseTracking> createWithDefaults({
    required String studentCode,
    required String courseCode,
    required String courseName,
  });
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  });
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  });
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  });
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  });
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  });
  Future<CourseTracking> updateGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  });
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  });
}
