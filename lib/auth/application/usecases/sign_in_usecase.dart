import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/auth/application/services/firebase_auth_service.dart';
import 'package:sigapp/auth/application/usecases/siga_authentication_usecase.dart';
import 'package:sigapp/auth/domain/repositories/shared_preferences_auth_repository.dart';
import 'package:sigapp/auth/domain/services/navigation_service.dart';
import 'package:sigapp/shared/application/usecases/get_academic_info_usecase.dart';
import 'package:sigapp/student/domain/repositories/student_repository.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:logger/logger.dart';

@injectable
class SignInUseCase {
  final SharedPreferencesAuthRepository _sharedPreferencesAuthRepository;
  final FirebaseAuthService _firebaseAuthService;
  final NavigationService _navigationService;
  final GetAcademicInfoUseCase _getAcademicInfoUseCase;
  final StudentSessionRepository _studentSessionRepository;
  final StudentRepository _studentRepository;
  final Logger _logger;
  final SigaAuthenticationUsecase _sigaAuthenticationUsecase;

  SignInUseCase(
    this._sharedPreferencesAuthRepository,
    this._firebaseAuthService,
    this._navigationService,
    this._getAcademicInfoUseCase,
    this._studentSessionRepository,
    this._studentRepository,
    this._logger,
    this._sigaAuthenticationUsecase,
  );

  Future<AuthenticationResult> execute(String username, String password) async {
    // Clear cookies from authentication services uhmmmm...
    // await _authRepository.disposeCookies();
    // await _regevaRepository.disposeCookies();

    final sigaAuthenticationResult = await _sigaAuthenticationUsecase.execute(
      username,
      password,
    );
    if (!sigaAuthenticationResult.success) return sigaAuthenticationResult;

    await _sharedPreferencesAuthRepository.saveCredentials(username, password);

    // Clear any cached info before validating new session to ensure fresh data
    _logger.d(
      '[AUTH] Clearing all caches and cookies before validating new session',
    );

    // Clear repository caches
    _studentSessionRepository.clearCache();
    _studentRepository.clearCache();
    _getAcademicInfoUseCase.clearCache();

    // Validate if student user is ready to use the app
    // This could throw an exception if the student is newly registered
    try {
      await _getAcademicInfoUseCase.execute();
    } on DioException catch (e) {
      // Otros tipos de SessionException se manejan como errores reales
      _logger.e(
        '[APPLICATION] Error de sesión al obtener información del estudiante.',
        error: e,
      );
      rethrow;
    } catch (e, s) {
      _logger.e(
        '[APPLICATION] Error al obtener la información de la sesión del estudiante.',
        error: e,
        stackTrace: s,
      );
      throw Exception('Ocurrió un error al obtener tu información: $e');
    }

    await _firebaseAuthService.signInWithStudentCode(username, password);
    _navigationService.refreshNavigation();

    return sigaAuthenticationResult;
  }
}
