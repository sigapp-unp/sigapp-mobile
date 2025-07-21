import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/application/usecases/get_all_hidden_courses_preferences_usecase.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/value_objects/preference_keys.dart';

@injectable
class SetCourseVisibilityPreferencesUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;
  final GetAllHiddenCoursesPreferencesUseCase
  _getAllHiddenCoursesPreferencesUseCase;
  final Logger _logger;

  const SetCourseVisibilityPreferencesUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
    this._getAllHiddenCoursesPreferencesUseCase,
    this._logger,
  );

  /// Sets the visibility state for a specific schedule event
  /// [isVisible] - true to show the event, false to hide it
  Future<void> execute(String eventId, bool isVisible) async {
    try {
      final studentCode = await _getStudentCode();

      if (isVisible) {
        // Remove from hidden list to make it visible
        await _removeHiddenScheduleEvent(
          studentCode: studentCode,
          eventId: eventId,
        );
      } else {
        // Add to hidden list to hide it
        await _addHiddenScheduleEvent(
          studentCode: studentCode,
          eventId: eventId,
        );
      }

      _logger.d(
        '[USE_CASE] Schedule event visibility updated: $eventId = ${isVisible ? "visible" : "hidden"}',
      );
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error setting schedule event visibility',
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

  Future<void> _addHiddenScheduleEvent({
    required String studentCode,
    required String eventId,
  }) async {
    try {
      final currentList =
          await _getAllHiddenCoursesPreferencesUseCase.execute();

      if (!currentList.contains(eventId)) {
        final updatedList = [...currentList, eventId];
        await _preferencesRepository.setPreference(
          studentCode: studentCode,
          path: PreferenceKeys.scheduleHiddenEvents,
          value: updatedList,
        );
      }
    } catch (e) {
      _logger.e('Error adding hidden schedule event: $e');
      rethrow;
    }
  }

  Future<void> _removeHiddenScheduleEvent({
    required String studentCode,
    required String eventId,
  }) async {
    try {
      final currentList =
          await _getAllHiddenCoursesPreferencesUseCase.execute();

      if (currentList.contains(eventId)) {
        final updatedList = currentList.where((id) => id != eventId).toList();
        await _preferencesRepository.setPreference(
          studentCode: studentCode,
          path: PreferenceKeys.scheduleHiddenEvents,
          value: updatedList,
        );
      }
    } catch (e) {
      _logger.e('Error removing hidden schedule event: $e');
      rethrow;
    }
  }
}
