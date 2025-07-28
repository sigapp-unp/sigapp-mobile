import 'package:sigapp/courses/domain/entities/grade_tracking.dart';

abstract class GradeTrackingGradeRepository {
  /// Agregar una nueva nota
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  });

  /// Eliminar una nota
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  });

  /// Actualizar una nota
  Future<CourseTracking> updateGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  });

  /// Habilitar/deshabilitar una nota
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  });

  /// Operación granular: actualizar notas de una categoría específica
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  });

  /// Operación batch: actualizar notas de múltiples categorías
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  });
}
