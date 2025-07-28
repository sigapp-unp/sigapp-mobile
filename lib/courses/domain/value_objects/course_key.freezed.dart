// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_key.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseKey {

 String get studentCode; String get courseCode;
/// Create a copy of CourseKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseKeyCopyWith<CourseKey> get copyWith => _$CourseKeyCopyWithImpl<CourseKey>(this as CourseKey, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseKey&&(identical(other.studentCode, studentCode) || other.studentCode == studentCode)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode));
}


@override
int get hashCode => Object.hash(runtimeType,studentCode,courseCode);

@override
String toString() {
  return 'CourseKey(studentCode: $studentCode, courseCode: $courseCode)';
}


}

/// @nodoc
abstract mixin class $CourseKeyCopyWith<$Res>  {
  factory $CourseKeyCopyWith(CourseKey value, $Res Function(CourseKey) _then) = _$CourseKeyCopyWithImpl;
@useResult
$Res call({
 String studentCode, String courseCode
});




}
/// @nodoc
class _$CourseKeyCopyWithImpl<$Res>
    implements $CourseKeyCopyWith<$Res> {
  _$CourseKeyCopyWithImpl(this._self, this._then);

  final CourseKey _self;
  final $Res Function(CourseKey) _then;

/// Create a copy of CourseKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentCode = null,Object? courseCode = null,}) {
  return _then(_self.copyWith(
studentCode: null == studentCode ? _self.studentCode : studentCode // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseKey].
extension CourseKeyPatterns on CourseKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseKey value)  $default,){
final _that = this;
switch (_that) {
case _CourseKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseKey value)?  $default,){
final _that = this;
switch (_that) {
case _CourseKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentCode,  String courseCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseKey() when $default != null:
return $default(_that.studentCode,_that.courseCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentCode,  String courseCode)  $default,) {final _that = this;
switch (_that) {
case _CourseKey():
return $default(_that.studentCode,_that.courseCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentCode,  String courseCode)?  $default,) {final _that = this;
switch (_that) {
case _CourseKey() when $default != null:
return $default(_that.studentCode,_that.courseCode);case _:
  return null;

}
}

}

/// @nodoc


class _CourseKey extends CourseKey {
  const _CourseKey({required this.studentCode, required this.courseCode}): super._();
  

@override final  String studentCode;
@override final  String courseCode;

/// Create a copy of CourseKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseKeyCopyWith<_CourseKey> get copyWith => __$CourseKeyCopyWithImpl<_CourseKey>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseKey&&(identical(other.studentCode, studentCode) || other.studentCode == studentCode)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode));
}


@override
int get hashCode => Object.hash(runtimeType,studentCode,courseCode);

@override
String toString() {
  return 'CourseKey(studentCode: $studentCode, courseCode: $courseCode)';
}


}

/// @nodoc
abstract mixin class _$CourseKeyCopyWith<$Res> implements $CourseKeyCopyWith<$Res> {
  factory _$CourseKeyCopyWith(_CourseKey value, $Res Function(_CourseKey) _then) = __$CourseKeyCopyWithImpl;
@override @useResult
$Res call({
 String studentCode, String courseCode
});




}
/// @nodoc
class __$CourseKeyCopyWithImpl<$Res>
    implements _$CourseKeyCopyWith<$Res> {
  __$CourseKeyCopyWithImpl(this._self, this._then);

  final _CourseKey _self;
  final $Res Function(_CourseKey) _then;

/// Create a copy of CourseKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentCode = null,Object? courseCode = null,}) {
  return _then(_CourseKey(
studentCode: null == studentCode ? _self.studentCode : studentCode // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
