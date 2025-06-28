import 'package:injectable/injectable.dart';
import 'package:sigapp/auth/domain/repositories/shared_preferences_auth_repository.dart';
import 'package:sigapp/auth/domain/value-objects/stored_credentials.dart';

@injectable
class GetStoredCredentialsUseCase {
  final SharedPreferencesAuthRepository _sharedPreferencesAuthRepository;

  GetStoredCredentialsUseCase(this._sharedPreferencesAuthRepository);

  StoredCredentials execute() {
    final username = _sharedPreferencesAuthRepository.getUsername();
    final password = _sharedPreferencesAuthRepository.getPassword();
    return StoredCredentials(username: username, password: password);
  }
}
