import 'dart:async';
import 'package:logger/logger.dart';
import 'package:sigapp/auth/application/usecases/get_stored_credentials_usecase.dart';
import 'package:sigapp/auth/application/usecases/keep_session_alive_usecase.dart';
import 'package:sigapp/auth/application/usecases/authenticate_usecase.dart';
import 'package:sigapp/auth/domain/exceptions/session_exception.dart';
import 'package:sigapp/core/infrastructure/http/network_utils.dart';

/// Maneja el refresco de la sesión con estrategias de reintentos
class AuthTokenRefreshManager {
  static const int _maxRetries = 3;

  final KeepSessionAliveUsecase _keepSessionAliveUsecase;
  final AuthenticateUsecase _signInUseCase;
  final GetStoredCredentialsUseCase _getStoredCredentialsUseCase;
  final Logger _logger;

  Completer<void>? _refreshSessionCompleter;

  AuthTokenRefreshManager(
    this._keepSessionAliveUsecase,
    this._signInUseCase,
    this._getStoredCredentialsUseCase,
    this._logger,
  );

  /// Refresca la sesión con reintentos y backoff exponencial
  /// Retorna un [RefreshResult] que indica el resultado de la operación
  Future<RefreshResult> refreshSession() async {
    final storedCredentials = _getStoredCredentialsUseCase.execute();
    if (!storedCredentials.hasCredentials) {
      return RefreshResult.noCredentials();
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
            originalError: 'SignIn returned false',
          );
        }

        _logger.i('[AUTH] Session refreshed successfully on attempt $attempt');

        if (!_refreshSessionCompleter!.isCompleted) {
          _refreshSessionCompleter!.complete();
        }
        _refreshSessionCompleter = null;
        return RefreshResult.success();
      } catch (e, s) {
        lastError = e;
        lastStack = s;

        _logger.e(
          '[AUTH] Error refreshing session (attempt $attempt/$_maxRetries): $e',
          error: e,
          stackTrace: s,
        );

        // Solo reintentar si el error es específicamente un error de red
        if (isNetworkError(e)) {
          if (attempt < _maxRetries) {
            final waitTime = Duration(seconds: attempt * 2);
            _logger.i(
              '[AUTH] Network error detected - retrying in ${waitTime.inSeconds} seconds...',
            );
            await Future.delayed(waitTime);
          }
        } else {
          // Para cualquier otro tipo de error (incluyendo PendingSurveySessionException),
          // salir del loop de reintentos inmediatamente
          _logger.w(
            '[AUTH] Non-network error detected (${e.runtimeType}) - skipping session refresh retries',
            error: e,
          );
          break; // Salir del loop de reintentos inmediatamente
        }
      }
    }

    _logger.e(
      '[AUTH] All refresh attempts failed',
      error: lastError,
      stackTrace: lastStack,
    );

    if (!_refreshSessionCompleter!.isCompleted) {
      _refreshSessionCompleter!.completeError(lastError);
    }
    _refreshSessionCompleter = null;

    // Determinar el tipo de resultado basado en el error
    if (isNetworkError(lastError)) {
      _logger.w(
        '[AUTH] Network error detected, session will not be closed to allow offline mode',
      );
      return RefreshResult.networkError(lastError, lastStack);
    } else {
      return RefreshResult.unknownError(lastError, lastStack);
    }
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

/// Resultado del refresco de sesión
class RefreshResult {
  final RefreshStatus status;
  final Object? error;
  final StackTrace? stackTrace;

  RefreshResult._(this.status, this.error, this.stackTrace);

  factory RefreshResult.success() =>
      RefreshResult._(RefreshStatus.success, null, null);
  factory RefreshResult.noCredentials() =>
      RefreshResult._(RefreshStatus.noCredentials, null, null);
  factory RefreshResult.networkError(Object error, StackTrace? stackTrace) =>
      RefreshResult._(RefreshStatus.networkError, error, stackTrace);
  factory RefreshResult.unknownError(Object error, StackTrace? stackTrace) =>
      RefreshResult._(RefreshStatus.unknownError, error, stackTrace);

  bool get isSuccess => status == RefreshStatus.success;
  bool get isNetworkError => status == RefreshStatus.networkError;
  bool get isUnknownError => status == RefreshStatus.unknownError;
  bool get hasNoCredentials => status == RefreshStatus.noCredentials;
}

/// Estados posibles del resultado de refresco
enum RefreshStatus { success, noCredentials, networkError, unknownError }
