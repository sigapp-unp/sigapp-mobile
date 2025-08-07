import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sigapp/courses/infrastructure/models/course_chain_preferences_model.dart';

part 'global_preferences_model.freezed.dart';
part 'global_preferences_model.g.dart';

@freezed
abstract class GlobalPreferencesModel with _$GlobalPreferencesModel {
  const factory GlobalPreferencesModel({
    @Default(CourseChainPreferencesModel())
    CourseChainPreferencesModel courseChain,
  }) = _GlobalPreferencesModel;

  factory GlobalPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalPreferencesModelFromJson(json);
}
