import 'package:freezed_annotation/freezed_annotation.dart';

part 'semester_preferences_model.freezed.dart';
part 'semester_preferences_model.g.dart';

@freezed
abstract class SemesterPreferencesModel with _$SemesterPreferencesModel {
  const factory SemesterPreferencesModel({
    @Default([]) List<String> scheduleHiddenEvents,
  }) = _SemesterPreferencesModel;

  factory SemesterPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$SemesterPreferencesModelFromJson(json);
}
