import 'package:injectable/injectable.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/application/usecases/base_grade_tracking_usecase.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart';

@injectable
class DeleteGradeTrackingUseCase extends BaseGradeTrackingUseCase {
  final GradeTrackingRepository _repository;

  DeleteGradeTrackingUseCase(
    this._repository,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  Future<void> execute({required String courseCode}) async {
    return _repository.deleteCourseTracking(
      studentCode: await getStudentCode(),
      courseCode: courseCode,
    );
  }
}
