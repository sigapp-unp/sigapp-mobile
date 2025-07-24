// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_course_requirement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawCourseRequirement implements DiagnosticableTreeMixin {

 String get courseCode; String get requiredCourseCode; String get requiredCourseDescription; String get score; String get semesterId;
/// Create a copy of RawCourseRequirement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawCourseRequirementCopyWith<RawCourseRequirement> get copyWith => _$RawCourseRequirementCopyWithImpl<RawCourseRequirement>(this as RawCourseRequirement, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RawCourseRequirement'))
    ..add(DiagnosticsProperty('courseCode', courseCode))..add(DiagnosticsProperty('requiredCourseCode', requiredCourseCode))..add(DiagnosticsProperty('requiredCourseDescription', requiredCourseDescription))..add(DiagnosticsProperty('score', score))..add(DiagnosticsProperty('semesterId', semesterId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawCourseRequirement&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.requiredCourseCode, requiredCourseCode) || other.requiredCourseCode == requiredCourseCode)&&(identical(other.requiredCourseDescription, requiredCourseDescription) || other.requiredCourseDescription == requiredCourseDescription)&&(identical(other.score, score) || other.score == score)&&(identical(other.semesterId, semesterId) || other.semesterId == semesterId));
}


@override
int get hashCode => Object.hash(runtimeType,courseCode,requiredCourseCode,requiredCourseDescription,score,semesterId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RawCourseRequirement(courseCode: $courseCode, requiredCourseCode: $requiredCourseCode, requiredCourseDescription: $requiredCourseDescription, score: $score, semesterId: $semesterId)';
}


}

/// @nodoc
abstract mixin class $RawCourseRequirementCopyWith<$Res>  {
  factory $RawCourseRequirementCopyWith(RawCourseRequirement value, $Res Function(RawCourseRequirement) _then) = _$RawCourseRequirementCopyWithImpl;
@useResult
$Res call({
 String courseCode, String requiredCourseCode, String requiredCourseDescription, String score, String semesterId
});




}
/// @nodoc
class _$RawCourseRequirementCopyWithImpl<$Res>
    implements $RawCourseRequirementCopyWith<$Res> {
  _$RawCourseRequirementCopyWithImpl(this._self, this._then);

  final RawCourseRequirement _self;
  final $Res Function(RawCourseRequirement) _then;

/// Create a copy of RawCourseRequirement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseCode = null,Object? requiredCourseCode = null,Object? requiredCourseDescription = null,Object? score = null,Object? semesterId = null,}) {
  return _then(_self.copyWith(
courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,requiredCourseCode: null == requiredCourseCode ? _self.requiredCourseCode : requiredCourseCode // ignore: cast_nullable_to_non_nullable
as String,requiredCourseDescription: null == requiredCourseDescription ? _self.requiredCourseDescription : requiredCourseDescription // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as String,semesterId: null == semesterId ? _self.semesterId : semesterId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RawCourseRequirement].
extension RawCourseRequirementPatterns on RawCourseRequirement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawCourseRequirement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawCourseRequirement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawCourseRequirement value)  $default,){
final _that = this;
switch (_that) {
case _RawCourseRequirement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawCourseRequirement value)?  $default,){
final _that = this;
switch (_that) {
case _RawCourseRequirement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String courseCode,  String requiredCourseCode,  String requiredCourseDescription,  String score,  String semesterId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawCourseRequirement() when $default != null:
return $default(_that.courseCode,_that.requiredCourseCode,_that.requiredCourseDescription,_that.score,_that.semesterId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String courseCode,  String requiredCourseCode,  String requiredCourseDescription,  String score,  String semesterId)  $default,) {final _that = this;
switch (_that) {
case _RawCourseRequirement():
return $default(_that.courseCode,_that.requiredCourseCode,_that.requiredCourseDescription,_that.score,_that.semesterId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String courseCode,  String requiredCourseCode,  String requiredCourseDescription,  String score,  String semesterId)?  $default,) {final _that = this;
switch (_that) {
case _RawCourseRequirement() when $default != null:
return $default(_that.courseCode,_that.requiredCourseCode,_that.requiredCourseDescription,_that.score,_that.semesterId);case _:
  return null;

}
}

}

/// @nodoc


class _RawCourseRequirement with DiagnosticableTreeMixin implements RawCourseRequirement {
  const _RawCourseRequirement({required this.courseCode, required this.requiredCourseCode, required this.requiredCourseDescription, required this.score, required this.semesterId});
  

@override final  String courseCode;
@override final  String requiredCourseCode;
@override final  String requiredCourseDescription;
@override final  String score;
@override final  String semesterId;

/// Create a copy of RawCourseRequirement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawCourseRequirementCopyWith<_RawCourseRequirement> get copyWith => __$RawCourseRequirementCopyWithImpl<_RawCourseRequirement>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'RawCourseRequirement'))
    ..add(DiagnosticsProperty('courseCode', courseCode))..add(DiagnosticsProperty('requiredCourseCode', requiredCourseCode))..add(DiagnosticsProperty('requiredCourseDescription', requiredCourseDescription))..add(DiagnosticsProperty('score', score))..add(DiagnosticsProperty('semesterId', semesterId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawCourseRequirement&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.requiredCourseCode, requiredCourseCode) || other.requiredCourseCode == requiredCourseCode)&&(identical(other.requiredCourseDescription, requiredCourseDescription) || other.requiredCourseDescription == requiredCourseDescription)&&(identical(other.score, score) || other.score == score)&&(identical(other.semesterId, semesterId) || other.semesterId == semesterId));
}


@override
int get hashCode => Object.hash(runtimeType,courseCode,requiredCourseCode,requiredCourseDescription,score,semesterId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'RawCourseRequirement(courseCode: $courseCode, requiredCourseCode: $requiredCourseCode, requiredCourseDescription: $requiredCourseDescription, score: $score, semesterId: $semesterId)';
}


}

/// @nodoc
abstract mixin class _$RawCourseRequirementCopyWith<$Res> implements $RawCourseRequirementCopyWith<$Res> {
  factory _$RawCourseRequirementCopyWith(_RawCourseRequirement value, $Res Function(_RawCourseRequirement) _then) = __$RawCourseRequirementCopyWithImpl;
@override @useResult
$Res call({
 String courseCode, String requiredCourseCode, String requiredCourseDescription, String score, String semesterId
});




}
/// @nodoc
class __$RawCourseRequirementCopyWithImpl<$Res>
    implements _$RawCourseRequirementCopyWith<$Res> {
  __$RawCourseRequirementCopyWithImpl(this._self, this._then);

  final _RawCourseRequirement _self;
  final $Res Function(_RawCourseRequirement) _then;

/// Create a copy of RawCourseRequirement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseCode = null,Object? requiredCourseCode = null,Object? requiredCourseDescription = null,Object? score = null,Object? semesterId = null,}) {
  return _then(_RawCourseRequirement(
courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,requiredCourseCode: null == requiredCourseCode ? _self.requiredCourseCode : requiredCourseCode // ignore: cast_nullable_to_non_nullable
as String,requiredCourseDescription: null == requiredCourseDescription ? _self.requiredCourseDescription : requiredCourseDescription // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as String,semesterId: null == semesterId ? _self.semesterId : semesterId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
