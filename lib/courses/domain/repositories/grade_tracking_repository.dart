import 'package:sigapp/courses/domain/entities/grade_tracking.dart';

abstract class GradeTrackingRepository {
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  });

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

  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  });

  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
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

  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  });

  // OPERACIONES GRANULARES (para optimización de sincronización)

  /// Actualizar solo las categorías de un curso (operación granular optimizada)
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  });

  /// Actualizar solo las notas de una categoría específica (operación granular optimizada)
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  });

  /// Actualizar notas de múltiples categorías en una sola operación batch (optimización de SyncManager)
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  });
}
