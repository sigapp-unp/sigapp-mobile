import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

class _TimestampConverter implements JsonConverter<Timestamp?, Object?> {
  const _TimestampConverter();

  @override
  Timestamp? fromJson(Object? json) {
    if (json == null) return null;

    if (json is Timestamp) return json;

    if (json is Map<String, dynamic>) {
      final seconds = json['_seconds'] as int?;
      final nanoseconds = json['_nanoseconds'] as int?;
      if (seconds != null && nanoseconds != null) {
        return Timestamp(seconds, nanoseconds);
      }
    }

    if (json is String) {
      final dateTime = DateTime.tryParse(json);
      if (dateTime != null) {
        return Timestamp.fromDate(dateTime);
      }
    }

    if (json is int) {
      return Timestamp.fromMillisecondsSinceEpoch(json);
    }

    return null;
  }

  @override
  Object? toJson(Timestamp? timestamp) {
    if (timestamp == null) return null;

    return {
      '_seconds': timestamp.seconds,
      '_nanoseconds': timestamp.nanoseconds,
    };
  }
}

@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required List<CategoryModel> categories,
    required List<GradeModel> grades,
    @_TimestampConverter() Timestamp? lastModified,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({required String name, required double weight}) =
      _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

@freezed
abstract class GradeModel with _$GradeModel {
  const factory GradeModel({
    required int categoryIndex,
    required String name,
    required double score,
    @Default(true) bool enabled,
  }) = _GradeModel;

  factory GradeModel.fromJson(Map<String, dynamic> json) =>
      _$GradeModelFromJson(json);
}
