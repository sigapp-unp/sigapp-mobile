import 'package:sigapp/courses/application/value-objects/student_session_info.dart';

abstract class StudentSessionRepository {
  // TODO: `forceRefresh` not being used
  Future<StudentSessionInfo> getStudentSessionInfo({bool? forceRefresh});
}
