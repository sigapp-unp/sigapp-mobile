import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/services/student_session_service.dart';
import 'package:sigapp/courses/application/usecases/get_enrolled_courses_usecase.dart';
import 'package:sigapp/courses/domain/entities/scheduled_term_identifier.dart';
import 'package:sigapp/student/domain/value_objects/academic_info_data.dart';
import 'package:sigapp/student/domain/value_objects/semester_context.dart';
import 'package:sigapp/student/application/usecases/get_academic_report_usecase.dart';
import 'package:sigapp/student/domain/entities/student_academic_report.dart';
import 'package:sigapp/student/domain/services/academic_info_service.dart';

@Singleton(as: AcademicInfoService)
class AcademicInfoServiceImpl extends AcademicInfoService {
  AcademicInfoData? _data;

  final GetAcademicReportUsecase _getAcademicReportUsecase;
  final StudentSessionService _studentSessionService;
  final GetEnrolledCoursesUsecase _getEnrolledCoursesUsecase;

  AcademicInfoServiceImpl(
    this._getAcademicReportUsecase,
    this._getEnrolledCoursesUsecase,
    this._studentSessionService,
  );

  @override
  Future<AcademicInfoData> getSessionInfo() async {
    if (_data != null) {
      return _data!;
    }

    final academicReport = await _getAcademicReportUsecase.execute();
    final semesterContext = await _calculateSemesterContext(academicReport);

    _data = AcademicInfoData(
      academicReport: academicReport,
      semesterContext: semesterContext,
      academicProgram: AcademicProgramIdentifier.identifyProgram(
        academicReport.school,
      ),
    );

    return _data!;
  }

  @override
  void clearSessionInfo() {
    _data = null;
  }

  Future<SemesterContext> _calculateSemesterContext(
    AcademicReport academicReport,
  ) async {
    final firstSemester = academicReport.enrollmentSemester;
    final studentSessionInfo = await _studentSessionService.getInfo();

    // Case 1: Estudiante actualmente matriculado
    final currentSemesterEnrolledCourses = await _getEnrolledCoursesUsecase
        .execute(studentSessionInfo.currentSemester.id);
    if (currentSemesterEnrolledCourses.isNotEmpty) {
      return SemesterContext(
        availableSemesters: _buildSemesterRange(
          firstSemester,
          studentSessionInfo.currentSemester,
        ),
        defaultSemester: studentSessionInfo.currentSemester,
        contextType: SemesterContextType.currentlyEnrolled,
      );
    }

    // Case 2: Estudiante egresado con último semestre conocido
    final lastKnownSemester = academicReport.lastSemester;
    if (lastKnownSemester != null) {
      return SemesterContext(
        availableSemesters: _buildSemesterRange(
          firstSemester,
          lastKnownSemester,
        ),
        defaultSemester: lastKnownSemester,
        contextType: SemesterContextType.completedLastEnrolled,
      );
    }

    // Case 3: Último semestre desconocido (notas pendientes)
    return SemesterContext(
      availableSemesters: _buildSemesterRange(
        firstSemester,
        studentSessionInfo.currentSemester,
      ),
      defaultSemester: firstSemester,
      contextType: SemesterContextType.unknownLastEnrolled,
    );
  }

  List<ScheduledTermIdentifier> _buildSemesterRange(
    ScheduledTermIdentifier firstSemester,
    ScheduledTermIdentifier lastSemester,
  ) {
    List<ScheduledTermIdentifier> semesters = [];
    for (var year = firstSemester.year; year <= lastSemester.year; year++) {
      var startPeriod = (year == firstSemester.year) ? firstSemester.period : 0;
      var endPeriod = (year == lastSemester.year) ? lastSemester.period : 2;
      for (
        var yearPeriod = startPeriod;
        yearPeriod <= endPeriod;
        yearPeriod++
      ) {
        semesters.add(ScheduledTermIdentifier.buildFromId('$year$yearPeriod'));
      }
    }
    return semesters;
  }
}
