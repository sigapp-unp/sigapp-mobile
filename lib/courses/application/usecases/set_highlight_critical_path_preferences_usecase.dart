import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/shared/application/usecases/base_get_student_code_usecase.dart';

@injectable
class SetHighlightCriticalPathPreferencesUseCase
    extends BaseGetStudentCodeUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final Logger _logger;

  SetHighlightCriticalPathPreferencesUseCase(
    this._preferencesRepository,
    this._logger,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  /// Sets whether critical path highlighting is enabled
  Future<void> execute(bool enabled) async {
    try {
      final studentCode = await getStudentCode();

      // Get current global preferences
      final currentGlobalPrefs = await _preferencesRepository
          .getGlobalPreferences(studentCode: studentCode);

      // Update only the critical path preference
      final updatedGlobalPrefs = currentGlobalPrefs.copyWith(
        courseChain: currentGlobalPrefs.courseChain.copyWith(
          highlightCriticalPath: enabled,
        ),
      );

      await _preferencesRepository.updateGlobalPreferences(
        studentCode: studentCode,
        preferences: updatedGlobalPrefs,
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
}
