import 'package:sigapp/courses/domain/entities/global_preferences.dart';
import 'package:sigapp/courses/domain/entities/semester_preferences.dart';

abstract class UserPreferencesRepository {
  // ===== GLOBAL PREFERENCES =====

  /// Get global preferences (UI/UX settings)
  Future<GlobalPreferences> getGlobalPreferences({required String studentCode});

  /// Update global preferences
  Future<GlobalPreferences> updateGlobalPreferences({
    required String studentCode,
    required GlobalPreferences preferences,
  });

  // ===== SEMESTER-SPECIFIC PREFERENCES =====

  /// Get semester-specific preferences
  Future<SemesterPreferences> getSemesterPreferences({
    required String studentCode,
    required String semesterId,
  });

  /// Update semester-specific preferences
  Future<SemesterPreferences> updateSemesterPreferences({
    required String studentCode,
    required String semesterId,
    required SemesterPreferences preferences,
  });

  /// Add an event to hidden schedule events list for a specific semester (atomic operation)
  Future<void> addSemesterHiddenScheduleEvent({
    required String studentCode,
    required String semesterId,
    required String eventId,
  });

  /// Remove an event from hidden schedule events list for a specific semester (atomic operation)
  Future<void> removeSemesterHiddenScheduleEvent({
    required String studentCode,
    required String semesterId,
    required String eventId,
  });
}
