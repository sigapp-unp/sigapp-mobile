import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/application/value-objects/student_session_info.dart';
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

  Future<CourseGradeInfo> execute(String scheduledCourseId) async {
    final StudentSessionInfo(:studentCode, :regevaToken1, :regevaToken2) =
        await _studentSessionRepository.getStudentSessionInfo();

    CourseGradePreview grade;
    try {
      final courseGrade = await _regevaRepository.getCourseGrade(
        scheduledCourseId: scheduledCourseId,
        studentCode: studentCode,
        sigaToken1: regevaToken1,
        sigaToken2: regevaToken2,
      );

      if (courseGrade == null) {
        grade = CourseGradePreview.empty();
      } else {
        grade = CourseGradePreview.loaded(courseGrade);
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
        studentCode: studentCode,
        token1: regevaToken1,
        token2: regevaToken2,
      ),
    );
  }
}
