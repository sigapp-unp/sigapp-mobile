import 'package:injectable/injectable.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_repository.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/shared/application/usecases/base_get_student_code_usecase.dart';

@injectable
class DeleteGradeTrackingUseCase extends BaseGetStudentCodeUseCase {
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
