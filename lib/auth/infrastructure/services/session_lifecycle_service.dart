import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/auth/domain/exceptions/session_exception.dart';
import 'package:sigapp/core/infrastructure/http/network_utils.dart';
import 'package:sigapp/core/infrastructure/http/siga_client.dart';
import 'package:sigapp/auth/domain/services/session_lifecycle_service.dart';
import 'package:sigapp/auth/domain/value-objects/api_path_and_method.dart';
import 'package:logger/logger.dart';

@Singleton(as: SessionLifecycleService)
class SessionLifecycleServiceImpl implements SessionLifecycleService {
  final SigaClient _sigaClient;
  final Logger _logger;

  // Renombrando para mayor claridad en su propósito
  bool _isHttpInterceptorRefreshInProgress = false;

  SessionLifecycleServiceImpl(this._sigaClient, this._logger);

  /// Sets up the logic to refresh the session before requests (unless excluded)
  /// and to detect session expiration after responses. Calls [onSessionExpired]
  /// if the session is determined to be expired.
  @override
  void configureSessionInterceptors({
    required Future<void> Function() awaitOngoingSessionRefresh,
    // Actualizando el nombre del parámetro para que coincida con la interfaz
    required List<ApiPathAndMethod> endpointsExcludedFromPreRequestRefresh,
    required void Function(SessionException? technicalReason) onSessionExpired,
  }) {
    _sigaClient.http.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_isHttpInterceptorRefreshInProgress) {
            _logger.d('[INFRASTRUCTURE] Skipping recursive session refresh');
            _updateCookieHeader(options);
            handler.next(options);
            return;
          }

          // Skip session refresh if this request is in the excluded list.
          if (_isExcludedRequest(
            options,
            endpointsExcludedFromPreRequestRefresh,
          )) {
            _logger.d(
              '[INFRASTRUCTURE] Request ${options.method} ${options.path} is excluded from session refresh.',
            );
            handler.next(options);
            return;
          }

          // Refresh the session before the request.
          _logger.d(
            '[INFRASTRUCTURE] Refreshing session before making the request...',
          );
          try {
            _isHttpInterceptorRefreshInProgress = true;
            await awaitOngoingSessionRefresh();
            _logger.d('[INFRASTRUCTURE] Session refreshed successfully.');
          } catch (e) {
            // Si falla el refresco de sesión, maneja el error pero permite que la solicitud continue
            _logger.w(
              '[INFRASTRUCTURE] Error refrescando sesión antes de solicitud: $e',
              error: e,
            );
            // No relanzamos la excepción para permitir que la solicitud continúe
          } finally {
            _isHttpInterceptorRefreshInProgress = false;
          }

