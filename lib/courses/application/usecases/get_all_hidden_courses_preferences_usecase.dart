import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';

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

  /// Gets a list of all hidden schedule event IDs for a specific semester
  Future<List<String>> execute({required String semesterId}) async {
    try {
      final studentCode = await _getStudentCode();
      final preferences = await _preferencesRepository.getSemesterPreferences(
        studentCode: studentCode,
        semesterId: semesterId,
      );
      return preferences.scheduleHiddenEvents;
    } catch (e, s) {
      _logger.w(
        '[USE_CASE] Error getting hidden schedule events for semester $semesterId, returning empty list',
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
