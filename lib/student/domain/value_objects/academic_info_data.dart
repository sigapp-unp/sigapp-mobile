import 'package:sigapp/shared/domain/entities/student_academic_report.dart';
import 'package:sigapp/shared/domain/value_objects/semester_context.dart';

class AcademicInfoData {
  final AcademicReport academicReport;
  final SemesterContext semesterContext;

  AcademicInfoData({
    required this.academicReport,
    required this.semesterContext,
  });
}
