import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';

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
  Future<void> execute(CourseViewMode mode) async {
    try {
      final studentCode = await _getStudentCode();

      // Get current global preferences
      final currentGlobalPrefs = await _preferencesRepository
          .getGlobalPreferences(studentCode: studentCode);

      // Update only the view mode preference
      final updatedGlobalPrefs = currentGlobalPrefs.copyWith(
        courseChain: currentGlobalPrefs.courseChain.copyWith(viewMode: mode),
      );

      await _preferencesRepository.updateGlobalPreferences(
        studentCode: studentCode,
        preferences: updatedGlobalPrefs,
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
