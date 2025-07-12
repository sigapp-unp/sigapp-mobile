import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
// import 'package:sigapp/courses/application/services/student_session_service.dart';
import 'package:sigapp/courses/domain/repositories/regeva_repository.dart';
import 'package:sigapp/courses/domain/value-objects/course_grade.dart';

@lazySingleton
class GetCourseGradeUsecase {
  final StudentSessionRepository _studentSessionRepository;
  final RegevaRepository _regevaRepository;
  final Logger _logger;

  GetCourseGradeUsecase(
    this._studentSessionRepository,
    this._regevaRepository,
    this._logger,
  );

  Future<CourseGradeInfo> execute(
    String scheduledCourseId, {
    bool? forceRefresh,
  }) async {
    final credentials = await _studentSessionRepository.getStudentSessionInfo(
      forceRefresh: forceRefresh,
    );

    CourseGradePreview grade;
    try {
      final courseGrade = await _regevaRepository.getCourseGrade(
        scheduledCourseId: scheduledCourseId,
        studentCode: credentials.studentCode,
        sigaToken1: credentials.regevaToken1,
        sigaToken2: credentials.regevaToken2,
      );

      if (courseGrade == null) {
        grade = CourseGradePreview.empty();
      } else {
        grade = CourseGradePreview.loaded(
          value: courseGrade.value,
          isPartial: courseGrade.isPartial,
        );
      }
    } catch (error, stackTrace) {
      _logger.e(
        'Error fetching course grade',
        error: error,
        stackTrace: stackTrace,
      );
      grade = CourseGradePreview.error(error);
    }

    return CourseGradeInfo(
      grade: grade,
      url: _regevaRepository.buildGradesUrl(
        scheduledCourseId: scheduledCourseId,
        studentCode: credentials.studentCode,
        token1: credentials.regevaToken1,
        token2: credentials.regevaToken2,
      ),
    );
  }
}
