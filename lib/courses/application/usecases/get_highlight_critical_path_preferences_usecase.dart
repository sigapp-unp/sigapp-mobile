import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/shared/application/usecases/base_get_student_code_usecase.dart';

@injectable
class GetHighlightCriticalPathUseCase extends BaseGetStudentCodeUseCase {
  final UserPreferencesRepository _preferencesRepository;
  final Logger _logger;

  GetHighlightCriticalPathUseCase(
    this._preferencesRepository,
    StudentSessionRepository studentSessionRepository,
    this._logger,
  ) : super(studentSessionRepository);

  /// Gets whether critical path highlighting is enabled
  Future<bool> execute() async {
    try {
      final studentCode = await getStudentCode();
      final globalPreferences = await _preferencesRepository
          .getGlobalPreferences(studentCode: studentCode);
      return globalPreferences.courseChain.highlightCriticalPath;
    } catch (e, s) {
      _logger.e(
        '[USE_CASE] Error getting highlight critical path preference, using default',
        error: e,
        stackTrace: s,
      );
      return false; // Default fallback
    }
  }
}
