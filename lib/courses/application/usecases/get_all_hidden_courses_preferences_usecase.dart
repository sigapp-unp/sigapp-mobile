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

  /// Gets a list of all hidden course event IDs
  Future<List<String>> call() async {
    try {
      final studentCode = await _getStudentCode();
      final preferences = await _preferencesRepository.getUserPreferences(
        studentCode: studentCode,
      );

      final courseVisibility =
          preferences[PreferenceKeys.courseVisibility] as Map<String, dynamic>?;

      if (courseVisibility == null) return [];

      final hiddenEventIds = <String>[];
      courseVisibility.forEach((eventId, isHidden) {
        if (isHidden == true) {
          hiddenEventIds.add(eventId);
        }
      });

      return hiddenEventIds;
    } catch (e, s) {
      _logger.w(
        '[USE_CASE] Error getting hidden courses, returning empty list',
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
}
