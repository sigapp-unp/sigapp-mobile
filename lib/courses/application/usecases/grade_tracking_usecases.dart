import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart';

@lazySingleton
class GradeTrackingUseCases {
  final GradeTrackingRepository _repository;
  final StudentSessionRepository _studentSessionRepository;

  GradeTrackingUseCases(this._repository, this._studentSessionRepository);

  Future<CourseTracking?> getCourseByCourseCode({
    required String courseCode,
  }) async {
    return _repository.getCourseTracking(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
    );
  }

  /// Crea un curso con categorías y notas predeterminadas
  Future<CourseTracking> createCourseTrackingWithDefaults({
    required String courseCode,
    required String courseName,
  }) async {
    // Utiliza el método implementado en el repositorio que a su vez usa
    // la lógica en la entidad CourseTracking
    return _repository.createWithDefaults(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
      courseName: courseName,
    );
  }

  // Métodos para categorías
  Future<CourseTracking> addCategory({
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    return _repository.addCategory(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
      categoryName: categoryName,
      weight: weight,
    );
  }

  Future<CourseTracking> updateCategory({
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    return _repository.updateCategory(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
      newName: newName,
      newWeight: newWeight,
    );
  }

  Future<CourseTracking> removeCategory({
    required String courseCode,
    required String categoryId,
  }) async {
    return _repository.deleteCategory(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
    );
  }

  // Métodos para notas
  Future<CourseTracking> addGrade({
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    return _repository.addGrade(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
      gradeName: gradeName,
      score: score,
    );
  }

  Future<CourseTracking> updateGrade({
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  }) async {
    return _repository.updateGrade(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
      gradeId: gradeId,
      newName: newName,
      newScore: newScore,
    );
  }

  Future<CourseTracking> removeGrade({
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    return _repository.deleteGrade(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
      gradeId: gradeId,
    );
  }

  Future<CourseTracking> toggleGradeEnabled({
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    return _repository.toggleGradeEnabled(
      studentCode: await _getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
      gradeId: gradeId,
      enabled: enabled,
    );
  }

  // Helper method to get student code
  Future<String> _getStudentCode() async {
    final info = await _studentSessionRepository.getStudentSessionInfo();
    return info.studentCode;
  }
}
