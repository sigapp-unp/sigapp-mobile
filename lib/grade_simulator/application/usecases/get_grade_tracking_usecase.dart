import 'package:injectable/injectable.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_repository.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/grade_simulator/application/base_grade_tracking_usecase.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';

@injectable
class GetGradeTrackingUseCase extends BaseGradeTrackingUseCase {
  final GradeTrackingRepository _repository;

  GetGradeTrackingUseCase(
    this._repository,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  Future<CourseTracking?> execute({required String courseCode}) async {
    return _repository.getCourseTracking(
      studentCode: await getStudentCode(),
      courseCode: courseCode,
    );
  }
}
