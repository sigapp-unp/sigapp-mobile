// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduledCourse {

 int? get enrollmentCapacity; String get period; String get courseKey; String get classroomCode; String get courseCode; String get practiceTeacherCode; String get theoryTeacherCode; String get groupCode; int get availableSlots; String get classroomDescription; String get courseDescription; String get practiceTeacher; String get theoryTeacher; int get enrolledStudents; String get regevaCourseId; String get section;
/// Create a copy of ScheduledCourse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduledCourseCopyWith<ScheduledCourse> get copyWith => _$ScheduledCourseCopyWithImpl<ScheduledCourse>(this as ScheduledCourse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduledCourse&&(identical(other.enrollmentCapacity, enrollmentCapacity) || other.enrollmentCapacity == enrollmentCapacity)&&(identical(other.period, period) || other.period == period)&&(identical(other.courseKey, courseKey) || other.courseKey == courseKey)&&(identical(other.classroomCode, classroomCode) || other.classroomCode == classroomCode)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.practiceTeacherCode, practiceTeacherCode) || other.practiceTeacherCode == practiceTeacherCode)&&(identical(other.theoryTeacherCode, theoryTeacherCode) || other.theoryTeacherCode == theoryTeacherCode)&&(identical(other.groupCode, groupCode) || other.groupCode == groupCode)&&(identical(other.availableSlots, availableSlots) || other.availableSlots == availableSlots)&&(identical(other.classroomDescription, classroomDescription) || other.classroomDescription == classroomDescription)&&(identical(other.courseDescription, courseDescription) || other.courseDescription == courseDescription)&&(identical(other.practiceTeacher, practiceTeacher) || other.practiceTeacher == practiceTeacher)&&(identical(other.theoryTeacher, theoryTeacher) || other.theoryTeacher == theoryTeacher)&&(identical(other.enrolledStudents, enrolledStudents) || other.enrolledStudents == enrolledStudents)&&(identical(other.regevaCourseId, regevaCourseId) || other.regevaCourseId == regevaCourseId)&&(identical(other.section, section) || other.section == section));
}


@override
int get hashCode => Object.hash(runtimeType,enrollmentCapacity,period,courseKey,classroomCode,courseCode,practiceTeacherCode,theoryTeacherCode,groupCode,availableSlots,classroomDescription,courseDescription,practiceTeacher,theoryTeacher,enrolledStudents,regevaCourseId,section);

@override
String toString() {
  return 'ScheduledCourse(enrollmentCapacity: $enrollmentCapacity, period: $period, courseKey: $courseKey, classroomCode: $classroomCode, courseCode: $courseCode, practiceTeacherCode: $practiceTeacherCode, theoryTeacherCode: $theoryTeacherCode, groupCode: $groupCode, availableSlots: $availableSlots, classroomDescription: $classroomDescription, courseDescription: $courseDescription, practiceTeacher: $practiceTeacher, theoryTeacher: $theoryTeacher, enrolledStudents: $enrolledStudents, regevaCourseId: $regevaCourseId, section: $section)';
}


}

