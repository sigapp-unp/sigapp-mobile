import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/value_objects/preference_keys.dart';

@injectable
class SetCourseVisibilityPreferencesUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;
  final Logger _logger;

  const SetCourseVisibilityPreferencesUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
    this._logger,
  );

  /// Sets the visibility state for a specific course event
  /// [isVisible] - true to show the course, false to hide it
  Future<void> execute(String eventId, bool isVisible) async {
    try {
      final studentCode = await _getStudentCode();

      // Store as "hidden" boolean - opposite of visibility
      final isHidden = !isVisible;

      await _preferencesRepository.setPreference(
        studentCode: studentCode,
        path: PreferenceKeys.courseVisibilityEvent(eventId),
        value: isHidden,
      );

      _logger.d(
        '[USE_CASE] Course visibility updated: $eventId = ${isVisible ? "visible" : "hidden"}',
      );
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error setting course visibility',
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
