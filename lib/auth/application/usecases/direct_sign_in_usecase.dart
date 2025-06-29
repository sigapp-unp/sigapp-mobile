import 'package:injectable/injectable.dart';
import 'package:sigapp/auth/domain/repositories/auth_repository.dart';
import 'package:sigapp/auth/domain/services/session_lifecycle_service.dart';

@injectable
// TODO: RENAME
class DirectSignInUsecase {
  final AuthRepository _authRepository;
  final SessionLifecycleService _sessionLifecycleService;

  DirectSignInUsecase(this._authRepository, this._sessionLifecycleService);

  Future<bool> execute(String username, String password) async {
    final response = await _authRepository.login(username, password);
    return _sessionLifecycleService.checkLoginResult(
      headers: response.headers,
      statusCode: response.statusCode,
    );
  }
}
