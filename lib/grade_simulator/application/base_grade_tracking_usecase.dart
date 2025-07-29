import 'package:sigapp/shared/application/repositories/student_session_repository.dart';

/// Base class for grade tracking use cases that provides common functionality
abstract class BaseGradeTrackingUseCase {
  final StudentSessionRepository studentSessionRepository;

  BaseGradeTrackingUseCase(this.studentSessionRepository);

  /// Helper method to get the current student code
  Future<String> getStudentCode() async {
    final info = await studentSessionRepository.getStudentSessionInfo();
    return info.studentCode;
  }
}
