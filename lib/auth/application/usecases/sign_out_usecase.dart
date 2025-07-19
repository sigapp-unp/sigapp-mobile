import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/auth/application/services/api_gateway_auth_service.dart';
import 'package:sigapp/auth/domain/exceptions/session_exception.dart';
import 'package:sigapp/auth/domain/repositories/auth_repository.dart';
import 'package:sigapp/auth/domain/repositories/shared_preferences_auth_repository.dart';
import 'package:sigapp/auth/domain/services/navigation_service.dart';
import 'package:sigapp/auth/domain/services/toast_service.dart';
import 'package:sigapp/shared/domain/service/progress_indicator_service.dart';
import 'package:sigapp/courses/domain/repositories/regeva_repository.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:sigapp/student/domain/repositories/student_repository.dart';

@injectable
class SignOutUseCase {
  final SharedPreferencesAuthRepository _sharedPreferencesAuthRepository;
  final NavigationService _navigationService;
  final ToastService _toastService;
  final AuthRepository _authRepository;
  final RegevaRepository _regevaRepository;
  final ProgressIndicatorService _progressIndicatorService;
  final ApiGatewayAuthService _apiGatewayAuthService;
  final StudentSessionRepository _studentSessionRepository;
  final StudentRepository _studentRepository;
  final Logger _logger;

  SignOutUseCase(
    this._sharedPreferencesAuthRepository,
    this._navigationService,
    this._authRepository,
    this._regevaRepository,
    this._progressIndicatorService,
    this._apiGatewayAuthService,
    this._toastService,
    this._studentSessionRepository,
    this._studentRepository,
    this._logger,
  );

  Future<void> execute([SessionException? technicalReason]) async {
    // Registramos el motivo técnico del cierre de sesión para diagnóstico
    _logger.i(
      '[AUTH] Executing SignOutUseCase. Technical reason: ${technicalReason ?? "Not specified"}',
    );

    await _progressIndicatorService.show();

    // Obtener el mensaje amigable y si debería tratarse como alerta de error
    final userMessage = technicalReason?.message ?? 'Has cerrado sesión';
    final shouldDisplayAsError = switch (technicalReason) {
      null => false,
      RefreshSessionException() => false,
      AuthenticationSessionException() => true,
      StudentInfoSessionException() => true,
      PendingSurveySessionException() => false,
      UnknownSessionException() => true,
    };

    try {
      // required for refreshing navigation
      await _sharedPreferencesAuthRepository.removePassword();

      // clear cookies :p
      await _authRepository.disposeCookies();
      await _regevaRepository.disposeCookies();
    } catch (e, s) {
      _logger.e('[AUTH] Error during sign out: $e', error: e, stackTrace: s);

      await _progressIndicatorService.hide();
      rethrow;
    }

    try {
      await _apiGatewayAuthService.logoutUser();
    } catch (e, s) {
      _logger.w(
        '[AUTH] Error logging out from Supabase: $e (continuing anyway)',
        error: e,
        stackTrace: s,
      );
      // No relanzamos esta excepción para no interrumpir el flujo
    }

    await _progressIndicatorService.hide();

    // Refresh navigation and show message
    _navigationService.refreshNavigation();
    _toastService.show(userMessage, isError: shouldDisplayAsError);

    // Clear ALL session-related caches to prevent data leakage between users
    _logger.d('[AUTH] Clearing all user-related caches');
    _studentSessionRepository.clearCache();
    _studentRepository.clearCache();
  }
}
