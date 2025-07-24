// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_academic_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawAcademicReport {

 String get faculty; String get studentName; String get cohort; String get enrollmentSemesterId; String get curriculumSemesterId; String? get lastSemesterId; double get cumulativeWeightedAverage; double get cumulativeWeightedAverageOfPassedCourses; double get lastCumulativeWeightedAverage; int get totalCreditsOfPassedCourses; int get curriculumMandatoryCredits; int get curriculumElectiveCredits; int get mandatoryCreditsOfPassedCourses; int get electiveCreditsOfPassedCourses;
/// Create a copy of RawAcademicReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawAcademicReportCopyWith<RawAcademicReport> get copyWith => _$RawAcademicReportCopyWithImpl<RawAcademicReport>(this as RawAcademicReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawAcademicReport&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.cohort, cohort) || other.cohort == cohort)&&(identical(other.enrollmentSemesterId, enrollmentSemesterId) || other.enrollmentSemesterId == enrollmentSemesterId)&&(identical(other.curriculumSemesterId, curriculumSemesterId) || other.curriculumSemesterId == curriculumSemesterId)&&(identical(other.lastSemesterId, lastSemesterId) || other.lastSemesterId == lastSemesterId)&&(identical(other.cumulativeWeightedAverage, cumulativeWeightedAverage) || other.cumulativeWeightedAverage == cumulativeWeightedAverage)&&(identical(other.cumulativeWeightedAverageOfPassedCourses, cumulativeWeightedAverageOfPassedCourses) || other.cumulativeWeightedAverageOfPassedCourses == cumulativeWeightedAverageOfPassedCourses)&&(identical(other.lastCumulativeWeightedAverage, lastCumulativeWeightedAverage) || other.lastCumulativeWeightedAverage == lastCumulativeWeightedAverage)&&(identical(other.totalCreditsOfPassedCourses, totalCreditsOfPassedCourses) || other.totalCreditsOfPassedCourses == totalCreditsOfPassedCourses)&&(identical(other.curriculumMandatoryCredits, curriculumMandatoryCredits) || other.curriculumMandatoryCredits == curriculumMandatoryCredits)&&(identical(other.curriculumElectiveCredits, curriculumElectiveCredits) || other.curriculumElectiveCredits == curriculumElectiveCredits)&&(identical(other.mandatoryCreditsOfPassedCourses, mandatoryCreditsOfPassedCourses) || other.mandatoryCreditsOfPassedCourses == mandatoryCreditsOfPassedCourses)&&(identical(other.electiveCreditsOfPassedCourses, electiveCreditsOfPassedCourses) || other.electiveCreditsOfPassedCourses == electiveCreditsOfPassedCourses));
}


@override
int get hashCode => Object.hash(runtimeType,faculty,studentName,cohort,enrollmentSemesterId,curriculumSemesterId,lastSemesterId,cumulativeWeightedAverage,cumulativeWeightedAverageOfPassedCourses,lastCumulativeWeightedAverage,totalCreditsOfPassedCourses,curriculumMandatoryCredits,curriculumElectiveCredits,mandatoryCreditsOfPassedCourses,electiveCreditsOfPassedCourses);

@override
String toString() {
  return 'RawAcademicReport(faculty: $faculty, studentName: $studentName, cohort: $cohort, enrollmentSemesterId: $enrollmentSemesterId, curriculumSemesterId: $curriculumSemesterId, lastSemesterId: $lastSemesterId, cumulativeWeightedAverage: $cumulativeWeightedAverage, cumulativeWeightedAverageOfPassedCourses: $cumulativeWeightedAverageOfPassedCourses, lastCumulativeWeightedAverage: $lastCumulativeWeightedAverage, totalCreditsOfPassedCourses: $totalCreditsOfPassedCourses, curriculumMandatoryCredits: $curriculumMandatoryCredits, curriculumElectiveCredits: $curriculumElectiveCredits, mandatoryCreditsOfPassedCourses: $mandatoryCreditsOfPassedCourses, electiveCreditsOfPassedCourses: $electiveCreditsOfPassedCourses)';
}


}

