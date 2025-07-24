import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sigapp/shared/domain/value_objects/scheduled_term_identifier.dart';
import 'package:sigapp/shared/domain/entities/student_academic_report.dart';
import 'package:sigapp/student/domain/entities/weekly_schedule_event.dart';

part 'student_semester_schedule.freezed.dart';

@freezed
abstract class SemesterSchedule with _$SemesterSchedule {
  factory SemesterSchedule({
    required AcademicReport studentAcademicReport,
    required List<ScheduledTermIdentifier> semesterList,
    required ScheduledTermIdentifier semester,
    required List<WeeklyScheduleEvent> weeklyEvents,
  }) = _SemesterSchedule;
}
