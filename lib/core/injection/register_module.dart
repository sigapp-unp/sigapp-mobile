import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigapp/core/infrastructure/logging/app_logger.dart';
import 'package:sigapp/core/infrastructure/ui/router.dart';
import 'package:sigapp/auth/application/usecases/get_stored_credentials_usecase.dart';

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @singleton
  GoRouter router(GetStoredCredentialsUseCase getStoredCredentialsUseCase) =>
      RouterBuilder.build(getStoredCredentialsUseCase);

  @singleton
  Logger logger() => createLogger();
}
