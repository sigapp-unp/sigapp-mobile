import 'package:injectable/injectable.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/grade_simulator/application/base_grade_tracking_usecase.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_grade_repository.dart';

@injectable
class ManageGradeTrackingGradesUseCase extends BaseGradeTrackingUseCase {
  final GradeTrackingGradeRepository _repository;

  ManageGradeTrackingGradesUseCase(
    this._repository,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  Future<CourseTracking> addGrade({
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    return _repository.addGrade(
      studentCode: await getStudentCode(),
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
      studentCode: await getStudentCode(),
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
      studentCode: await getStudentCode(),
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
      studentCode: await getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
      gradeId: gradeId,
      enabled: enabled,
    );
  }
}
