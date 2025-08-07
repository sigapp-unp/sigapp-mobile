import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';

@injectable
class GetCourseViewModeUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final StudentSessionRepository _studentSessionRepository;
  final Logger _logger;

  const GetCourseViewModeUseCase(
    this._preferencesRepository,
    this._studentSessionRepository,
    this._logger,
  );

  /// Gets the current view mode for course prerequisite chains
  Future<CourseViewMode> execute() async {
    try {
      final studentCode = await _getStudentCode();
      final globalPreferences = await _preferencesRepository
          .getGlobalPreferences(studentCode: studentCode);
      return globalPreferences.courseChain.viewMode;
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error getting course view mode, using default',
        error: e,
        stackTrace: s,
      );
      return CourseViewMode.tree; // Default fallback
    }
  }

  Future<String> _getStudentCode() async {
    final info = await _studentSessionRepository.getStudentSessionInfo();
    return info.studentCode;
  }
}
