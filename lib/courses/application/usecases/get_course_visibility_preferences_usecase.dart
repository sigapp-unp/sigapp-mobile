import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/value_objects/preference_keys.dart';

@injectable
class GetCourseVisibilityPreferencesUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;

  const GetCourseVisibilityPreferencesUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
  );

  /// Gets the visibility state for a specific course event
  /// Returns true if course should be visible, false if hidden
  Future<bool> call(String eventId) async {
    final studentCode = await _getStudentCode();
    final isHidden = await _preferencesRepository.getPreference(
      studentCode: studentCode,
      path: PreferenceKeys.courseVisibilityEvent(eventId),
    );

    // Default: visible (false means not hidden)
    return !(isHidden is bool ? isHidden : false);
  }

  Future<String> _getStudentCode() async {
    final info = await _studentSessionRepository.getStudentSessionInfo();
    return info.studentCode;
  }
}
