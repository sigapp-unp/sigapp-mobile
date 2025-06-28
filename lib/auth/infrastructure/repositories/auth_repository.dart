import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/auth/domain/value-objects/api_path_and_method.dart';
import 'package:sigapp/core/infrastructure/http/siga_client.dart';
import 'package:sigapp/auth/domain/repositories/auth_repository.dart';
import 'package:sigapp/auth/domain/value-objects/api_response.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SigaClient _sigaClient;

  AuthRepositoryImpl(this._sigaClient);

  @override
  Future<ApiResponse> login(String username, String password) async {
    final response = await _sigaClient.http.post(
      SigaClient.signInPath,
      data: {
        'Instancia': '01',
        'CodAlumno': username,
        'ClaveWeb': password,
        'g-recaptcha-response': '',
      },
      options: Options(
        headers: {'content-type': 'application/x-www-form-urlencoded'},
        followRedirects: false,
        validateStatus: (status) {
          return true;
        },
      ),
    );
    final statusCode = response.statusCode;
    if (statusCode == null) throw Exception('Status code is null');
    return ApiResponse(
      statusCode: statusCode,
      headers: response.headers.map,
      pathAndMethod: ApiPathAndMethod(
        ApiMethod.fromString(response.requestOptions.method),
        response.requestOptions.path,
      ),
    );
  }

  @override
  Future<ApiResponse> keepSession() async {
    final response = await _sigaClient.http.post(
      SigaClient.keepSessionPath,
      options: Options(validateStatus: (status) => true),
    );
    final statusCode = response.statusCode;
    if (statusCode == null) throw Exception('Status code is null');
    return ApiResponse(
      statusCode: statusCode,
      headers: response.headers.map,
      pathAndMethod: ApiPathAndMethod(
        ApiMethod.fromString(response.requestOptions.method),
        response.requestOptions.path,
      ),
    );
  }

  @override
  Future<void> disposeCookies() async {
    await _sigaClient.cookieManager.clearAllCookies();
  }

  @override
  Future<ApiResponse> checkSurvey1() async {
    return _checkSurvey(SigaClient.survey1RedirectionLocation);
  }

  @override
  Future<ApiResponse> checkSurvey2() async {
    return _checkSurvey(SigaClient.survey2RedirectionLocation);
  }

  Future<ApiResponse> _checkSurvey(String path) async {
    final response = await _sigaClient.http.get(
      path,
      options: Options(validateStatus: (status) => true),
    );
    final statusCode = response.statusCode;
    if (statusCode == null) throw Exception('Status code is null');
    return ApiResponse(
      statusCode: statusCode,
      headers: response.headers.map,
      pathAndMethod: ApiPathAndMethod(
        ApiMethod.fromString(response.requestOptions.method),
        response.requestOptions.path,
      ),
    );
  }
}
