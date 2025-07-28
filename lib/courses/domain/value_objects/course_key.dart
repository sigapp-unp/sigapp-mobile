import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_key.freezed.dart';

/// Value object that represents a unique course identifier
/// Combines studentCode and courseCode into a type-safe key
///
/// Features:
/// - Type safety instead of raw strings
/// - Immutable and value-based equality via Freezed
/// - Centralized validation and formatting
/// - Clear separation of concerns
@freezed
abstract class CourseKey with _$CourseKey {
  const factory CourseKey({
    required String studentCode,
    required String courseCode,
  }) = _CourseKey;

  const CourseKey._();

  /// Create CourseKey from combined string (studentCode_courseCode)
  factory CourseKey.fromString(String key) {
    final parts = key.split('_');
    if (parts.length != 2) {
      throw InvalidCourseKeyException(
        'Invalid courseKey format: Expected format: "studentCode_courseCode"',
        key,
      );
    }

    final studentCode = parts[0].trim();
    final courseCode = parts[1].trim();

    if (studentCode.isEmpty || courseCode.isEmpty) {
      throw InvalidCourseKeyException(
        'Invalid courseKey components: studentCode and courseCode cannot be empty',
        key,
      );
    }

    return CourseKey(studentCode: studentCode, courseCode: courseCode);
  }

  /// Convert to string representation (studentCode_courseCode)
  String get value => '${studentCode}_$courseCode';

  /// Validate that both components are present and non-empty
  bool get isValid => studentCode.isNotEmpty && courseCode.isNotEmpty;
}

/// Exception thrown when CourseKey validation fails
class InvalidCourseKeyException implements Exception {
  final String message;
  final String? invalidKey;

  const InvalidCourseKeyException(this.message, [this.invalidKey]);

  @override
  String toString() {
    if (invalidKey != null) {
      return 'InvalidCourseKeyException: $message (key: "$invalidKey")';
    }
    return 'InvalidCourseKeyException: $message';
  }
}
