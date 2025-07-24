import 'package:sigapp/courses/application/value-objects/student_session_info.dart';

abstract class StudentSessionRepository {
  Future<StudentSessionInfo> getStudentSessionInfo();
  void clearCache();
}