/// @nodoc
abstract mixin class $ScheduledCourseCopyWith<$Res>  {
  factory $ScheduledCourseCopyWith(ScheduledCourse value, $Res Function(ScheduledCourse) _then) = _$ScheduledCourseCopyWithImpl;
@useResult
$Res call({
 int? enrollmentCapacity, String period, String courseKey, String classroomCode, String courseCode, String practiceTeacherCode, String theoryTeacherCode, String groupCode, int availableSlots, String classroomDescription, String courseDescription, String practiceTeacher, String theoryTeacher, int enrolledStudents, String regevaCourseId, String section
});




}
/// @nodoc
class _$ScheduledCourseCopyWithImpl<$Res>
    implements $ScheduledCourseCopyWith<$Res> {
  _$ScheduledCourseCopyWithImpl(this._self, this._then);

  final ScheduledCourse _self;
  final $Res Function(ScheduledCourse) _then;

/// Create a copy of ScheduledCourse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enrollmentCapacity = freezed,Object? period = null,Object? courseKey = null,Object? classroomCode = null,Object? courseCode = null,Object? practiceTeacherCode = null,Object? theoryTeacherCode = null,Object? groupCode = null,Object? availableSlots = null,Object? classroomDescription = null,Object? courseDescription = null,Object? practiceTeacher = null,Object? theoryTeacher = null,Object? enrolledStudents = null,Object? regevaCourseId = null,Object? section = null,}) {
  return _then(_self.copyWith(
enrollmentCapacity: freezed == enrollmentCapacity ? _self.enrollmentCapacity : enrollmentCapacity // ignore: cast_nullable_to_non_nullable
as int?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,courseKey: null == courseKey ? _self.courseKey : courseKey // ignore: cast_nullable_to_non_nullable
as String,classroomCode: null == classroomCode ? _self.classroomCode : classroomCode // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,practiceTeacherCode: null == practiceTeacherCode ? _self.practiceTeacherCode : practiceTeacherCode // ignore: cast_nullable_to_non_nullable
as String,theoryTeacherCode: null == theoryTeacherCode ? _self.theoryTeacherCode : theoryTeacherCode // ignore: cast_nullable_to_non_nullable
as String,groupCode: null == groupCode ? _self.groupCode : groupCode // ignore: cast_nullable_to_non_nullable
as String,availableSlots: null == availableSlots ? _self.availableSlots : availableSlots // ignore: cast_nullable_to_non_nullable
as int,classroomDescription: null == classroomDescription ? _self.classroomDescription : classroomDescription // ignore: cast_nullable_to_non_nullable
as String,courseDescription: null == courseDescription ? _self.courseDescription : courseDescription // ignore: cast_nullable_to_non_nullable
as String,practiceTeacher: null == practiceTeacher ? _self.practiceTeacher : practiceTeacher // ignore: cast_nullable_to_non_nullable
as String,theoryTeacher: null == theoryTeacher ? _self.theoryTeacher : theoryTeacher // ignore: cast_nullable_to_non_nullable
as String,enrolledStudents: null == enrolledStudents ? _self.enrolledStudents : enrolledStudents // ignore: cast_nullable_to_non_nullable
as int,regevaCourseId: null == regevaCourseId ? _self.regevaCourseId : regevaCourseId // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduledCourse].
extension ScheduledCoursePatterns on ScheduledCourse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduledCourse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduledCourse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduledCourse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduledCourse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduledCourse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduledCourse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? enrollmentCapacity,  String period,  String courseKey,  String classroomCode,  String courseCode,  String practiceTeacherCode,  String theoryTeacherCode,  String groupCode,  int availableSlots,  String classroomDescription,  String courseDescription,  String practiceTeacher,  String theoryTeacher,  int enrolledStudents,  String regevaCourseId,  String section)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduledCourse() when $default != null:
return $default(_that.enrollmentCapacity,_that.period,_that.courseKey,_that.classroomCode,_that.courseCode,_that.practiceTeacherCode,_that.theoryTeacherCode,_that.groupCode,_that.availableSlots,_that.classroomDescription,_that.courseDescription,_that.practiceTeacher,_that.theoryTeacher,_that.enrolledStudents,_that.regevaCourseId,_that.section);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? enrollmentCapacity,  String period,  String courseKey,  String classroomCode,  String courseCode,  String practiceTeacherCode,  String theoryTeacherCode,  String groupCode,  int availableSlots,  String classroomDescription,  String courseDescription,  String practiceTeacher,  String theoryTeacher,  int enrolledStudents,  String regevaCourseId,  String section)  $default,) {final _that = this;
switch (_that) {
case _ScheduledCourse():
return $default(_that.enrollmentCapacity,_that.period,_that.courseKey,_that.classroomCode,_that.courseCode,_that.practiceTeacherCode,_that.theoryTeacherCode,_that.groupCode,_that.availableSlots,_that.classroomDescription,_that.courseDescription,_that.practiceTeacher,_that.theoryTeacher,_that.enrolledStudents,_that.regevaCourseId,_that.section);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? enrollmentCapacity,  String period,  String courseKey,  String classroomCode,  String courseCode,  String practiceTeacherCode,  String theoryTeacherCode,  String groupCode,  int availableSlots,  String classroomDescription,  String courseDescription,  String practiceTeacher,  String theoryTeacher,  int enrolledStudents,  String regevaCourseId,  String section)?  $default,) {final _that = this;
switch (_that) {
case _ScheduledCourse() when $default != null:
return $default(_that.enrollmentCapacity,_that.period,_that.courseKey,_that.classroomCode,_that.courseCode,_that.practiceTeacherCode,_that.theoryTeacherCode,_that.groupCode,_that.availableSlots,_that.classroomDescription,_that.courseDescription,_that.practiceTeacher,_that.theoryTeacher,_that.enrolledStudents,_that.regevaCourseId,_that.section);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduledCourse implements ScheduledCourse {
   _ScheduledCourse({required this.enrollmentCapacity, required this.period, required this.courseKey, required this.classroomCode, required this.courseCode, required this.practiceTeacherCode, required this.theoryTeacherCode, required this.groupCode, required this.availableSlots, required this.classroomDescription, required this.courseDescription, required this.practiceTeacher, required this.theoryTeacher, required this.enrolledStudents, required this.regevaCourseId, required this.section});
  

@override final  int? enrollmentCapacity;
@override final  String period;
@override final  String courseKey;
@override final  String classroomCode;
@override final  String courseCode;
@override final  String practiceTeacherCode;
@override final  String theoryTeacherCode;
@override final  String groupCode;
@override final  int availableSlots;
@override final  String classroomDescription;
@override final  String courseDescription;
@override final  String practiceTeacher;
@override final  String theoryTeacher;
@override final  int enrolledStudents;
@override final  String regevaCourseId;
@override final  String section;

/// Create a copy of ScheduledCourse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduledCourseCopyWith<_ScheduledCourse> get copyWith => __$ScheduledCourseCopyWithImpl<_ScheduledCourse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduledCourse&&(identical(other.enrollmentCapacity, enrollmentCapacity) || other.enrollmentCapacity == enrollmentCapacity)&&(identical(other.period, period) || other.period == period)&&(identical(other.courseKey, courseKey) || other.courseKey == courseKey)&&(identical(other.classroomCode, classroomCode) || other.classroomCode == classroomCode)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.practiceTeacherCode, practiceTeacherCode) || other.practiceTeacherCode == practiceTeacherCode)&&(identical(other.theoryTeacherCode, theoryTeacherCode) || other.theoryTeacherCode == theoryTeacherCode)&&(identical(other.groupCode, groupCode) || other.groupCode == groupCode)&&(identical(other.availableSlots, availableSlots) || other.availableSlots == availableSlots)&&(identical(other.classroomDescription, classroomDescription) || other.classroomDescription == classroomDescription)&&(identical(other.courseDescription, courseDescription) || other.courseDescription == courseDescription)&&(identical(other.practiceTeacher, practiceTeacher) || other.practiceTeacher == practiceTeacher)&&(identical(other.theoryTeacher, theoryTeacher) || other.theoryTeacher == theoryTeacher)&&(identical(other.enrolledStudents, enrolledStudents) || other.enrolledStudents == enrolledStudents)&&(identical(other.regevaCourseId, regevaCourseId) || other.regevaCourseId == regevaCourseId)&&(identical(other.section, section) || other.section == section));
}


@override
int get hashCode => Object.hash(runtimeType,enrollmentCapacity,period,courseKey,classroomCode,courseCode,practiceTeacherCode,theoryTeacherCode,groupCode,availableSlots,classroomDescription,courseDescription,practiceTeacher,theoryTeacher,enrolledStudents,regevaCourseId,section);

@override
String toString() {
  return 'ScheduledCourse(enrollmentCapacity: $enrollmentCapacity, period: $period, courseKey: $courseKey, classroomCode: $classroomCode, courseCode: $courseCode, practiceTeacherCode: $practiceTeacherCode, theoryTeacherCode: $theoryTeacherCode, groupCode: $groupCode, availableSlots: $availableSlots, classroomDescription: $classroomDescription, courseDescription: $courseDescription, practiceTeacher: $practiceTeacher, theoryTeacher: $theoryTeacher, enrolledStudents: $enrolledStudents, regevaCourseId: $regevaCourseId, section: $section)';
}


}

/// @nodoc
abstract mixin class _$ScheduledCourseCopyWith<$Res> implements $ScheduledCourseCopyWith<$Res> {
  factory _$ScheduledCourseCopyWith(_ScheduledCourse value, $Res Function(_ScheduledCourse) _then) = __$ScheduledCourseCopyWithImpl;
@override @useResult
$Res call({
 int? enrollmentCapacity, String period, String courseKey, String classroomCode, String courseCode, String practiceTeacherCode, String theoryTeacherCode, String groupCode, int availableSlots, String classroomDescription, String courseDescription, String practiceTeacher, String theoryTeacher, int enrolledStudents, String regevaCourseId, String section
});




}
/// @nodoc
class __$ScheduledCourseCopyWithImpl<$Res>
    implements _$ScheduledCourseCopyWith<$Res> {
  __$ScheduledCourseCopyWithImpl(this._self, this._then);

  final _ScheduledCourse _self;
  final $Res Function(_ScheduledCourse) _then;

/// Create a copy of ScheduledCourse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enrollmentCapacity = freezed,Object? period = null,Object? courseKey = null,Object? classroomCode = null,Object? courseCode = null,Object? practiceTeacherCode = null,Object? theoryTeacherCode = null,Object? groupCode = null,Object? availableSlots = null,Object? classroomDescription = null,Object? courseDescription = null,Object? practiceTeacher = null,Object? theoryTeacher = null,Object? enrolledStudents = null,Object? regevaCourseId = null,Object? section = null,}) {
  return _then(_ScheduledCourse(
enrollmentCapacity: freezed == enrollmentCapacity ? _self.enrollmentCapacity : enrollmentCapacity // ignore: cast_nullable_to_non_nullable
as int?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,courseKey: null == courseKey ? _self.courseKey : courseKey // ignore: cast_nullable_to_non_nullable
as String,classroomCode: null == classroomCode ? _self.classroomCode : classroomCode // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,practiceTeacherCode: null == practiceTeacherCode ? _self.practiceTeacherCode : practiceTeacherCode // ignore: cast_nullable_to_non_nullable
as String,theoryTeacherCode: null == theoryTeacherCode ? _self.theoryTeacherCode : theoryTeacherCode // ignore: cast_nullable_to_non_nullable
as String,groupCode: null == groupCode ? _self.groupCode : groupCode // ignore: cast_nullable_to_non_nullable
as String,availableSlots: null == availableSlots ? _self.availableSlots : availableSlots // ignore: cast_nullable_to_non_nullable
as int,classroomDescription: null == classroomDescription ? _self.classroomDescription : classroomDescription // ignore: cast_nullable_to_non_nullable
as String,courseDescription: null == courseDescription ? _self.courseDescription : courseDescription // ignore: cast_nullable_to_non_nullable
as String,practiceTeacher: null == practiceTeacher ? _self.practiceTeacher : practiceTeacher // ignore: cast_nullable_to_non_nullable
as String,theoryTeacher: null == theoryTeacher ? _self.theoryTeacher : theoryTeacher // ignore: cast_nullable_to_non_nullable
as String,enrolledStudents: null == enrolledStudents ? _self.enrolledStudents : enrolledStudents // ignore: cast_nullable_to_non_nullable
as int,regevaCourseId: null == regevaCourseId ? _self.regevaCourseId : regevaCourseId // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
