import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
// import 'package:sigapp/courses/application/services/student_session_service.dart';
import 'package:sigapp/courses/domain/repositories/regeva_repository.dart';
import 'package:sigapp/courses/domain/value-objects/course_grade.dart';

@lazySingleton
class GetCourseGradeUsecase {
  final StudentSessionRepository _studentSessionRepository;
  final RegevaRepository _regevaRepository;

  GetCourseGradeUsecase(this._studentSessionRepository, this._regevaRepository);

  Future<CourseGradeInfo> execute(
    String scheduledCourseId, {
    bool? forceRefresh,
  }) async {
    final credentials = await _studentSessionRepository.getStudentSessionInfo(
      forceRefresh: forceRefresh,
    );
    return CourseGradeInfo(
      grade: await _regevaRepository
          .getCourseGrade(
            scheduledCourseId: scheduledCourseId,
            studentCode: credentials.studentCode,
            sigaToken1: credentials.regevaToken1,
            sigaToken2: credentials.regevaToken2,
          )
          .then((value) {
            if (value == null) {
              return CourseGradePreview.empty();
            }
            return CourseGradePreview.loaded(
              value: value.value,
              isPartial: value.isPartial,
            );
          })
          .catchError((error) {
            return CourseGradePreview.error(error);
          }),
      url: _regevaRepository.buildGradesUrl(
        scheduledCourseId: scheduledCourseId,
        studentCode: credentials.studentCode,
        token1: credentials.regevaToken1,
        token2: credentials.regevaToken2,
      ),
    );
  }
}
