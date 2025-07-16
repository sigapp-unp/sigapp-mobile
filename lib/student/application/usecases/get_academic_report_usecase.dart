import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/entities/scheduled_term_identifier.dart';
import 'package:sigapp/student/domain/entities/student_academic_report.dart';
import 'package:sigapp/student/domain/repositories/student_repository.dart';
import 'package:sigapp/student/domain/value_objects/academic_info_data.dart';

@lazySingleton
class GetAcademicReportUsecase {
  final StudentRepository _studentRepository;
  final StudentSessionRepository _studentSessionRepository;

  GetAcademicReportUsecase(
    this._studentRepository,
    this._studentSessionRepository,
  );

  Future<AcademicReport> execute({bool? forceRefresh}) async {
    final academicReportModel = await _studentRepository
        .getAcademicReport(forceRefresh: forceRefresh)
        .then(
          (value) => value.copyWith(
            lastSemesterId: value.lastSemesterId?.trim(),
            curriculumSemesterId: value.curriculumSemesterId.trim(),
            enrollmentSemesterId: value.enrollmentSemesterId.trim(),
          ),
        );
    final studentSessionInfo = await _studentSessionRepository
        .getStudentSessionInfo(forceRefresh: forceRefresh);

    final studentInfoParts = academicReportModel.studentName.split(' - ');
    studentInfoParts.replaceRange(1, 2, studentInfoParts[1].split(', '));
    return AcademicReport(
      facultyName: academicReportModel.faculty,
      faculty: FacultyIdentifier.identifyFaculty(academicReportModel.faculty),
      school: studentSessionInfo.schoolName,
      firstName: studentInfoParts[2],
      lastName: studentInfoParts[1],
      code: studentInfoParts[0],
      cohort: academicReportModel.cohort,
      enrollmentSemester: ScheduledTermIdentifier.buildFromId(
        academicReportModel.enrollmentSemesterId,
      ),
      curriculumSemester: academicReportModel.curriculumSemesterId,
      lastSemester:
          academicReportModel.lastSemesterId != null
              ? ScheduledTermIdentifier.buildFromId(
                academicReportModel.lastSemesterId!,
              )
              : null,
      cumulativeWeightedAverage: academicReportModel.cumulativeWeightedAverage,
      cumulativeWeightedAverageOfPassedCourses:
          academicReportModel.cumulativeWeightedAverageOfPassedCourses,
      lastCumulativeWeightedAverage:
          academicReportModel.lastCumulativeWeightedAverage,
      curriculumMandatoryCredits:
          academicReportModel.curriculumMandatoryCredits,
      curriculumElectiveCredits: academicReportModel.curriculumElectiveCredits,
      totalCreditsOfPassedCourses:
          academicReportModel.totalCreditsOfPassedCourses,
      mandatoryCreditsOfPassedCourses:
          academicReportModel.mandatoryCreditsOfPassedCourses,
      electiveCreditsOfPassedCourses:
          academicReportModel.electiveCreditsOfPassedCourses,
      currentSemester: studentSessionInfo.currentSemester,
    );
  }
}
