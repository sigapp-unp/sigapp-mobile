// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GlobalPreferencesModel _$GlobalPreferencesModelFromJson(
  Map<String, dynamic> json,
) => _GlobalPreferencesModel(
  courseChain:
      json['courseChain'] == null
          ? const CourseChainPreferencesModel()
          : CourseChainPreferencesModel.fromJson(
            json['courseChain'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$GlobalPreferencesModelToJson(
  _GlobalPreferencesModel instance,
) => <String, dynamic>{'courseChain': instance.courseChain};