/// @nodoc
abstract mixin class $RawAcademicReportCopyWith<$Res>  {
  factory $RawAcademicReportCopyWith(RawAcademicReport value, $Res Function(RawAcademicReport) _then) = _$RawAcademicReportCopyWithImpl;
@useResult
$Res call({
 String faculty, String studentName, String cohort, String enrollmentSemesterId, String curriculumSemesterId, String? lastSemesterId, double cumulativeWeightedAverage, double cumulativeWeightedAverageOfPassedCourses, double lastCumulativeWeightedAverage, int totalCreditsOfPassedCourses, int curriculumMandatoryCredits, int curriculumElectiveCredits, int mandatoryCreditsOfPassedCourses, int electiveCreditsOfPassedCourses
});




}
/// @nodoc
class _$RawAcademicReportCopyWithImpl<$Res>
    implements $RawAcademicReportCopyWith<$Res> {
  _$RawAcademicReportCopyWithImpl(this._self, this._then);

  final RawAcademicReport _self;
  final $Res Function(RawAcademicReport) _then;

/// Create a copy of RawAcademicReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? faculty = null,Object? studentName = null,Object? cohort = null,Object? enrollmentSemesterId = null,Object? curriculumSemesterId = null,Object? lastSemesterId = freezed,Object? cumulativeWeightedAverage = null,Object? cumulativeWeightedAverageOfPassedCourses = null,Object? lastCumulativeWeightedAverage = null,Object? totalCreditsOfPassedCourses = null,Object? curriculumMandatoryCredits = null,Object? curriculumElectiveCredits = null,Object? mandatoryCreditsOfPassedCourses = null,Object? electiveCreditsOfPassedCourses = null,}) {
  return _then(_self.copyWith(
faculty: null == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,cohort: null == cohort ? _self.cohort : cohort // ignore: cast_nullable_to_non_nullable
as String,enrollmentSemesterId: null == enrollmentSemesterId ? _self.enrollmentSemesterId : enrollmentSemesterId // ignore: cast_nullable_to_non_nullable
as String,curriculumSemesterId: null == curriculumSemesterId ? _self.curriculumSemesterId : curriculumSemesterId // ignore: cast_nullable_to_non_nullable
as String,lastSemesterId: freezed == lastSemesterId ? _self.lastSemesterId : lastSemesterId // ignore: cast_nullable_to_non_nullable
as String?,cumulativeWeightedAverage: null == cumulativeWeightedAverage ? _self.cumulativeWeightedAverage : cumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,cumulativeWeightedAverageOfPassedCourses: null == cumulativeWeightedAverageOfPassedCourses ? _self.cumulativeWeightedAverageOfPassedCourses : cumulativeWeightedAverageOfPassedCourses // ignore: cast_nullable_to_non_nullable
as double,lastCumulativeWeightedAverage: null == lastCumulativeWeightedAverage ? _self.lastCumulativeWeightedAverage : lastCumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,totalCreditsOfPassedCourses: null == totalCreditsOfPassedCourses ? _self.totalCreditsOfPassedCourses : totalCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,curriculumMandatoryCredits: null == curriculumMandatoryCredits ? _self.curriculumMandatoryCredits : curriculumMandatoryCredits // ignore: cast_nullable_to_non_nullable
as int,curriculumElectiveCredits: null == curriculumElectiveCredits ? _self.curriculumElectiveCredits : curriculumElectiveCredits // ignore: cast_nullable_to_non_nullable
as int,mandatoryCreditsOfPassedCourses: null == mandatoryCreditsOfPassedCourses ? _self.mandatoryCreditsOfPassedCourses : mandatoryCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsOfPassedCourses: null == electiveCreditsOfPassedCourses ? _self.electiveCreditsOfPassedCourses : electiveCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RawAcademicReport].
extension RawAcademicReportPatterns on RawAcademicReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawAcademicReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawAcademicReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawAcademicReport value)  $default,){
final _that = this;
switch (_that) {
case _RawAcademicReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawAcademicReport value)?  $default,){
final _that = this;
switch (_that) {
case _RawAcademicReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String faculty,  String studentName,  String cohort,  String enrollmentSemesterId,  String curriculumSemesterId,  String? lastSemesterId,  double cumulativeWeightedAverage,  double cumulativeWeightedAverageOfPassedCourses,  double lastCumulativeWeightedAverage,  int totalCreditsOfPassedCourses,  int curriculumMandatoryCredits,  int curriculumElectiveCredits,  int mandatoryCreditsOfPassedCourses,  int electiveCreditsOfPassedCourses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawAcademicReport() when $default != null:
return $default(_that.faculty,_that.studentName,_that.cohort,_that.enrollmentSemesterId,_that.curriculumSemesterId,_that.lastSemesterId,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAverageOfPassedCourses,_that.lastCumulativeWeightedAverage,_that.totalCreditsOfPassedCourses,_that.curriculumMandatoryCredits,_that.curriculumElectiveCredits,_that.mandatoryCreditsOfPassedCourses,_that.electiveCreditsOfPassedCourses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String faculty,  String studentName,  String cohort,  String enrollmentSemesterId,  String curriculumSemesterId,  String? lastSemesterId,  double cumulativeWeightedAverage,  double cumulativeWeightedAverageOfPassedCourses,  double lastCumulativeWeightedAverage,  int totalCreditsOfPassedCourses,  int curriculumMandatoryCredits,  int curriculumElectiveCredits,  int mandatoryCreditsOfPassedCourses,  int electiveCreditsOfPassedCourses)  $default,) {final _that = this;
switch (_that) {
case _RawAcademicReport():
return $default(_that.faculty,_that.studentName,_that.cohort,_that.enrollmentSemesterId,_that.curriculumSemesterId,_that.lastSemesterId,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAverageOfPassedCourses,_that.lastCumulativeWeightedAverage,_that.totalCreditsOfPassedCourses,_that.curriculumMandatoryCredits,_that.curriculumElectiveCredits,_that.mandatoryCreditsOfPassedCourses,_that.electiveCreditsOfPassedCourses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String faculty,  String studentName,  String cohort,  String enrollmentSemesterId,  String curriculumSemesterId,  String? lastSemesterId,  double cumulativeWeightedAverage,  double cumulativeWeightedAverageOfPassedCourses,  double lastCumulativeWeightedAverage,  int totalCreditsOfPassedCourses,  int curriculumMandatoryCredits,  int curriculumElectiveCredits,  int mandatoryCreditsOfPassedCourses,  int electiveCreditsOfPassedCourses)?  $default,) {final _that = this;
switch (_that) {
case _RawAcademicReport() when $default != null:
return $default(_that.faculty,_that.studentName,_that.cohort,_that.enrollmentSemesterId,_that.curriculumSemesterId,_that.lastSemesterId,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAverageOfPassedCourses,_that.lastCumulativeWeightedAverage,_that.totalCreditsOfPassedCourses,_that.curriculumMandatoryCredits,_that.curriculumElectiveCredits,_that.mandatoryCreditsOfPassedCourses,_that.electiveCreditsOfPassedCourses);case _:
  return null;

}
}

}

/// @nodoc


class _RawAcademicReport implements RawAcademicReport {
   _RawAcademicReport({required this.faculty, required this.studentName, required this.cohort, required this.enrollmentSemesterId, required this.curriculumSemesterId, required this.lastSemesterId, required this.cumulativeWeightedAverage, required this.cumulativeWeightedAverageOfPassedCourses, required this.lastCumulativeWeightedAverage, required this.totalCreditsOfPassedCourses, required this.curriculumMandatoryCredits, required this.curriculumElectiveCredits, required this.mandatoryCreditsOfPassedCourses, required this.electiveCreditsOfPassedCourses});
  

@override final  String faculty;
@override final  String studentName;
@override final  String cohort;
@override final  String enrollmentSemesterId;
@override final  String curriculumSemesterId;
@override final  String? lastSemesterId;
@override final  double cumulativeWeightedAverage;
@override final  double cumulativeWeightedAverageOfPassedCourses;
@override final  double lastCumulativeWeightedAverage;
@override final  int totalCreditsOfPassedCourses;
@override final  int curriculumMandatoryCredits;
@override final  int curriculumElectiveCredits;
@override final  int mandatoryCreditsOfPassedCourses;
@override final  int electiveCreditsOfPassedCourses;

/// Create a copy of RawAcademicReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawAcademicReportCopyWith<_RawAcademicReport> get copyWith => __$RawAcademicReportCopyWithImpl<_RawAcademicReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawAcademicReport&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.cohort, cohort) || other.cohort == cohort)&&(identical(other.enrollmentSemesterId, enrollmentSemesterId) || other.enrollmentSemesterId == enrollmentSemesterId)&&(identical(other.curriculumSemesterId, curriculumSemesterId) || other.curriculumSemesterId == curriculumSemesterId)&&(identical(other.lastSemesterId, lastSemesterId) || other.lastSemesterId == lastSemesterId)&&(identical(other.cumulativeWeightedAverage, cumulativeWeightedAverage) || other.cumulativeWeightedAverage == cumulativeWeightedAverage)&&(identical(other.cumulativeWeightedAverageOfPassedCourses, cumulativeWeightedAverageOfPassedCourses) || other.cumulativeWeightedAverageOfPassedCourses == cumulativeWeightedAverageOfPassedCourses)&&(identical(other.lastCumulativeWeightedAverage, lastCumulativeWeightedAverage) || other.lastCumulativeWeightedAverage == lastCumulativeWeightedAverage)&&(identical(other.totalCreditsOfPassedCourses, totalCreditsOfPassedCourses) || other.totalCreditsOfPassedCourses == totalCreditsOfPassedCourses)&&(identical(other.curriculumMandatoryCredits, curriculumMandatoryCredits) || other.curriculumMandatoryCredits == curriculumMandatoryCredits)&&(identical(other.curriculumElectiveCredits, curriculumElectiveCredits) || other.curriculumElectiveCredits == curriculumElectiveCredits)&&(identical(other.mandatoryCreditsOfPassedCourses, mandatoryCreditsOfPassedCourses) || other.mandatoryCreditsOfPassedCourses == mandatoryCreditsOfPassedCourses)&&(identical(other.electiveCreditsOfPassedCourses, electiveCreditsOfPassedCourses) || other.electiveCreditsOfPassedCourses == electiveCreditsOfPassedCourses));
}


@override
int get hashCode => Object.hash(runtimeType,faculty,studentName,cohort,enrollmentSemesterId,curriculumSemesterId,lastSemesterId,cumulativeWeightedAverage,cumulativeWeightedAverageOfPassedCourses,lastCumulativeWeightedAverage,totalCreditsOfPassedCourses,curriculumMandatoryCredits,curriculumElectiveCredits,mandatoryCreditsOfPassedCourses,electiveCreditsOfPassedCourses);

@override
String toString() {
  return 'RawAcademicReport(faculty: $faculty, studentName: $studentName, cohort: $cohort, enrollmentSemesterId: $enrollmentSemesterId, curriculumSemesterId: $curriculumSemesterId, lastSemesterId: $lastSemesterId, cumulativeWeightedAverage: $cumulativeWeightedAverage, cumulativeWeightedAverageOfPassedCourses: $cumulativeWeightedAverageOfPassedCourses, lastCumulativeWeightedAverage: $lastCumulativeWeightedAverage, totalCreditsOfPassedCourses: $totalCreditsOfPassedCourses, curriculumMandatoryCredits: $curriculumMandatoryCredits, curriculumElectiveCredits: $curriculumElectiveCredits, mandatoryCreditsOfPassedCourses: $mandatoryCreditsOfPassedCourses, electiveCreditsOfPassedCourses: $electiveCreditsOfPassedCourses)';
}


}

