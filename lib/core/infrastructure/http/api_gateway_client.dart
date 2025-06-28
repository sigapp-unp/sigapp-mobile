import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client/api_logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client/token_refresher_manager.dart';
import 'package:logger/logger.dart';

/// Main client for API Gateway communication
@singleton
class ApiGatewayClient {
  late final String _url;
  late final Dio http;
  final TokenManager tokenManager;
  final ApiLogger logger;
  final Logger _logger;
  late final TokenRefreshManager refreshManager;

  ApiGatewayClient(this._logger)
    : tokenManager = TokenManager(),
      logger = ApiLogger(_logger) {
    http = Dio();

    final baseUrl = dotenv.env['API_GATEWAY_URL'];
    if (baseUrl == null) {
      throw Exception('API_GATEWAY_URL not found in .env file');
    }
    _url = baseUrl;

    // Configure base options
    http.options.baseUrl = _url;
    http.options.connectTimeout = const Duration(seconds: 10);
    http.options.receiveTimeout = const Duration(seconds: 10);
    http.options.headers['Content-Type'] = 'application/json';
    // http.options.headers['X-Upstream'] = 'supabase';

    refreshManager = TokenRefreshManager(tokenManager, _url, _logger);

    // Add interceptors
    http.interceptors.add(_createAuthInterceptor());
    http.interceptors.add(_createErrorInterceptor());
    http.interceptors.add(_createLoggingInterceptor());
  }

  // Auth token proxy methods
  Future<void> setAccessToken(String token) =>
      tokenManager.setAccessToken(token);
  Future<void> setRefreshToken(String token) =>
      tokenManager.setRefreshToken(token);
  Future<void> clearTokens() => tokenManager.clearTokens();
  Future<String?> getAccessToken() => tokenManager.getAccessToken();
  Future<String?> getRefreshToken() => tokenManager.getRefreshToken();

  // Auth interceptor to add authorization headers
  InterceptorsWrapper _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Prevent retries on requests that are already retries
        if (options.extra.containsKey('isRetry') &&
            options.extra['isRetry'] == true) {
          return handler.next(options);
        }

        // Skip authentication for token endpoints
        if (options.path.contains('/auth/v1/token') ||
            options.path.contains('/auth/v1/signup')) {
          return handler.next(options);
        }

        final accessToken = await tokenManager.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Prevent retries on requests that are already retries
        if (error.requestOptions.extra.containsKey('isRetry') &&
            error.requestOptions.extra['isRetry'] == true) {
          return handler.next(error);
        }

        if (error.response?.statusCode == 401) {
          _logger.w(
            '[INFRASTRUCTURE] 401 Unauthorized: Attempting token refresh',
          );

          // Queue this request and try token refresh
          final result = await refreshManager.handleTokenRefresh(
            error.requestOptions,
          );

          if (result != null) {
            return handler.resolve(result);
          }
        }
        return handler.next(error);
      },
    );
  }

  // Error handling interceptor
  InterceptorsWrapper _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException error, handler) {
        if (error.response?.statusCode == 401) {
          return handler.next(error); // Let auth interceptor handle this
        }

        logger.logFailure(
          error.requestOptions.method,
          error.requestOptions.uri,
          error.response?.statusCode ?? -1,
          error.response?.headers.map ?? {},
          error.response?.data?.toString() ?? 'No data',
          error.requestOptions.data,
        );

        return handler.next(error);
      },
    );
  }

  // Logging interceptor
  InterceptorsWrapper _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.logRequest(
          options.method,
          options.uri,
          headers: options.headers.cast<String, String>(),
          body: options.data,
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.logSuccess(
          response.requestOptions.method,
          response.requestOptions.uri,
          response.statusCode ?? 200,
          response.headers.map,
          response.data.toString(),
        );
        return handler.next(response);
      },
    );
  }
}
