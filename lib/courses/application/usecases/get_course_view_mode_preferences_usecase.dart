import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/shared/application/usecases/base_get_student_code_usecase.dart';

@injectable
class GetCourseViewModeUseCase extends BaseGetStudentCodeUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final Logger _logger;

  GetCourseViewModeUseCase(
    this._preferencesRepository,
    StudentSessionRepository studentSessionRepository,
    this._logger,
  ) : super(studentSessionRepository);

  /// Gets the current view mode for course prerequisite chains
  Future<CourseViewMode> execute() async {
    try {
      final studentCode = await getStudentCode();
      final globalPreferences = await _preferencesRepository
          .getGlobalPreferences(studentCode: studentCode);
      return globalPreferences.courseChain.viewMode;
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error getting course view mode, using default',
        error: e,
        stackTrace: s,
      );
      return CourseViewMode.tree; // Default fallback
    }
  }
}
