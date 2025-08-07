import 'package:sigapp/courses/domain/entities/global_preferences.dart';
import 'package:sigapp/courses/infrastructure/models/global_preferences_model.dart';
import 'package:sigapp/courses/infrastructure/mappers/course_chain_preferences_mapper.dart';

/// Mapper between domain entities and infrastructure models for GlobalPreferences
class GlobalPreferencesMapper {
  static GlobalPreferences toDomain(GlobalPreferencesModel model) {
    return GlobalPreferences(
      courseChain: CourseChainPreferencesMapper.toDomain(model.courseChain),
    );
  }

  static GlobalPreferencesModel toInfrastructure(GlobalPreferences entity) {
    return GlobalPreferencesModel(
      courseChain: CourseChainPreferencesMapper.toInfrastructure(
        entity.courseChain,
      ),
    );
  }
}
