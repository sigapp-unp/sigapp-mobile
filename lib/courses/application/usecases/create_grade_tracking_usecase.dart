import 'package:injectable/injectable.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/application/usecases/base_grade_tracking_usecase.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart';

@injectable
class CreateGradeTrackingUseCase extends BaseGradeTrackingUseCase {
  final GradeTrackingRepository _repository;

  CreateGradeTrackingUseCase(
    this._repository,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  /// Crea un curso con categorías y notas predeterminadas
  Future<CourseTracking> execute({
    required String courseCode,
    required String courseName,
  }) async {
    // Utiliza el método implementado en el repositorio que a su vez usa
    // la lógica en la entidad CourseTracking
    return _repository.createWithDefaults(
      studentCode: await getStudentCode(),
      courseCode: courseCode,
      courseName: courseName,
    );
  }
}
