import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/shared/application/usecases/base_get_student_code_usecase.dart';

@injectable
class SetCourseViewModePreferencesUseCase extends BaseGetStudentCodeUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final Logger _logger;

  SetCourseViewModePreferencesUseCase(
    this._preferencesRepository,
    this._logger,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  /// Sets the view mode for course prerequisite chains
  Future<void> execute(CourseViewMode mode) async {
    try {
      final studentCode = await getStudentCode();

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
}
