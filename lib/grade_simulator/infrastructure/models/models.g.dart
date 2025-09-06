// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
  categories: (json['categories'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, CategoryModel.fromJson(e as Map<String, dynamic>)),
  ),
  grades: (json['grades'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, GradeModel.fromJson(e as Map<String, dynamic>)),
  ),
  lastModified: const _TimestampConverter().fromJson(json['lastModified']),
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'grades': instance.grades,
      'lastModified': const _TimestampConverter().toJson(instance.lastModified),
    };

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      name: json['name'] as String,
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{'name': instance.name, 'weight': instance.weight};

_GradeModel _$GradeModelFromJson(Map<String, dynamic> json) => _GradeModel(
  categoryIndex: (json['categoryIndex'] as num).toInt(),
  name: json['name'] as String,
  score: (json['score'] as num).toDouble(),
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$GradeModelToJson(_GradeModel instance) =>
    <String, dynamic>{
      'categoryIndex': instance.categoryIndex,
      'name': instance.name,
      'score': instance.score,
      'enabled': instance.enabled,
    };
