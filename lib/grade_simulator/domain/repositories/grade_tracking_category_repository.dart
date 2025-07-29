import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';

abstract class GradeTrackingCategoryRepository {
  /// Agregar una nueva categoría
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  });

  /// Eliminar una categoría
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  });

  /// Actualizar una categoría
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  });

  /// Operación granular: actualizar solo el campo de categorías
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  });
}
