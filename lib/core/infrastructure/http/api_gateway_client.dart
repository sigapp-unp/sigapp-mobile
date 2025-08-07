import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client/api_logger.dart';
import 'package:logger/logger.dart';

/// Main client for API Gateway communication
@singleton
class ApiGatewayClient {
  late final String _url;
  late final Dio http;
  final ApiLogger logger;

  ApiGatewayClient(Logger logger) : logger = ApiLogger(logger) {
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

    // Add interceptors
    http.interceptors.add(_createErrorInterceptor());
    http.interceptors.add(_createLoggingInterceptor());
  }

  // Error handling interceptor
  InterceptorsWrapper _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException error, handler) {
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
