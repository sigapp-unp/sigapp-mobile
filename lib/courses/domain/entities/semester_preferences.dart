import 'package:freezed_annotation/freezed_annotation.dart';

part 'semester_preferences.freezed.dart';

@freezed
abstract class SemesterPreferences with _$SemesterPreferences {
  factory SemesterPreferences({
    required List<String> scheduleHiddenEvents,
    // Future semester-specific preferences can be added here
  }) = _SemesterPreferences;

  static SemesterPreferences defaults() =>
      SemesterPreferences(scheduleHiddenEvents: []);
}
