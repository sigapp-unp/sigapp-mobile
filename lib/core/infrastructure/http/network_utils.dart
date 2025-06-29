import 'dart:io';

import 'package:dio/dio.dart';

bool isNetworkError(Object error) {
  if (error is DioException) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.type == DioExceptionType.unknown &&
            (error.error is SocketException ||
                error.message?.contains('Failed host lookup') == true));
  }
  return false;
}
