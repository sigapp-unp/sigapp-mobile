import 'package:injectable/injectable.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/grade_simulator/application/base_grade_tracking_usecase.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_course_repository.dart';

@injectable
class GradeSimulatorCreateUseCase extends BaseGradeTrackingUseCase {
  final GradeTrackingCourseRepository _repository;

  GradeSimulatorCreateUseCase(
    this._repository,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  Future<CourseTracking> execute({
    required String courseCode,
    required String courseName,
  }) async {
    final defaultTracking = CourseTracking.createWithDefaults(
      studentCode: await getStudentCode(),
      courseCode: courseCode,
    );
    return _repository.create(defaultTracking);
  }
}
