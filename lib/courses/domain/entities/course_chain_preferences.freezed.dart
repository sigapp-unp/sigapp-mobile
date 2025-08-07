// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_chain_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseChainPreferences {

 bool get highlightCriticalPath; CourseViewMode get viewMode;
/// Create a copy of CourseChainPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseChainPreferencesCopyWith<CourseChainPreferences> get copyWith => _$CourseChainPreferencesCopyWithImpl<CourseChainPreferences>(this as CourseChainPreferences, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseChainPreferences&&(identical(other.highlightCriticalPath, highlightCriticalPath) || other.highlightCriticalPath == highlightCriticalPath)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode));
}


@override
int get hashCode => Object.hash(runtimeType,highlightCriticalPath,viewMode);

@override
String toString() {
  return 'CourseChainPreferences(highlightCriticalPath: $highlightCriticalPath, viewMode: $viewMode)';
}


}

/// @nodoc
abstract mixin class $CourseChainPreferencesCopyWith<$Res>  {
  factory $CourseChainPreferencesCopyWith(CourseChainPreferences value, $Res Function(CourseChainPreferences) _then) = _$CourseChainPreferencesCopyWithImpl;
@useResult
$Res call({
 bool highlightCriticalPath, CourseViewMode viewMode
});




}
/// @nodoc
class _$CourseChainPreferencesCopyWithImpl<$Res>
    implements $CourseChainPreferencesCopyWith<$Res> {
  _$CourseChainPreferencesCopyWithImpl(this._self, this._then);

  final CourseChainPreferences _self;
  final $Res Function(CourseChainPreferences) _then;

/// Create a copy of CourseChainPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? highlightCriticalPath = null,Object? viewMode = null,}) {
  return _then(_self.copyWith(
highlightCriticalPath: null == highlightCriticalPath ? _self.highlightCriticalPath : highlightCriticalPath // ignore: cast_nullable_to_non_nullable
as bool,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as CourseViewMode,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseChainPreferences].
extension CourseChainPreferencesPatterns on CourseChainPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseChainPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseChainPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseChainPreferences value)  $default,){
final _that = this;
switch (_that) {
case _CourseChainPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseChainPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _CourseChainPreferences() when $default != null:
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
case _CourseChainPreferences() when $default != null:
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
case _CourseChainPreferences():
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
case _CourseChainPreferences() when $default != null:
return $default(_that.highlightCriticalPath,_that.viewMode);case _:
  return null;

}
}

}

/// @nodoc


class _CourseChainPreferences implements CourseChainPreferences {
   _CourseChainPreferences({required this.highlightCriticalPath, required this.viewMode});
  

@override final  bool highlightCriticalPath;
@override final  CourseViewMode viewMode;

/// Create a copy of CourseChainPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseChainPreferencesCopyWith<_CourseChainPreferences> get copyWith => __$CourseChainPreferencesCopyWithImpl<_CourseChainPreferences>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseChainPreferences&&(identical(other.highlightCriticalPath, highlightCriticalPath) || other.highlightCriticalPath == highlightCriticalPath)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode));
}


@override
int get hashCode => Object.hash(runtimeType,highlightCriticalPath,viewMode);

@override
String toString() {
  return 'CourseChainPreferences(highlightCriticalPath: $highlightCriticalPath, viewMode: $viewMode)';
}


}

/// @nodoc
abstract mixin class _$CourseChainPreferencesCopyWith<$Res> implements $CourseChainPreferencesCopyWith<$Res> {
  factory _$CourseChainPreferencesCopyWith(_CourseChainPreferences value, $Res Function(_CourseChainPreferences) _then) = __$CourseChainPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool highlightCriticalPath, CourseViewMode viewMode
});




}
/// @nodoc
class __$CourseChainPreferencesCopyWithImpl<$Res>
    implements _$CourseChainPreferencesCopyWith<$Res> {
  __$CourseChainPreferencesCopyWithImpl(this._self, this._then);

  final _CourseChainPreferences _self;
  final $Res Function(_CourseChainPreferences) _then;

/// Create a copy of CourseChainPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? highlightCriticalPath = null,Object? viewMode = null,}) {
  return _then(_CourseChainPreferences(
highlightCriticalPath: null == highlightCriticalPath ? _self.highlightCriticalPath : highlightCriticalPath // ignore: cast_nullable_to_non_nullable
as bool,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as CourseViewMode,
  ));
}


}

// dart format on
