import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/value_objects/preference_keys.dart';

@injectable
class GetHighlightCriticalPathUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;
  final Logger _logger;

  const GetHighlightCriticalPathUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
    this._logger,
  );

  /// Gets whether critical path highlighting is enabled
  Future<bool> execute() async {
    try {
      final studentCode = await _getStudentCode();
      final value = await _preferencesRepository.getPreference(
        studentCode: studentCode,
        path: PreferenceKeys.courseChainHighlightCriticalPath,
      );

      // Handle boolean directly (no string conversion needed)
      return value is bool ? value : false;
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error getting highlight critical path preference, using default',
        error: e,
        stackTrace: s,
      );
      return false; // Default fallback
    }
  }

  Future<String> _getStudentCode() async {
    final info = await _studentSessionRepository.getStudentSessionInfo();
    return info.studentCode;
  }
}
