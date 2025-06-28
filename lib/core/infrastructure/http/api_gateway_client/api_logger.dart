import 'dart:convert';
import 'package:logger/logger.dart';

final _loggingHeaders = [
  'Authorization',
  'Content-Type',
  'Prefer',
  'apikey',
  'X-Client-Info',
];

/// Handles API request/response logging
class ApiLogger {
  final Logger _logger;
  ApiLogger(this._logger);

  void logRequest(
    String method,
    Uri uri, {
    Map<String, dynamic>? headers,
    dynamic body,
    bool isAuth = false,
  }) {
    final sanitizedHeaders = Map<String, dynamic>.from(headers ?? {})
      ..removeWhere((key, _) => !_loggingHeaders.contains(key));
    if (sanitizedHeaders.containsKey('Authorization') && !isAuth) {
      sanitizedHeaders['Authorization'] = 'Bearer [REDACTED]';
    }
    _logger.d(
      '[INFRASTRUCTURE] 📤 $method Request:\n'
      'URL: ${Uri.decodeFull(uri.toString())}\n'
      '${sanitizedHeaders.isNotEmpty ? 'Headers: ${_prettyPrint(sanitizedHeaders)}\n' : ''}'
      '${body != null ? 'Body: ${_prettyPrint(body)}' : 'No body'}',
    );
  }

  void logSuccess(
    String method,
    Uri uri,
    int statusCode,
    Map<String, List<String>> headers,
    String responseBody,
  ) {
    final filteredHeaders = Map<String, List<String>>.from(headers)
      ..removeWhere((key, _) => !_loggingHeaders.contains(key));
    _logger.i(
      '[INFRASTRUCTURE] 📥 $method Success ($statusCode):\n'
      'URL: ${Uri.decodeFull(uri.toString())}\n'
      '${filteredHeaders.isNotEmpty ? 'Response Headers: ${_prettyPrint(filteredHeaders)}\n' : ''}'
      'Response Body: ${_truncateAndPrettyPrint(responseBody)}',
    );
  }

  void logFailure(
    String method,
    Uri uri,
    int statusCode,
    Map<String, List<String>> headers,
    String responseBody,
    dynamic requestBody,
  ) {
    final filteredHeaders = Map<String, List<String>>.from(headers)
      ..removeWhere((key, _) => !_loggingHeaders.contains(key));
    _logger.e(
      '[INFRASTRUCTURE] ❌ $method Failure ($statusCode):\n'
      'URL: ${Uri.decodeFull(uri.toString())}\n'
      '${requestBody != null ? 'Request Body: ${_prettyPrint(requestBody)}\n' : ''}'
      '${filteredHeaders.isNotEmpty ? 'Response Headers: ${_prettyPrint(filteredHeaders)}\n' : ''}'
      'Response Body: $responseBody',
    );
  }

  String _prettyPrint(Object? object) {
    if (object == null) return 'null';
    try {
      return const JsonEncoder.withIndent('  ').convert(object);
    } catch (e) {
      return object.toString();
    }
  }

  String _truncateAndPrettyPrint(String text, {int maxLength = 500}) {
    if (text.isEmpty) return '[Empty]';
    try {
      final json = jsonDecode(text);
      var prettyJson = const JsonEncoder.withIndent('  ').convert(json);
      if (prettyJson.length > maxLength) {
        prettyJson = '${prettyJson.substring(0, maxLength)}... [truncated]';
      }
      return prettyJson;
    } catch (e) {
      if (text.length > maxLength) {
        return '${text.substring(0, maxLength)}... [truncated]';
      }
      return text;
    }
  }
}
