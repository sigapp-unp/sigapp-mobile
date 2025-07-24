import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/value_objects/preference_keys.dart';

@injectable
class SetHighlightCriticalPathPreferencesUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;
  final Logger _logger;

  const SetHighlightCriticalPathPreferencesUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
    this._logger,
  );

  /// Sets whether critical path highlighting is enabled
  Future<void> execute(bool enabled) async {
    try {
      final studentCode = await _getStudentCode();
      await _preferencesRepository.setPreference(
        studentCode: studentCode,
        path: PreferenceKeys.courseChainHighlightCriticalPath,
        value: enabled, // Store as boolean directly
      );

      _logger.d('[USE_CASE] Highlight critical path updated to: $enabled');
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error setting highlight critical path preference',
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
