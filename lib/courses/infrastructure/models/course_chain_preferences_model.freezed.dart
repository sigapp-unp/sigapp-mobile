// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_chain_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseChainPreferencesModel {

 bool get highlightCriticalPath; CourseViewMode get viewMode;
/// Create a copy of CourseChainPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseChainPreferencesModelCopyWith<CourseChainPreferencesModel> get copyWith => _$CourseChainPreferencesModelCopyWithImpl<CourseChainPreferencesModel>(this as CourseChainPreferencesModel, _$identity);

  /// Serializes this CourseChainPreferencesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseChainPreferencesModel&&(identical(other.highlightCriticalPath, highlightCriticalPath) || other.highlightCriticalPath == highlightCriticalPath)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,highlightCriticalPath,viewMode);

@override
String toString() {
  return 'CourseChainPreferencesModel(highlightCriticalPath: $highlightCriticalPath, viewMode: $viewMode)';
}


}

/// @nodoc
abstract mixin class $CourseChainPreferencesModelCopyWith<$Res>  {
  factory $CourseChainPreferencesModelCopyWith(CourseChainPreferencesModel value, $Res Function(CourseChainPreferencesModel) _then) = _$CourseChainPreferencesModelCopyWithImpl;
@useResult
$Res call({
 bool highlightCriticalPath, CourseViewMode viewMode
});




}
/// @nodoc
class _$CourseChainPreferencesModelCopyWithImpl<$Res>
    implements $CourseChainPreferencesModelCopyWith<$Res> {
  _$CourseChainPreferencesModelCopyWithImpl(this._self, this._then);

  final CourseChainPreferencesModel _self;
  final $Res Function(CourseChainPreferencesModel) _then;

/// Create a copy of CourseChainPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? highlightCriticalPath = null,Object? viewMode = null,}) {
  return _then(_self.copyWith(
highlightCriticalPath: null == highlightCriticalPath ? _self.highlightCriticalPath : highlightCriticalPath // ignore: cast_nullable_to_non_nullable
as bool,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as CourseViewMode,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseChainPreferencesModel].
extension CourseChainPreferencesModelPatterns on CourseChainPreferencesModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseChainPreferencesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseChainPreferencesModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseChainPreferencesModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseChainPreferencesModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseChainPreferencesModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseChainPreferencesModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool highlightCriticalPath,  CourseViewMode viewMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseChainPreferencesModel() when $default != null:
return $default(_that.highlightCriticalPath,_that.viewMode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool highlightCriticalPath,  CourseViewMode viewMode)  $default,) {final _that = this;
switch (_that) {
case _CourseChainPreferencesModel():
return $default(_that.highlightCriticalPath,_that.viewMode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool highlightCriticalPath,  CourseViewMode viewMode)?  $default,) {final _that = this;
switch (_that) {
case _CourseChainPreferencesModel() when $default != null:
return $default(_that.highlightCriticalPath,_that.viewMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseChainPreferencesModel implements CourseChainPreferencesModel {
  const _CourseChainPreferencesModel({this.highlightCriticalPath = false, this.viewMode = CourseViewMode.tree});
  factory _CourseChainPreferencesModel.fromJson(Map<String, dynamic> json) => _$CourseChainPreferencesModelFromJson(json);

@override@JsonKey() final  bool highlightCriticalPath;
@override@JsonKey() final  CourseViewMode viewMode;

/// Create a copy of CourseChainPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseChainPreferencesModelCopyWith<_CourseChainPreferencesModel> get copyWith => __$CourseChainPreferencesModelCopyWithImpl<_CourseChainPreferencesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseChainPreferencesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseChainPreferencesModel&&(identical(other.highlightCriticalPath, highlightCriticalPath) || other.highlightCriticalPath == highlightCriticalPath)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,highlightCriticalPath,viewMode);

@override
String toString() {
  return 'CourseChainPreferencesModel(highlightCriticalPath: $highlightCriticalPath, viewMode: $viewMode)';
}


}

/// @nodoc
abstract mixin class _$CourseChainPreferencesModelCopyWith<$Res> implements $CourseChainPreferencesModelCopyWith<$Res> {
  factory _$CourseChainPreferencesModelCopyWith(_CourseChainPreferencesModel value, $Res Function(_CourseChainPreferencesModel) _then) = __$CourseChainPreferencesModelCopyWithImpl;
@override @useResult
$Res call({
 bool highlightCriticalPath, CourseViewMode viewMode
});




}
/// @nodoc
class __$CourseChainPreferencesModelCopyWithImpl<$Res>
    implements _$CourseChainPreferencesModelCopyWith<$Res> {
  __$CourseChainPreferencesModelCopyWithImpl(this._self, this._then);

  final _CourseChainPreferencesModel _self;
  final $Res Function(_CourseChainPreferencesModel) _then;

/// Create a copy of CourseChainPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? highlightCriticalPath = null,Object? viewMode = null,}) {
  return _then(_CourseChainPreferencesModel(
highlightCriticalPath: null == highlightCriticalPath ? _self.highlightCriticalPath : highlightCriticalPath // ignore: cast_nullable_to_non_nullable
as bool,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as CourseViewMode,
  ));
}


}

// dart format on
