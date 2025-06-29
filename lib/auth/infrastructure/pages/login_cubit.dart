import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/auth/application/usecases/get_stored_credentials_usecase.dart';
import 'package:sigapp/auth/application/usecases/sign_in_usecase.dart';
import 'package:sigapp/auth/domain/exceptions/session_exception.dart';
import 'package:sigapp/auth/domain/value-objects/stored_credentials.dart';

part 'login_cubit.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    required String username,
    required String password,
    required LoginStatus status,
  }) = _LoginState;
}

@freezed
sealed class LoginStatus with _$LoginStatus {
  const factory LoginStatus.initial() = LoginInitial;
  const factory LoginStatus.loading() = LoginLoading;
  const factory LoginStatus.success() = LoginSuccess;
  // TODO: must be `dynamic error`
  const factory LoginStatus.error(String message) = LoginError;
}

@injectable
class LoginCubit extends Cubit<LoginState> {
  final GetStoredCredentialsUseCase _getStoredCredentials;
  final SignInUseCase _signInUseCase;
  final Logger _logger;

  LoginCubit(this._getStoredCredentials, this._signInUseCase, this._logger)
    : super(
        const LoginState(
          username: '',
          password: '',
          status: LoginStatus.initial(),
        ),
      );

  Future<void> setup() async {
    final StoredCredentials(
      username: storedUsername,
      password: storedPassword,
    ) = _getStoredCredentials.execute();

    if (storedUsername != null) {
      emit(state.copyWith(username: storedUsername));
    }

    if (storedUsername != null && storedPassword != null) {
      emit(state.copyWith(username: storedUsername, password: storedPassword));
      login(storedUsername, storedPassword);
    } else {
      emit(state.copyWith(status: const LoginStatus.initial()));
    }
  }

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: const LoginStatus.loading()));
    try {
      final successAuth = await _signInUseCase.execute(username, password);
      if (!successAuth) {
        emit(
          state.copyWith(
            status: const LoginStatus.error('Credenciales inválidos'),
          ),
        );
        return;
      }
      emit(state.copyWith(status: const LoginStatus.success()));
    } catch (e, s) {
      _logger.e('[UI] Login failed: $e', error: e, stackTrace: s);
      var message = '';
      if (e is DioException && e.error is SessionException) {
        message = (e.error as SessionException).message;
      } else {
        message = e.toString();
      }
      emit(state.copyWith(status: LoginStatus.error(message)));
    }
  }
}
