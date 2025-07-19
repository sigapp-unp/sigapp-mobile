import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/enums/course_view_mode.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/value_objects/preference_keys.dart';

@injectable
class GetCourseViewModeUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;
  final Logger _logger;

  const GetCourseViewModeUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
    this._logger,
  );

  /// Gets the current view mode for course prerequisite chains
  Future<CourseViewMode> call() async {
    try {
      final studentCode = await _getStudentCode();
      final value = await _preferencesRepository.getPreference(
        studentCode: studentCode,
        path: PreferenceKeys.courseChainViewMode,
      );

      if (value is String) {
        return CourseViewMode.fromString(value);
      }

      // Default fallback
      return CourseViewMode.tree;
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error getting course view mode, using default',
        error: e,
        stackTrace: s,
      );
      return CourseViewMode.tree; // Default fallback
    }
  }

  Future<String> _getStudentCode() async {
    final info = await _studentSessionRepository.getStudentSessionInfo();
    return info.studentCode;
  }
}
