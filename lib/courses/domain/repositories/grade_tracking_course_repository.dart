import 'package:sigapp/courses/domain/entities/grade_tracking.dart';

abstract class GradeTrackingCourseRepository {
  /// Obtener el tracking completo de un curso
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  });

  /// Crear un nuevo tracking de curso
  Future<CourseTracking> create(CourseTracking tracking);

  /// Eliminar completamente el tracking de un curso
  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  });
}
