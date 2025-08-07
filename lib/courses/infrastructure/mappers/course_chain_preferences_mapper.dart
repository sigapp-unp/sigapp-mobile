import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';
import 'package:sigapp/courses/infrastructure/models/course_chain_preferences_model.dart';

class CourseChainPreferencesMapper {
  static CourseChainPreferences toDomain(CourseChainPreferencesModel model) {
    return CourseChainPreferences(
      highlightCriticalPath: model.highlightCriticalPath,
      viewMode: model.viewMode,
    );
  }

  static CourseChainPreferencesModel toInfrastructure(
    CourseChainPreferences entity,
  ) {
    return CourseChainPreferencesModel(
      highlightCriticalPath: entity.highlightCriticalPath,
      viewMode: entity.viewMode,
    );
  }
}
