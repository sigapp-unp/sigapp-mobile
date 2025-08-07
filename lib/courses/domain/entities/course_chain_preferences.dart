import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_chain_preferences.freezed.dart';

enum CourseViewMode {
  tree('tree'),
  list('list');

  const CourseViewMode(this.value);

  final String value;

  static CourseViewMode fromString(String value) {
    switch (value) {
      case 'tree':
        return CourseViewMode.tree;
      case 'list':
        return CourseViewMode.list;
      default:
        return CourseViewMode.tree; // default fallback
    }
  }

  @override
  String toString() => value;
}

@freezed
abstract class CourseChainPreferences with _$CourseChainPreferences {
  factory CourseChainPreferences({
    required bool highlightCriticalPath,
    required CourseViewMode viewMode,
  }) = _CourseChainPreferences;

  static CourseChainPreferences defaults() => CourseChainPreferences(
    highlightCriticalPath: true,
    viewMode: CourseViewMode.tree,
  );
}
