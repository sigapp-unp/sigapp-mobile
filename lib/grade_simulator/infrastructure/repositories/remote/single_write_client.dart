import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';

/// Generic JSONB field patcher for course_grade_simulator table
/// Handles single-field PATCH operations with error handling and logging
class SingleWriteClient {
  final ApiGatewayClient _client;
  final Logger _logger;

  const SingleWriteClient(this._client, this._logger);

  /// Patch a specific JSONB field in the course_grade_simulator table
  Future<void> patchField({
    required String studentCode,
    required String courseCode,
    required String field,
    required dynamic value,
  }) async {
    try {
      await _client.http.patch(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        data: {field: value},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
      _logger.d(
        '[JSONB_PATCHER] ✅ PATCH $field successful: ${studentCode}_$courseCode',
      );
    } on DioException catch (e) {
      _logger.e('[JSONB_PATCHER] ❌ PATCH $field failed: $e');
      rethrow;
    }
  }

  /// Patch multiple JSONB fields atomically
  Future<void> patchFields({
    required String studentCode,
    required String courseCode,
    required Map<String, dynamic> fields,
  }) async {
    try {
      await _client.http.patch(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        data: fields,
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
      _logger.d(
        '[JSONB_PATCHER] ✅ PATCH ${fields.keys.join(', ')} successful: ${studentCode}_$courseCode',
      );
    } on DioException catch (e) {
      _logger.e('[JSONB_PATCHER] ❌ PATCH ${fields.keys.join(', ')} failed: $e');
      rethrow;
    }
  }
}
