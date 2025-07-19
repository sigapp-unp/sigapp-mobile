import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/enums/course_view_mode.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/value_objects/preference_keys.dart';

@injectable
class SetCourseViewModePreferencesUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;
  final Logger _logger;

  const SetCourseViewModePreferencesUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
    this._logger,
  );

  /// Sets the view mode for course prerequisite chains
  Future<void> call(CourseViewMode mode) async {
    try {
      final studentCode = await _getStudentCode();
      await _preferencesRepository.setPreference(
        studentCode: studentCode,
        path: PreferenceKeys.courseChainViewMode,
        value: mode.value, // Store as string
      );

      _logger.d('[USE_CASE] Course view mode updated to: ${mode.value}');
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error setting course view mode',
        error: e,
        stackTrace: s,
      );
      rethrow; // Let the UI handle the error
    }
  }

  Future<String> _getStudentCode() async {
    final info = await _studentSessionRepository.getStudentSessionInfo();
    return info.studentCode;
  }
}
