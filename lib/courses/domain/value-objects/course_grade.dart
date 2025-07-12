import 'package:freezed_annotation/freezed_annotation.dart';
part 'course_grade.freezed.dart';

class CourseGradeValue {
  final double value;
  final String label;
  final bool isPartial;

  CourseGradeValue({
    required this.value,
    required this.label,
    required this.isPartial,
  });
}

class CourseGradeInfo {
  final String url;
  final CourseGradePreview grade;

  CourseGradeInfo({required this.url, required this.grade});
}

@freezed
sealed class CourseGradePreview with _$CourseGradePreview {
  factory CourseGradePreview.loaded(CourseGradeValue value) =
      CourseGradePreviewLoaded;
  factory CourseGradePreview.empty() = CourseGradePreviewEmpty;
  factory CourseGradePreview.error(dynamic error) = CourseGradePreviewError;
}
