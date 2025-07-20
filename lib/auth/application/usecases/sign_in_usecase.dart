import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/auth/application/services/api_gateway_auth_service.dart';
import 'package:sigapp/auth/application/usecases/authenticate_usecase.dart';
import 'package:sigapp/auth/domain/repositories/shared_preferences_auth_repository.dart';
import 'package:sigapp/auth/domain/services/navigation_service.dart';
import 'package:sigapp/student/application/usecases/get_academic_info_usecase.dart';
import 'package:sigapp/student/domain/repositories/student_repository.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:logger/logger.dart';

@injectable
class SignInUseCase {
  final SharedPreferencesAuthRepository _sharedPreferencesAuthRepository;
  final ApiGatewayAuthService _supabaseAuthService;
  final NavigationService _navigationService;
  final GetAcademicInfoUseCase _getAcademicInfoUseCase;
  final StudentSessionRepository _studentSessionRepository;
  final StudentRepository _studentRepository;
  final Logger _logger;
  final AuthenticateUsecase _directSignInUse;

  SignInUseCase(
    this._sharedPreferencesAuthRepository,
    this._supabaseAuthService,
    this._navigationService,
    this._getAcademicInfoUseCase,
    this._studentSessionRepository,
    this._studentRepository,
    this._logger,
    this._directSignInUse,
  );

  Future<bool> execute(String username, String password) async {
    // Clear cookies from authentication services uhmmmm...
    // await _authRepository.disposeCookies();
    // await _regevaRepository.disposeCookies();

    final success = await _directSignInUse.execute(username, password);
    if (!success) return false;

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

    await _supabaseSignInAndSignUp(username, password);
    _navigationService.refreshNavigation();

    return true;
  }

  Future<void> _supabaseSignInAndSignUp(
    String username,
    String password,
  ) async {
    try {
      final userExists = await _supabaseAuthService.userExists(
        studentCode: username,
      );

      if (userExists) {
        // Usuario existe - intentar login directo
        try {
          await _supabaseAuthService.loginUser(
            password: password,
            studentCode: username,
          );
          _logger.i('[APPLICATION] Login exitoso en Supabase.');
        } catch (e) {
          // Login falló - actualizar contraseña e intentar de nuevo
          _logger.w(
            '[APPLICATION] Actualizando contraseña y reintentando login.',
          );
          await _supabaseAuthService.updateUserPassword(
            newPassword: password,
            studentCode: username,
          );
          await _supabaseAuthService.loginUser(
            password: password,
            studentCode: username,
          );
          _logger.i('[APPLICATION] Contraseña actualizada y login exitoso.');
        }
      } else {
        // Usuario no existe - registrar y hacer login
        _logger.i('[APPLICATION] Registrando nuevo usuario.');
        await _supabaseAuthService.registerUser(
          password: password,
          studentCode: username,
        );
        await _supabaseAuthService.loginUser(
          password: password,
          studentCode: username,
        );
        _logger.i('[APPLICATION] Usuario registrado y login exitoso.');
      }
    } catch (e, s) {
      _logger.e(
        '[APPLICATION] Error en autenticación Supabase: $username',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
