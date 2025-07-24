import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'raw_course_requirement.freezed.dart';

@freezed
abstract class RawCourseRequirement with _$RawCourseRequirement {
  const factory RawCourseRequirement({
    required String courseCode,
    required String requiredCourseCode,
    required String requiredCourseDescription,
    required String score,
    required String semesterId,
  }) = _RawCourseRequirement;
}
