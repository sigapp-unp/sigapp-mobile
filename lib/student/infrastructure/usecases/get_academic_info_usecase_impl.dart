import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/application/usecases/get_enrolled_courses_usecase.dart';
import 'package:sigapp/courses/domain/entities/scheduled_term_identifier.dart';
import 'package:sigapp/student/application/usecases/get_academic_info_usecase.dart';
import 'package:sigapp/student/domain/value_objects/academic_info_data.dart';
import 'package:sigapp/student/domain/value_objects/semester_context.dart';
import 'package:sigapp/student/application/usecases/get_academic_report_usecase.dart';
import 'package:sigapp/student/domain/entities/student_academic_report.dart';

@Named('getAcademicInfoUseCaseImpl')
@Singleton()
class GetAcademicInfoUseCaseImpl implements GetAcademicInfoUseCase {
  final GetAcademicReportUsecase _getAcademicReportUsecase;
  final StudentSessionRepository _studentSessionRepository;
  final GetEnrolledCoursesUsecase _getEnrolledCoursesUsecase;

  GetAcademicInfoUseCaseImpl(
    this._getAcademicReportUsecase,
    this._getEnrolledCoursesUsecase,
    this._studentSessionRepository,
  );

  @override
  Future<AcademicInfoData> execute({bool? forceRefresh}) async {
    final academicReport = await _getAcademicReportUsecase.execute(
      forceRefresh: forceRefresh,
    );
    final semesterContext = await _calculateSemesterContext(
      academicReport,
      forceRefresh,
    );

    return AcademicInfoData(
      academicReport: academicReport,
      semesterContext: semesterContext,
      faculty: FacultyIdentifier.identifyFaculty(academicReport.faculty),
    );
  }

  Future<SemesterContext> _calculateSemesterContext(
    AcademicReport academicReport,
    bool? forceRefresh,
  ) async {
    final firstSemester = academicReport.enrollmentSemester;
    final studentSessionInfo = await _studentSessionRepository
        .getStudentSessionInfo(forceRefresh: forceRefresh);

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
