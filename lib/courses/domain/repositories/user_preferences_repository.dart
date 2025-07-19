abstract class UserPreferencesRepository {
  /// Obtiene las preferencias completas del usuario
  Future<Map<String, dynamic>> getUserPreferences({
    required String studentCode,
  });

  /// Actualiza las preferencias del usuario (merge con existentes)
  Future<Map<String, dynamic>> updateUserPreferences({
    required String studentCode,
    required Map<String, dynamic> preferences,
  });

  /// Obtiene una preferencia específica por path (e.g., 'course_visibility.CURSO123')
  Future<dynamic> getPreference({
    required String studentCode,
    required String path,
  });

  /// Establece una preferencia específica por path
  Future<Map<String, dynamic>> setPreference({
    required String studentCode,
    required String path,
    required dynamic value,
  });
}
