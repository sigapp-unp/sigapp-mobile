import 'package:injectable/injectable.dart';
import 'package:sigapp/auth/domain/repositories/auth_repository.dart';
import 'package:sigapp/auth/domain/services/session_lifecycle_service.dart';

class AuthenticationResult {
  final bool success;
  final String? messageLevel1;
  final String? messageLevel2;
  final String? messageLevel3;

  AuthenticationResult(
    this.success,
    this.messageLevel1,
    this.messageLevel2,
    this.messageLevel3,
  );
}

@injectable
class SigaAuthenticationUsecase {
  final AuthRepository _authRepository;
  final SessionLifecycleService _sessionLifecycleService;

  SigaAuthenticationUsecase(
    this._authRepository,
    this._sessionLifecycleService,
  );

  Future<AuthenticationResult> execute(String username, String password) async {
    final response = await _authRepository.login(username, password);
    final success = _sessionLifecycleService.checkLoginResult(
      headers: response.headers,
      statusCode: response.statusCode,
    );
    return AuthenticationResult(
      success,
      response.messageLevel1,
      response.messageLevel2,
      response.messageLevel3,
    );
  }
}