/// @nodoc
abstract mixin class _$RawAcademicReportCopyWith<$Res> implements $RawAcademicReportCopyWith<$Res> {
  factory _$RawAcademicReportCopyWith(_RawAcademicReport value, $Res Function(_RawAcademicReport) _then) = __$RawAcademicReportCopyWithImpl;
@override @useResult
$Res call({
 String faculty, String studentName, String cohort, String enrollmentSemesterId, String curriculumSemesterId, String? lastSemesterId, double cumulativeWeightedAverage, double cumulativeWeightedAverageOfPassedCourses, double lastCumulativeWeightedAverage, int totalCreditsOfPassedCourses, int curriculumMandatoryCredits, int curriculumElectiveCredits, int mandatoryCreditsOfPassedCourses, int electiveCreditsOfPassedCourses
});




}
/// @nodoc
class __$RawAcademicReportCopyWithImpl<$Res>
    implements _$RawAcademicReportCopyWith<$Res> {
  __$RawAcademicReportCopyWithImpl(this._self, this._then);

  final _RawAcademicReport _self;
  final $Res Function(_RawAcademicReport) _then;

/// Create a copy of RawAcademicReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? faculty = null,Object? studentName = null,Object? cohort = null,Object? enrollmentSemesterId = null,Object? curriculumSemesterId = null,Object? lastSemesterId = freezed,Object? cumulativeWeightedAverage = null,Object? cumulativeWeightedAverageOfPassedCourses = null,Object? lastCumulativeWeightedAverage = null,Object? totalCreditsOfPassedCourses = null,Object? curriculumMandatoryCredits = null,Object? curriculumElectiveCredits = null,Object? mandatoryCreditsOfPassedCourses = null,Object? electiveCreditsOfPassedCourses = null,}) {
  return _then(_RawAcademicReport(
faculty: null == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,cohort: null == cohort ? _self.cohort : cohort // ignore: cast_nullable_to_non_nullable
as String,enrollmentSemesterId: null == enrollmentSemesterId ? _self.enrollmentSemesterId : enrollmentSemesterId // ignore: cast_nullable_to_non_nullable
as String,curriculumSemesterId: null == curriculumSemesterId ? _self.curriculumSemesterId : curriculumSemesterId // ignore: cast_nullable_to_non_nullable
as String,lastSemesterId: freezed == lastSemesterId ? _self.lastSemesterId : lastSemesterId // ignore: cast_nullable_to_non_nullable
as String?,cumulativeWeightedAverage: null == cumulativeWeightedAverage ? _self.cumulativeWeightedAverage : cumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,cumulativeWeightedAverageOfPassedCourses: null == cumulativeWeightedAverageOfPassedCourses ? _self.cumulativeWeightedAverageOfPassedCourses : cumulativeWeightedAverageOfPassedCourses // ignore: cast_nullable_to_non_nullable
as double,lastCumulativeWeightedAverage: null == lastCumulativeWeightedAverage ? _self.lastCumulativeWeightedAverage : lastCumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,totalCreditsOfPassedCourses: null == totalCreditsOfPassedCourses ? _self.totalCreditsOfPassedCourses : totalCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,curriculumMandatoryCredits: null == curriculumMandatoryCredits ? _self.curriculumMandatoryCredits : curriculumMandatoryCredits // ignore: cast_nullable_to_non_nullable
as int,curriculumElectiveCredits: null == curriculumElectiveCredits ? _self.curriculumElectiveCredits : curriculumElectiveCredits // ignore: cast_nullable_to_non_nullable
as int,mandatoryCreditsOfPassedCourses: null == mandatoryCreditsOfPassedCourses ? _self.mandatoryCreditsOfPassedCourses : mandatoryCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsOfPassedCourses: null == electiveCreditsOfPassedCourses ? _self.electiveCreditsOfPassedCourses : electiveCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
