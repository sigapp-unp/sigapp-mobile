import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/value_objects/preference_keys.dart';

@injectable
class GetAllHiddenCoursesPreferencesUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;
  final Logger _logger;

  const GetAllHiddenCoursesPreferencesUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
    this._logger,
  );

  /// Gets a list of all hidden schedule event IDs
  Future<List<String>> execute() async {
    try {
      final studentCode = await _getStudentCode();
      return await _getHiddenScheduleEvents(studentCode: studentCode);
    } catch (e, s) {
      _logger.w(
        '[USE_CASE] Error getting hidden schedule events, returning empty list',
        error: e,
        stackTrace: s,
      );
      return []; // Graceful fallback
    }
  }

  Future<String> _getStudentCode() async {
    final info = await _studentSessionRepository.getStudentSessionInfo();
    return info.studentCode;
  }

  Future<List<String>> _getHiddenScheduleEvents({
    required String studentCode,
  }) async {
    try {
      final preference = await _preferencesRepository.getPreference(
        studentCode: studentCode,
        path: PreferenceKeys.scheduleHiddenEvents,
      );

      if (preference is List) {
        return List<String>.from(preference);
      }

      return [];
    } catch (e) {
      _logger.w('Error getting hidden schedule events: $e');
      return [];
    }
  }
}
