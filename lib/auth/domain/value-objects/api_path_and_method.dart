import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_path_and_method.freezed.dart';

enum ApiMethod {
  get('GET'),
  post('POST');

  final String value;

  const ApiMethod(this.value);

  factory ApiMethod.fromString(String value) {
    value = value.toUpperCase();
    switch (value) {
      case 'GET':
        return ApiMethod.get;
      case 'POST':
        return ApiMethod.post;
      default:
        throw Exception('Invalid HTTP method');
    }
  }
}

@freezed
abstract class ApiPathAndMethod with _$ApiPathAndMethod {
  factory ApiPathAndMethod(ApiMethod method, String path) = _ApiPathAndMethod;
}
