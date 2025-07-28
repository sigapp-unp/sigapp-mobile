import 'package:injectable/injectable.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/application/usecases/base_grade_tracking_usecase.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';

@injectable
class CreateGradeTrackingUseCase extends BaseGradeTrackingUseCase {
  final GradeTrackingCourseRepository _repository;

  CreateGradeTrackingUseCase(
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
