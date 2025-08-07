import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';

part 'global_preferences.freezed.dart';

@freezed
abstract class GlobalPreferences with _$GlobalPreferences {
  factory GlobalPreferences({
    required CourseChainPreferences courseChain,
    // Future global preferences can be added here
  }) = _GlobalPreferences;

  static GlobalPreferences defaults() =>
      GlobalPreferences(courseChain: CourseChainPreferences.defaults());
}
