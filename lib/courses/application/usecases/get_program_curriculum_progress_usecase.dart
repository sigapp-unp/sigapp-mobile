import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/usecases/get_enrolled_courses_usecase.dart';
import 'package:sigapp/courses/domain/entities/academic_history_term.dart';
import 'package:sigapp/courses/domain/repositories/program_curriculum_repository.dart';
import 'package:sigapp/courses/domain/entities/program_curriculum_course_term.dart';
import 'package:sigapp/courses/domain/value-objects/program_curriculum_progress.dart';
import 'package:sigapp/student/application/usecases/get_academic_info_usecase.dart';
import 'package:sigapp/student/domain/value_objects/semester_context.dart';

@lazySingleton
class GetProgramCurriculumProgressUsecase {
  final ProgramCurriculumRepository _programCurriculumRepository;
  final GetAcademicInfoUseCase _getAcademicInfoUseCase;
  final GetEnrolledCoursesUsecase _getEnrolledCoursesUsecase;
  final Logger _logger;

  GetProgramCurriculumProgressUsecase(
    this._programCurriculumRepository,
    this._getAcademicInfoUseCase,
    this._getEnrolledCoursesUsecase,
    this._logger,
  );

  Future<ProgramCurriculumProgress> execute() async {
    final programCurriculum = await _getTermCoursesMap();
    List<AcademicHistoryTerm> academicHistoryTerms = [];
    try {
      academicHistoryTerms =
          await _programCurriculumRepository.getAcademicHistory();
    } catch (e, s) {
      _logger.e(
        '[DOMAIN] Error getting academic history: $e',
        error: e,
        stackTrace: s,
      );
    }

    await _setLastGradesForCourses(programCurriculum, academicHistoryTerms);
    await _setEnrolledCourses(programCurriculum);

    return ProgramCurriculumProgress(
      programCurriculum: programCurriculum,
      academicHistory: academicHistoryTerms,
    );
  }

  Future<List<ProgramCurriculumTerm>> _getTermCoursesMap() async {
    final courseInfos =
        await _programCurriculumRepository.getProgramCurriculum();
    final courses =
        courseInfos
            .map(
              (info) => ProgramCurriculumCourse(info: info, prerequisites: []),
            )
            .toList();
    final courseCodeMap = {for (var e in courses) e.info.courseCode: e};
    for (var course in courses) {
      for (final code in course.info.requirementCourseCodes) {
        final prerequisite = courseCodeMap[code];
        if (prerequisite != null) {
          course.prerequisites.add(prerequisite);
        }
      }
    }
    final termNumberMap = <int, List<ProgramCurriculumCourse>>{};
    for (var course in courses) {
      final termNumber = course.info.termNumber;
      if (!termNumberMap.containsKey(termNumber)) {
        termNumberMap[termNumber] = [];
      }
      termNumberMap[termNumber]!.add(course);
    }
    final terms =
        termNumberMap.entries
            .map(
              (entry) => ProgramCurriculumTerm(
                termNumber: entry.key,
                courses: entry.value,
              ),
            )
            .toList();
    return terms;
  }

  Future<void> _setLastGradesForCourses(
    List<ProgramCurriculumTerm> programCurriculum,
    List<AcademicHistoryTerm> academicHistoryTerms,
  ) async {
    final academicHistoryCourses =
        academicHistoryTerms.expand((term) => term.courses).toList();

    for (var term in programCurriculum) {
      for (var course in term.courses) {
        final matchingHistory = academicHistoryCourses.where(
          (courseHistory) => courseHistory.courseCode == course.info.courseCode,
        );

        for (final courseHistory in matchingHistory) {
          courseHistory.programCurriculumCourse = course;
        }

        if (matchingHistory.isNotEmpty) {
          course.lastGrade = matchingHistory.last.grade;
        }
      }
    }
  }

  Future<void> _setEnrolledCourses(
    List<ProgramCurriculumTerm> programCurriculum,
  ) async {
    final semesterContext = await _getAcademicInfoUseCase.execute().then(
      (v) => v.semesterContext,
    );

    if (semesterContext.contextType != SemesterContextType.currentlyEnrolled) {
      return;
    }

    final enrolledCourses = await _getEnrolledCoursesUsecase.execute(
      semesterContext.defaultSemester.id,
    );

    final coursesWithoutGrades = programCurriculum
        .expand((term) => term.courses)
        .where((course) => course.lastGrade == null);

    for (var course in coursesWithoutGrades) {
      course.isEnrolled = enrolledCourses.any(
        (enrolledCourse) =>
            enrolledCourse.data.courseCode == course.info.courseCode,
      );
    }
  }
}
