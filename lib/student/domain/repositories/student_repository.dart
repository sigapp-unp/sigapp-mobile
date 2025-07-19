import 'package:sigapp/student/domain/value_objects/raw_academic_report.dart';

abstract class StudentRepository {
  Future<RawAcademicReport> getAcademicReport();
  void clearCache();
}
