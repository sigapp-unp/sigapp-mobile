import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';

part 'course_chain_preferences_model.freezed.dart';
part 'course_chain_preferences_model.g.dart';

@freezed
abstract class CourseChainPreferencesModel with _$CourseChainPreferencesModel {
  const factory CourseChainPreferencesModel({
    @Default(false) bool highlightCriticalPath,
    @Default(CourseViewMode.tree) CourseViewMode viewMode,
  }) = _CourseChainPreferencesModel;

  factory CourseChainPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$CourseChainPreferencesModelFromJson(json);
}
