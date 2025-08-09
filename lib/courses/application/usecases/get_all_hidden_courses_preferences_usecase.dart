import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/shared/application/usecases/base_get_student_code_usecase.dart';

@injectable
class GetAllHiddenCoursesPreferencesUseCase extends BaseGetStudentCodeUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final Logger _logger;

  GetAllHiddenCoursesPreferencesUseCase(
    this._preferencesRepository,
    this._logger,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  /// Gets a list of all hidden schedule event IDs for a specific semester
  Future<List<String>> execute({required String semesterId}) async {
    try {
      final studentCode = await getStudentCode();
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
}
