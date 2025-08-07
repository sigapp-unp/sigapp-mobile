// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chain_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseChainPreferencesModel _$CourseChainPreferencesModelFromJson(
  Map<String, dynamic> json,
) => _CourseChainPreferencesModel(
  highlightCriticalPath: json['highlightCriticalPath'] as bool? ?? false,
  viewMode:
      $enumDecodeNullable(_$CourseViewModeEnumMap, json['viewMode']) ??
      CourseViewMode.tree,
);

Map<String, dynamic> _$CourseChainPreferencesModelToJson(
  _CourseChainPreferencesModel instance,
) => <String, dynamic>{
  'highlightCriticalPath': instance.highlightCriticalPath,
  'viewMode': _$CourseViewModeEnumMap[instance.viewMode]!,
};

const _$CourseViewModeEnumMap = {
  CourseViewMode.tree: 'tree',
  CourseViewMode.list: 'list',
};
