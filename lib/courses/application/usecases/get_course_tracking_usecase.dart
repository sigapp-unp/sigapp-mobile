import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/application/usecases/base_grade_tracking_usecase.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart';

@injectable
class GetCourseTrackingUseCase extends BaseGradeTrackingUseCase {
  final GradeTrackingRepository _repository;

  GetCourseTrackingUseCase(
    this._repository,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  Future<CourseTracking?> call({required String courseCode}) async {
    return _repository.getCourseTracking(
      studentCode: await getStudentCode(),
      courseCode: courseCode,
    );
  }
}
