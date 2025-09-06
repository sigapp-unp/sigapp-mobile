import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/shared/application/usecases/base_get_student_code_usecase.dart';

@injectable
class SetCourseVisibilityPreferencesUseCase extends BaseGetStudentCodeUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final Logger _logger;

  SetCourseVisibilityPreferencesUseCase(
    this._preferencesRepository,
    this._logger,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  /// Sets the visibility state for a specific schedule event in a semester
  /// [isVisible] - true to show the event, false to hide it
  /// [semesterId] - the semester context for this event
  Future<void> execute({
    required String eventId,
    required bool isVisible,
    required String semesterId,
  }) async {
    try {
      _logger.d(
        '[USE_CASE] set visibility request -> semester:$semesterId event:$eventId isVisible:$isVisible',
      );
      final studentCode = await getStudentCode();

      if (isVisible) {
        // Remove from hidden list to make it visible
        await _preferencesRepository.removeSemesterHiddenScheduleEvent(
          studentCode: studentCode,
          semesterId: semesterId,
          eventId: eventId,
        );
      } else {
        // Add to hidden list to hide it
        await _preferencesRepository.addSemesterHiddenScheduleEvent(
          studentCode: studentCode,
          semesterId: semesterId,
          eventId: eventId,
        );
      }

      _logger.d(
        '[USE_CASE] Schedule event visibility updated for semester $semesterId: $eventId = ${isVisible ? "visible" : "hidden"}',
      );
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error setting schedule event visibility for semester $semesterId',
        error: e,
        stackTrace: s,
      );
      rethrow; // Let the UI handle the error
    }
  }
}
