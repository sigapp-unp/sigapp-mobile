import 'package:sigapp/courses/domain/entities/semester_preferences.dart';
import 'package:sigapp/courses/infrastructure/models/semester_preferences_model.dart';

/// Mapper between domain entities and infrastructure models for SemesterPreferences
class SemesterPreferencesMapper {
  static SemesterPreferences toDomain(SemesterPreferencesModel model) {
    return SemesterPreferences(
      scheduleHiddenEvents: List<String>.from(model.scheduleHiddenEvents),
    );
  }

  static SemesterPreferencesModel toInfrastructure(SemesterPreferences entity) {
    return SemesterPreferencesModel(
      scheduleHiddenEvents: entity.scheduleHiddenEvents,
    );
  }
}