          // Update cookies in the request headers if needed.
          _updateCookieHeader(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          try {
            handler.next(
              _handleResponse(response, endpointsExcludedFromPreRequestRefresh),
            );
          } on SessionException catch (e) {
            if (e is AuthenticationSessionException ||
                e is PendingSurveySessionException) {
              onSessionExpired(e);
            }
            handler.reject(
              DioException(requestOptions: response.requestOptions, error: e),
            );
          } catch (e) {
            handler.next(response);
          }
        },
        onError: (error, handler) {
          // Detectar error de red y NO cerrar sesión ni lanzar SessionException
          if (isNetworkError(error)) {
            _logger.d(
              '[INFRASTRUCTURE] Error de red detectado en interceptor, no se cierra sesión',
              error: error,
            );
            handler.next(error);
            return;
          }

          // Si hay un error de respuesta, manejarlo
          if (error.response == null) {
            handler.next(error);
            return;
          }

          // Si un response , manejarlo y evaluar la sesión
          try {
            _handleResponse(
              error.response!,
              endpointsExcludedFromPreRequestRefresh,
            );
            handler.next(error);
          } on SessionException catch (e) {
            if (e is AuthenticationSessionException ||
                e is PendingSurveySessionException) {
              onSessionExpired(e);
            }
            handler.reject(
              DioException(requestOptions: error.requestOptions, error: e),
            );
          } catch (e) {
            handler.next(error);
          }
        },
      ),
    );
  }

  bool _evaluateSurveyRedirection(String locationUrl) {
    return locationUrl.contains(SigaClient.survey1RedirectionLocation) ||
        locationUrl.contains(SigaClient.survey2RedirectionLocation);
  }

  // ----------------
  // Private methods
  // ----------------

  Response _handleResponse(
    Response response,
    List<ApiPathAndMethod> excludedRequests,
  ) {
    // Skip session expiration check if the response is from an excluded request.
    if (_isExcludedRequest(response.requestOptions, excludedRequests)) {
      _logger.d(
        '[INFRASTRUCTURE] Response from ${response.requestOptions.method} ${response.requestOptions.path} is excluded from session expiration evaluation.',
      );
      return response;
    }

    // throw SessionException.pendingSurveyError(originalError: 'DEBUGGING');

    // Evaluate redirection and session expiration
    if (response.statusCode == null) return response;
    final statusCode = response.statusCode!;
    final headers = response.headers.map;
    final locationHeaderValue = headers['location'] ?? [];
    if (statusCode != 302 && locationHeaderValue.isEmpty) {
      // No hay redirección 302 o header location, no se evalúa expiración
      return response;
    }

    final locationUrl = locationHeaderValue.first;

    // Verificar si es una redirección de cierre de sesión
    if (_evaluateSignOutRedirection(locationUrl)) {
      _logger.w(
        '[INFRASTRUCTURE] SESIÓN EXPIRADA: Detectada redirección de cierre se sesión: $locationUrl',
      );
      throw SessionException.authenticationError(
        originalError: 'Redirección a forceSignOut: $locationUrl',
      );
    }

    // Verificar si es una redirección a encuesta pendiente
    if (_evaluateSurveyRedirection(locationUrl)) {
      _logger.w(
        '[INFRASTRUCTURE] ENCUESTA PENDIENTE: Detectada redirección a encuesta: $locationUrl',
      );
      throw SessionException.pendingSurveyError(
        originalError: 'Redirección a encuesta: $locationUrl',
      );
    }

    // Si llegamos aquí, es una redirección 302 a otra página (no expiró la sesión)
    return response;
  }

  bool _evaluateSignOutRedirection(String locationUrl) {
    return locationUrl.contains(SigaClient.forceSignOutRedirectionLocation);
  }

  bool _evaluateSignInRedirection(String locationUrl) {
    return locationUrl.contains(SigaClient.successSignInRedirectionLocation);
  }

  /// Checks if the request is in the list of excluded API paths and methods.
  bool _isExcludedRequest(
    RequestOptions options,
    List<ApiPathAndMethod> excludedRequests,
  ) {
    return excludedRequests.any((excludedRequest) {
      return excludedRequest ==
          ApiPathAndMethod(ApiMethod.fromString(options.method), options.path);
    });
  }

  /// Updates the "Cookie" header with the latest session cookies from the CookieManager.
  void _updateCookieHeader(RequestOptions options) {
    final cookies = _sigaClient.cookieManager
        .getCookies(SigaClient.host)
        .join('; ');
    final originalCookieHeader = options.headers['Cookie'];
    if (originalCookieHeader != cookies) {
      _logger.d(
        '[INFRASTRUCTURE] Cookie header updated from "$originalCookieHeader" to "$cookies".',
      );
      options.headers['Cookie'] = cookies;
    }
  }

  @override
  bool checkLoginResult({
    required Map<String, List<String>> headers,
    required int statusCode,
  }) {
    final locationHeaderValue = headers['location'] ?? [];
    if (statusCode == 200 && locationHeaderValue.isEmpty) {
      _logger.d('[INFRASTRUCTURE] Failed login');
      return false;
    }
    if (_evaluateSignInRedirection(locationHeaderValue.first)) {
      _logger.i('[INFRASTRUCTURE] Successful login');
      return true;
    }

    if (statusCode == 302) {
      throw SessionException.authenticationError(
        originalError:
            'Status code: $statusCode, Location: $locationHeaderValue',
      );
    }

    throw SessionException.authenticationError(
      originalError: 'Status code: $statusCode, Location: $locationHeaderValue',
    );
  }
}
