import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sigapp/auth/domain/value-objects/api_path_and_method.dart';

part 'api_response.freezed.dart';

@freezed
abstract class ApiResponse with _$ApiResponse {
  factory ApiResponse({
    required ApiPathAndMethod pathAndMethod,
    required int statusCode,
    required Map<String, List<String>> headers,
    String? messageLevel1,
    String? messageLevel2,
    String? messageLevel3,
  }) = _ApiResponse;
}
