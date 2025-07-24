import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:sigapp/courses/domain/entities/course_type.dart';
import 'package:sigapp/courses/domain/entities/program_curriculum_course_term.dart';
import 'package:sigapp/shared/domain/value_objects/scheduled_term_identifier.dart';

part 'academic_history_term.freezed.dart';

@freezed
abstract class AcademicHistoryTerm with _$AcademicHistoryTerm {
  const factory AcademicHistoryTerm({
    // required String termLabel,
    required ScheduledTermIdentifier term,
    required AcademicHistoryTermStatistics? statistics,
    required List<AcademicHistoryCourse> courses,
  }) = _AcademicHistoryTerm;
}

@freezed
abstract class AcademicHistoryTermStatistics
    with _$AcademicHistoryTermStatistics {
  const factory AcademicHistoryTermStatistics({
    // required String PPS,
    required double termWeightedAverage,
    // required String PPSAprob,
    required double termWeightedAveragePassed,
    // required String PPA,
    required double cumulativeWeightedAverage,
    // required String PPAApr,
    required double cumulativeWeightedAveragePassed,
    // required String CreOblLlev,
    required int mandatoryCreditsTaken,
    // required String CreElLlev,
    required int electiveCreditsTaken,
    // required String CreOblApr,
    required int mandatoryCreditsPassed,
    // required String CreEleApr,
    required int electiveCreditsPassed,
    // required String CreOblConv,
    required int mandatoryCreditsValidated,
    // required String CredEleConv,
    required int electiveCreditsValidated,
    // required String TotalCredOblLlev,
    required int totalMandatoryCreditsTaken,
    // required String TotalCredElLlev,
    required int totalElectiveCreditsTaken,
    // required String TotalCredOblAprob,
    required int totalMandatoryCreditsPassed,
    // required String TotalCredElAprob,
    required int totalElectiveCreditsPassed,
    // required String TotalCredOblConv,
    required int totalMandatoryCreditsValidated,
  }) = _AcademicHistoryTermStatistics;
}

class AcademicHistoryCourse {
  final String courseCode;
  final String courseName;
  final CourseType courseType;
  final int credits;
  final double grade;
  ProgramCurriculumCourse? programCurriculumCourse;

  AcademicHistoryCourse({
    required this.courseCode,
    required this.courseName,
    required this.courseType,
    required this.credits,
    required this.grade,
  });

  bool get isApproved => grade >= 11;
}
