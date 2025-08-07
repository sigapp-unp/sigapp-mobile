// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SemesterPreferencesModel _$SemesterPreferencesModelFromJson(
  Map<String, dynamic> json,
) => _SemesterPreferencesModel(
  scheduleHiddenEvents:
      (json['scheduleHiddenEvents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$SemesterPreferencesModelToJson(
  _SemesterPreferencesModel instance,
) => <String, dynamic>{'scheduleHiddenEvents': instance.scheduleHiddenEvents};
