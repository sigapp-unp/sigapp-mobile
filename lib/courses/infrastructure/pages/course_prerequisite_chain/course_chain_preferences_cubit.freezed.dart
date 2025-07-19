// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_chain_preferences_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseChainPreferencesState {

 bool get isLoading; CourseViewMode get viewMode; bool get highlightCriticalPath; Set<String> get criticalPathIds;
/// Create a copy of CourseChainPreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseChainPreferencesStateCopyWith<CourseChainPreferencesState> get copyWith => _$CourseChainPreferencesStateCopyWithImpl<CourseChainPreferencesState>(this as CourseChainPreferencesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseChainPreferencesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode)&&(identical(other.highlightCriticalPath, highlightCriticalPath) || other.highlightCriticalPath == highlightCriticalPath)&&const DeepCollectionEquality().equals(other.criticalPathIds, criticalPathIds));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,viewMode,highlightCriticalPath,const DeepCollectionEquality().hash(criticalPathIds));

@override
String toString() {
  return 'CourseChainPreferencesState(isLoading: $isLoading, viewMode: $viewMode, highlightCriticalPath: $highlightCriticalPath, criticalPathIds: $criticalPathIds)';
}


}

/// @nodoc
abstract mixin class $CourseChainPreferencesStateCopyWith<$Res>  {
  factory $CourseChainPreferencesStateCopyWith(CourseChainPreferencesState value, $Res Function(CourseChainPreferencesState) _then) = _$CourseChainPreferencesStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, CourseViewMode viewMode, bool highlightCriticalPath, Set<String> criticalPathIds
});




}
/// @nodoc
class _$CourseChainPreferencesStateCopyWithImpl<$Res>
    implements $CourseChainPreferencesStateCopyWith<$Res> {
  _$CourseChainPreferencesStateCopyWithImpl(this._self, this._then);

  final CourseChainPreferencesState _self;
  final $Res Function(CourseChainPreferencesState) _then;

/// Create a copy of CourseChainPreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? viewMode = null,Object? highlightCriticalPath = null,Object? criticalPathIds = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as CourseViewMode,highlightCriticalPath: null == highlightCriticalPath ? _self.highlightCriticalPath : highlightCriticalPath // ignore: cast_nullable_to_non_nullable
as bool,criticalPathIds: null == criticalPathIds ? _self.criticalPathIds : criticalPathIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// @nodoc


class _CourseChainPreferencesState implements CourseChainPreferencesState {
  const _CourseChainPreferencesState({this.isLoading = true, this.viewMode = CourseViewMode.tree, this.highlightCriticalPath = false, final  Set<String> criticalPathIds = const {}}): _criticalPathIds = criticalPathIds;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  CourseViewMode viewMode;
@override@JsonKey() final  bool highlightCriticalPath;
 final  Set<String> _criticalPathIds;
@override@JsonKey() Set<String> get criticalPathIds {
  if (_criticalPathIds is EqualUnmodifiableSetView) return _criticalPathIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_criticalPathIds);
}


/// Create a copy of CourseChainPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseChainPreferencesStateCopyWith<_CourseChainPreferencesState> get copyWith => __$CourseChainPreferencesStateCopyWithImpl<_CourseChainPreferencesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseChainPreferencesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode)&&(identical(other.highlightCriticalPath, highlightCriticalPath) || other.highlightCriticalPath == highlightCriticalPath)&&const DeepCollectionEquality().equals(other._criticalPathIds, _criticalPathIds));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,viewMode,highlightCriticalPath,const DeepCollectionEquality().hash(_criticalPathIds));

@override
String toString() {
  return 'CourseChainPreferencesState(isLoading: $isLoading, viewMode: $viewMode, highlightCriticalPath: $highlightCriticalPath, criticalPathIds: $criticalPathIds)';
}


}

/// @nodoc
abstract mixin class _$CourseChainPreferencesStateCopyWith<$Res> implements $CourseChainPreferencesStateCopyWith<$Res> {
  factory _$CourseChainPreferencesStateCopyWith(_CourseChainPreferencesState value, $Res Function(_CourseChainPreferencesState) _then) = __$CourseChainPreferencesStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, CourseViewMode viewMode, bool highlightCriticalPath, Set<String> criticalPathIds
});




}
/// @nodoc
class __$CourseChainPreferencesStateCopyWithImpl<$Res>
    implements _$CourseChainPreferencesStateCopyWith<$Res> {
  __$CourseChainPreferencesStateCopyWithImpl(this._self, this._then);

  final _CourseChainPreferencesState _self;
  final $Res Function(_CourseChainPreferencesState) _then;

/// Create a copy of CourseChainPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? viewMode = null,Object? highlightCriticalPath = null,Object? criticalPathIds = null,}) {
  return _then(_CourseChainPreferencesState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as CourseViewMode,highlightCriticalPath: null == highlightCriticalPath ? _self.highlightCriticalPath : highlightCriticalPath // ignore: cast_nullable_to_non_nullable
as bool,criticalPathIds: null == criticalPathIds ? _self._criticalPathIds : criticalPathIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
