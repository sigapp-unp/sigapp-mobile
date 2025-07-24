import 'package:sigapp/shared/domain/value_objects/scheduled_term_identifier.dart';

class StudentSessionInfo {
  final String studentCode;
  final String schoolName;
  final ScheduledTermIdentifier currentSemester;
  final String regevaToken1;
  final String regevaToken2;

  StudentSessionInfo({
    required this.studentCode,
    required this.schoolName,
    required this.currentSemester,
    required this.regevaToken1,
    required this.regevaToken2,
  });
}
