import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';

@LazySingleton(as: UserPreferencesRepository)
class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  final ApiGatewayClient _workerClient;
  final Logger _logger;

  UserPreferencesRepositoryImpl(this._workerClient, this._logger);

  @override
  Future<Map<String, dynamic>> getUserPreferences({
    required String studentCode,
  }) async {
    try {
      _logger.d(
        '[INFRASTRUCTURE] Getting preferences for student: $studentCode',
      );

      final queryParams = {
        'student_code': 'eq.$studentCode',
        'select': 'preferences',
      };

      final response = await _workerClient.http.get(
        '/rest/v1/user_preferences',
        queryParameters: queryParams,
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      final List<dynamic> data = response.data;
      if (data.isEmpty) {
        _logger.d('[INFRASTRUCTURE] No preferences found, returning empty map');
        return {};
      }

      final Map<String, dynamic> preferences =
          data[0]['preferences'] as Map<String, dynamic>;
      _logger.d('[INFRASTRUCTURE] Retrieved preferences successfully');
      return preferences;
    } catch (e, s) {
      _logger.w(
        '[INFRASTRUCTURE] Error getting user preferences (using defaults)',
        error: e,
        stackTrace: s,
      );
      return {}; // Graceful fallback to empty preferences
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserPreferences({
    required String studentCode,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      _logger.d(
        '[INFRASTRUCTURE] Updating preferences for student: $studentCode',
      );

      // Primero intentar UPDATE
      final updateResponse = await _workerClient.http.patch(
        '/rest/v1/user_preferences',
        queryParameters: {'student_code': 'eq.$studentCode'},
        data: {'preferences': preferences},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      // Si no hay filas afectadas, hacer INSERT
      if (updateResponse.data.isEmpty) {
        _logger.d(
          '[INFRASTRUCTURE] No existing preferences, creating new record',
        );

        await _workerClient.http.post(
          '/rest/v1/user_preferences',
          data: {'student_code': studentCode, 'preferences': preferences},
          options: Options(
            headers: {
              'X-Upstream': 'supabase',
              'Prefer': 'return=representation',
            },
          ),
        );
      }

      _logger.d('[INFRASTRUCTURE] Preferences updated successfully');
      return preferences;
    } catch (e, s) {
      _logger.e(
        '[INFRASTRUCTURE] Error updating user preferences',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to update user preferences: $e');
    }
  }

  @override
  Future<dynamic> getPreference({
    required String studentCode,
    required String path,
  }) async {
    final preferences = await getUserPreferences(studentCode: studentCode);
    return _getNestedValue(preferences, path);
  }

  @override
  Future<Map<String, dynamic>> setPreference({
    required String studentCode,
    required String path,
    required dynamic value,
  }) async {
    final currentPreferences = await getUserPreferences(
      studentCode: studentCode,
    );
    final updatedPreferences = Map<String, dynamic>.from(currentPreferences);

    _setNestedValue(updatedPreferences, path, value);

    return updateUserPreferences(
      studentCode: studentCode,
      preferences: updatedPreferences,
    );
  }

  /// Helper para obtener valor anidado usando dot notation (e.g., 'course_visibility.CURSO123')
  dynamic _getNestedValue(Map<String, dynamic> map, String path) {
    final keys = path.split('.');
    dynamic current = map;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }

  /// Helper para establecer valor anidado usando dot notation
  void _setNestedValue(Map<String, dynamic> map, String path, dynamic value) {
    final keys = path.split('.');
    Map<String, dynamic> current = map;

    // Navegar hasta el penúltimo nivel, creando objetos si no existen
    for (int i = 0; i < keys.length - 1; i++) {
      final key = keys[i];
      if (!current.containsKey(key) || current[key] is! Map<String, dynamic>) {
        current[key] = <String, dynamic>{};
      }
      current = current[key] as Map<String, dynamic>;
    }

    // Establecer el valor final
    current[keys.last] = value;
  }
}
