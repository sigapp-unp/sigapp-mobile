import 'dart:async';
import 'package:logger/logger.dart';
import 'package:sigapp/auth/application/usecases/get_stored_credentials_usecase.dart';
import 'package:sigapp/auth/application/usecases/keep_session_alive_usecase.dart';
import 'package:sigapp/auth/application/usecases/sign_in_usecase.dart';
import 'package:sigapp/auth/application/usecases/sign_out_usecase.dart';
import 'package:sigapp/auth/domain/exceptions/session_exception.dart';
import 'package:sigapp/auth/domain/services/toast_service.dart';
import 'dart:io';
import 'package:dio/dio.dart';

/// Maneja el refresco de la sesión con estrategias de reintentos
class AuthTokenRefreshManager {
  static const int _maxRetries = 3;

  final KeepSessionAliveUsecase _keepSessionAliveUsecase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetStoredCredentialsUseCase _getStoredCredentialsUseCase;
  final ToastService _toastService;
  final Logger _logger;

  Completer<void>? _refreshSessionCompleter;

  AuthTokenRefreshManager(
    this._keepSessionAliveUsecase,
    this._signInUseCase,
    this._signOutUseCase,
    this._getStoredCredentialsUseCase,
    this._toastService,
    this._logger,
  );

  /// Refresca la sesión con reintentos y backoff exponencial
  Future<void> refreshSession() async {
    final storedCredentials = _getStoredCredentialsUseCase.execute();
    if (!storedCredentials.hasCredentials) {
      return;
    }

    _refreshSessionCompleter = Completer<void>();

    dynamic lastError;
    StackTrace? lastStack;

    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        _logger.i('[AUTH] Attempt $attempt/$_maxRetries of session refresh');

        await _keepSessionAliveUsecase.execute();

        final successfulSignIn = await _signInUseCase.execute(
          storedCredentials.username!,
          storedCredentials.password!,
        );

        if (!successfulSignIn) {
          throw SessionException.refreshError(
            message: 'Error refreshing session: Sign in returned false',
            originalError: 'SignIn returned false',
          );
        }

        _logger.i('[AUTH] Session refreshed successfully on attempt $attempt');

        _refreshSessionCompleter!.complete();
        return;
      } catch (e, s) {
        lastError = e;
        lastStack = s;

        _logger.e(
          '[AUTH] Error refreshing session (attempt $attempt/$_maxRetries): $e',
          error: e,
          stackTrace: s,
        );

        if (attempt < _maxRetries) {
          final waitTime = Duration(seconds: attempt * 2);
          _logger.i('[AUTH] Retrying in ${waitTime.inSeconds} seconds...');
          await Future.delayed(waitTime);
        }
      }
    }

    _logger.e(
      '[AUTH] All refresh attempts failed',
      error: lastError,
      stackTrace: lastStack,
    );

    _refreshSessionCompleter!.completeError(lastError);

    // Si el error es de red, NO cerrar sesión
    if (_isNetworkError(lastError)) {
      _logger.w(
        '[AUTH] Network error detected, session will not be closed to allow offline mode',
      );
      _toastService.show(
        'Connection problems. Offline mode active',
        isError: false,
      );
    } else {
      final sessionError =
          lastError is SessionException
              ? lastError
              : SessionException.refreshError(
                message: 'Error en múltiples intentos de refresco de sesión',
                originalError: lastError,
              );
      await _signOutUseCase.execute(sessionError);
    }
    _refreshSessionCompleter = null;
  }

  /// Detecta si un error es un problema de red/conectividad
  bool _isNetworkError(Object error) {
    try {
      if (error is DioException) {
        return error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.connectionError ||
            (error.type == DioExceptionType.unknown &&
                (error.error is SocketException ||
                    (error.message?.contains('Failed host lookup') == true)));
      }
    } catch (_) {}
    return false;
  }

  /// Agrega un log al inicio de waitForOngoingRefresh para mayor visibilidad
  Future<void> waitForOngoingRefresh() async {
    if (_refreshSessionCompleter != null) {
      _logger.i('[AUTH] Waiting for ongoing session refresh to complete');
      await _refreshSessionCompleter!.future;
    }
  }

  bool get isRefreshing => _refreshSessionCompleter != null;

  /// Reinicia el estado del refresco para evitar inconsistencias
  void reset() {
    _logger.i('[AUTH] Resetting AuthTokenRefreshManager state');
    _refreshSessionCompleter = null;
  }
}
