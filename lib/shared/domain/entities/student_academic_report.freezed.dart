// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_academic_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AcademicReport {

// required String faculty,
 String get facultyName; Faculty? get faculty; String get school; String get firstName; String get lastName; String get code; String get cohort;// required String enrollmentSemesterId,
// required String curriculumSemesterId,
// required String? lastSemesterId,
 ScheduledTermIdentifier get enrollmentSemester;// required ScheduledTermIdentifier curriculumSemester,
 String get curriculumSemester; ScheduledTermIdentifier? get lastSemester; double get cumulativeWeightedAverage; double get cumulativeWeightedAverageOfPassedCourses; double get lastCumulativeWeightedAverage; int get totalCreditsOfPassedCourses; int get curriculumMandatoryCredits; int get curriculumElectiveCredits; int get mandatoryCreditsOfPassedCourses; int get electiveCreditsOfPassedCourses;// General
 ScheduledTermIdentifier get currentSemester;
/// Create a copy of AcademicReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicReportCopyWith<AcademicReport> get copyWith => _$AcademicReportCopyWithImpl<AcademicReport>(this as AcademicReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicReport&&(identical(other.facultyName, facultyName) || other.facultyName == facultyName)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.school, school) || other.school == school)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.code, code) || other.code == code)&&(identical(other.cohort, cohort) || other.cohort == cohort)&&(identical(other.enrollmentSemester, enrollmentSemester) || other.enrollmentSemester == enrollmentSemester)&&(identical(other.curriculumSemester, curriculumSemester) || other.curriculumSemester == curriculumSemester)&&(identical(other.lastSemester, lastSemester) || other.lastSemester == lastSemester)&&(identical(other.cumulativeWeightedAverage, cumulativeWeightedAverage) || other.cumulativeWeightedAverage == cumulativeWeightedAverage)&&(identical(other.cumulativeWeightedAverageOfPassedCourses, cumulativeWeightedAverageOfPassedCourses) || other.cumulativeWeightedAverageOfPassedCourses == cumulativeWeightedAverageOfPassedCourses)&&(identical(other.lastCumulativeWeightedAverage, lastCumulativeWeightedAverage) || other.lastCumulativeWeightedAverage == lastCumulativeWeightedAverage)&&(identical(other.totalCreditsOfPassedCourses, totalCreditsOfPassedCourses) || other.totalCreditsOfPassedCourses == totalCreditsOfPassedCourses)&&(identical(other.curriculumMandatoryCredits, curriculumMandatoryCredits) || other.curriculumMandatoryCredits == curriculumMandatoryCredits)&&(identical(other.curriculumElectiveCredits, curriculumElectiveCredits) || other.curriculumElectiveCredits == curriculumElectiveCredits)&&(identical(other.mandatoryCreditsOfPassedCourses, mandatoryCreditsOfPassedCourses) || other.mandatoryCreditsOfPassedCourses == mandatoryCreditsOfPassedCourses)&&(identical(other.electiveCreditsOfPassedCourses, electiveCreditsOfPassedCourses) || other.electiveCreditsOfPassedCourses == electiveCreditsOfPassedCourses)&&(identical(other.currentSemester, currentSemester) || other.currentSemester == currentSemester));
}


@override
int get hashCode => Object.hashAll([runtimeType,facultyName,faculty,school,firstName,lastName,code,cohort,enrollmentSemester,curriculumSemester,lastSemester,cumulativeWeightedAverage,cumulativeWeightedAverageOfPassedCourses,lastCumulativeWeightedAverage,totalCreditsOfPassedCourses,curriculumMandatoryCredits,curriculumElectiveCredits,mandatoryCreditsOfPassedCourses,electiveCreditsOfPassedCourses,currentSemester]);

@override
String toString() {
  return 'AcademicReport(facultyName: $facultyName, faculty: $faculty, school: $school, firstName: $firstName, lastName: $lastName, code: $code, cohort: $cohort, enrollmentSemester: $enrollmentSemester, curriculumSemester: $curriculumSemester, lastSemester: $lastSemester, cumulativeWeightedAverage: $cumulativeWeightedAverage, cumulativeWeightedAverageOfPassedCourses: $cumulativeWeightedAverageOfPassedCourses, lastCumulativeWeightedAverage: $lastCumulativeWeightedAverage, totalCreditsOfPassedCourses: $totalCreditsOfPassedCourses, curriculumMandatoryCredits: $curriculumMandatoryCredits, curriculumElectiveCredits: $curriculumElectiveCredits, mandatoryCreditsOfPassedCourses: $mandatoryCreditsOfPassedCourses, electiveCreditsOfPassedCourses: $electiveCreditsOfPassedCourses, currentSemester: $currentSemester)';
}


}

/// @nodoc
abstract mixin class $AcademicReportCopyWith<$Res>  {
  factory $AcademicReportCopyWith(AcademicReport value, $Res Function(AcademicReport) _then) = _$AcademicReportCopyWithImpl;
@useResult
$Res call({
 String facultyName, Faculty? faculty, String school, String firstName, String lastName, String code, String cohort, ScheduledTermIdentifier enrollmentSemester, String curriculumSemester, ScheduledTermIdentifier? lastSemester, double cumulativeWeightedAverage, double cumulativeWeightedAverageOfPassedCourses, double lastCumulativeWeightedAverage, int totalCreditsOfPassedCourses, int curriculumMandatoryCredits, int curriculumElectiveCredits, int mandatoryCreditsOfPassedCourses, int electiveCreditsOfPassedCourses, ScheduledTermIdentifier currentSemester
});




}
/// @nodoc
class _$AcademicReportCopyWithImpl<$Res>
    implements $AcademicReportCopyWith<$Res> {
  _$AcademicReportCopyWithImpl(this._self, this._then);

  final AcademicReport _self;
  final $Res Function(AcademicReport) _then;

/// Create a copy of AcademicReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? facultyName = null,Object? faculty = freezed,Object? school = null,Object? firstName = null,Object? lastName = null,Object? code = null,Object? cohort = null,Object? enrollmentSemester = null,Object? curriculumSemester = null,Object? lastSemester = freezed,Object? cumulativeWeightedAverage = null,Object? cumulativeWeightedAverageOfPassedCourses = null,Object? lastCumulativeWeightedAverage = null,Object? totalCreditsOfPassedCourses = null,Object? curriculumMandatoryCredits = null,Object? curriculumElectiveCredits = null,Object? mandatoryCreditsOfPassedCourses = null,Object? electiveCreditsOfPassedCourses = null,Object? currentSemester = null,}) {
  return _then(_self.copyWith(
facultyName: null == facultyName ? _self.facultyName : facultyName // ignore: cast_nullable_to_non_nullable
as String,faculty: freezed == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as Faculty?,school: null == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,cohort: null == cohort ? _self.cohort : cohort // ignore: cast_nullable_to_non_nullable
as String,enrollmentSemester: null == enrollmentSemester ? _self.enrollmentSemester : enrollmentSemester // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier,curriculumSemester: null == curriculumSemester ? _self.curriculumSemester : curriculumSemester // ignore: cast_nullable_to_non_nullable
as String,lastSemester: freezed == lastSemester ? _self.lastSemester : lastSemester // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier?,cumulativeWeightedAverage: null == cumulativeWeightedAverage ? _self.cumulativeWeightedAverage : cumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,cumulativeWeightedAverageOfPassedCourses: null == cumulativeWeightedAverageOfPassedCourses ? _self.cumulativeWeightedAverageOfPassedCourses : cumulativeWeightedAverageOfPassedCourses // ignore: cast_nullable_to_non_nullable
as double,lastCumulativeWeightedAverage: null == lastCumulativeWeightedAverage ? _self.lastCumulativeWeightedAverage : lastCumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,totalCreditsOfPassedCourses: null == totalCreditsOfPassedCourses ? _self.totalCreditsOfPassedCourses : totalCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,curriculumMandatoryCredits: null == curriculumMandatoryCredits ? _self.curriculumMandatoryCredits : curriculumMandatoryCredits // ignore: cast_nullable_to_non_nullable
as int,curriculumElectiveCredits: null == curriculumElectiveCredits ? _self.curriculumElectiveCredits : curriculumElectiveCredits // ignore: cast_nullable_to_non_nullable
as int,mandatoryCreditsOfPassedCourses: null == mandatoryCreditsOfPassedCourses ? _self.mandatoryCreditsOfPassedCourses : mandatoryCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsOfPassedCourses: null == electiveCreditsOfPassedCourses ? _self.electiveCreditsOfPassedCourses : electiveCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,currentSemester: null == currentSemester ? _self.currentSemester : currentSemester // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier,
  ));
}

}


/// Adds pattern-matching-related methods to [AcademicReport].
extension AcademicReportPatterns on AcademicReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicReport value)  $default,){
final _that = this;
switch (_that) {
case _AcademicReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicReport value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String facultyName,  Faculty? faculty,  String school,  String firstName,  String lastName,  String code,  String cohort,  ScheduledTermIdentifier enrollmentSemester,  String curriculumSemester,  ScheduledTermIdentifier? lastSemester,  double cumulativeWeightedAverage,  double cumulativeWeightedAverageOfPassedCourses,  double lastCumulativeWeightedAverage,  int totalCreditsOfPassedCourses,  int curriculumMandatoryCredits,  int curriculumElectiveCredits,  int mandatoryCreditsOfPassedCourses,  int electiveCreditsOfPassedCourses,  ScheduledTermIdentifier currentSemester)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicReport() when $default != null:
return $default(_that.facultyName,_that.faculty,_that.school,_that.firstName,_that.lastName,_that.code,_that.cohort,_that.enrollmentSemester,_that.curriculumSemester,_that.lastSemester,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAverageOfPassedCourses,_that.lastCumulativeWeightedAverage,_that.totalCreditsOfPassedCourses,_that.curriculumMandatoryCredits,_that.curriculumElectiveCredits,_that.mandatoryCreditsOfPassedCourses,_that.electiveCreditsOfPassedCourses,_that.currentSemester);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String facultyName,  Faculty? faculty,  String school,  String firstName,  String lastName,  String code,  String cohort,  ScheduledTermIdentifier enrollmentSemester,  String curriculumSemester,  ScheduledTermIdentifier? lastSemester,  double cumulativeWeightedAverage,  double cumulativeWeightedAverageOfPassedCourses,  double lastCumulativeWeightedAverage,  int totalCreditsOfPassedCourses,  int curriculumMandatoryCredits,  int curriculumElectiveCredits,  int mandatoryCreditsOfPassedCourses,  int electiveCreditsOfPassedCourses,  ScheduledTermIdentifier currentSemester)  $default,) {final _that = this;
switch (_that) {
case _AcademicReport():
return $default(_that.facultyName,_that.faculty,_that.school,_that.firstName,_that.lastName,_that.code,_that.cohort,_that.enrollmentSemester,_that.curriculumSemester,_that.lastSemester,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAverageOfPassedCourses,_that.lastCumulativeWeightedAverage,_that.totalCreditsOfPassedCourses,_that.curriculumMandatoryCredits,_that.curriculumElectiveCredits,_that.mandatoryCreditsOfPassedCourses,_that.electiveCreditsOfPassedCourses,_that.currentSemester);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String facultyName,  Faculty? faculty,  String school,  String firstName,  String lastName,  String code,  String cohort,  ScheduledTermIdentifier enrollmentSemester,  String curriculumSemester,  ScheduledTermIdentifier? lastSemester,  double cumulativeWeightedAverage,  double cumulativeWeightedAverageOfPassedCourses,  double lastCumulativeWeightedAverage,  int totalCreditsOfPassedCourses,  int curriculumMandatoryCredits,  int curriculumElectiveCredits,  int mandatoryCreditsOfPassedCourses,  int electiveCreditsOfPassedCourses,  ScheduledTermIdentifier currentSemester)?  $default,) {final _that = this;
switch (_that) {
case _AcademicReport() when $default != null:
return $default(_that.facultyName,_that.faculty,_that.school,_that.firstName,_that.lastName,_that.code,_that.cohort,_that.enrollmentSemester,_that.curriculumSemester,_that.lastSemester,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAverageOfPassedCourses,_that.lastCumulativeWeightedAverage,_that.totalCreditsOfPassedCourses,_that.curriculumMandatoryCredits,_that.curriculumElectiveCredits,_that.mandatoryCreditsOfPassedCourses,_that.electiveCreditsOfPassedCourses,_that.currentSemester);case _:
  return null;

}
}

}

/// @nodoc


class _AcademicReport implements AcademicReport {
   _AcademicReport({required this.facultyName, required this.faculty, required this.school, required this.firstName, required this.lastName, required this.code, required this.cohort, required this.enrollmentSemester, required this.curriculumSemester, required this.lastSemester, required this.cumulativeWeightedAverage, required this.cumulativeWeightedAverageOfPassedCourses, required this.lastCumulativeWeightedAverage, required this.totalCreditsOfPassedCourses, required this.curriculumMandatoryCredits, required this.curriculumElectiveCredits, required this.mandatoryCreditsOfPassedCourses, required this.electiveCreditsOfPassedCourses, required this.currentSemester});
  

// required String faculty,
@override final  String facultyName;
@override final  Faculty? faculty;
@override final  String school;
@override final  String firstName;
@override final  String lastName;
@override final  String code;
@override final  String cohort;
// required String enrollmentSemesterId,
// required String curriculumSemesterId,
// required String? lastSemesterId,
@override final  ScheduledTermIdentifier enrollmentSemester;
// required ScheduledTermIdentifier curriculumSemester,
@override final  String curriculumSemester;
@override final  ScheduledTermIdentifier? lastSemester;
@override final  double cumulativeWeightedAverage;
@override final  double cumulativeWeightedAverageOfPassedCourses;
@override final  double lastCumulativeWeightedAverage;
@override final  int totalCreditsOfPassedCourses;
@override final  int curriculumMandatoryCredits;
@override final  int curriculumElectiveCredits;
@override final  int mandatoryCreditsOfPassedCourses;
@override final  int electiveCreditsOfPassedCourses;
// General
@override final  ScheduledTermIdentifier currentSemester;

/// Create a copy of AcademicReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicReportCopyWith<_AcademicReport> get copyWith => __$AcademicReportCopyWithImpl<_AcademicReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicReport&&(identical(other.facultyName, facultyName) || other.facultyName == facultyName)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.school, school) || other.school == school)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.code, code) || other.code == code)&&(identical(other.cohort, cohort) || other.cohort == cohort)&&(identical(other.enrollmentSemester, enrollmentSemester) || other.enrollmentSemester == enrollmentSemester)&&(identical(other.curriculumSemester, curriculumSemester) || other.curriculumSemester == curriculumSemester)&&(identical(other.lastSemester, lastSemester) || other.lastSemester == lastSemester)&&(identical(other.cumulativeWeightedAverage, cumulativeWeightedAverage) || other.cumulativeWeightedAverage == cumulativeWeightedAverage)&&(identical(other.cumulativeWeightedAverageOfPassedCourses, cumulativeWeightedAverageOfPassedCourses) || other.cumulativeWeightedAverageOfPassedCourses == cumulativeWeightedAverageOfPassedCourses)&&(identical(other.lastCumulativeWeightedAverage, lastCumulativeWeightedAverage) || other.lastCumulativeWeightedAverage == lastCumulativeWeightedAverage)&&(identical(other.totalCreditsOfPassedCourses, totalCreditsOfPassedCourses) || other.totalCreditsOfPassedCourses == totalCreditsOfPassedCourses)&&(identical(other.curriculumMandatoryCredits, curriculumMandatoryCredits) || other.curriculumMandatoryCredits == curriculumMandatoryCredits)&&(identical(other.curriculumElectiveCredits, curriculumElectiveCredits) || other.curriculumElectiveCredits == curriculumElectiveCredits)&&(identical(other.mandatoryCreditsOfPassedCourses, mandatoryCreditsOfPassedCourses) || other.mandatoryCreditsOfPassedCourses == mandatoryCreditsOfPassedCourses)&&(identical(other.electiveCreditsOfPassedCourses, electiveCreditsOfPassedCourses) || other.electiveCreditsOfPassedCourses == electiveCreditsOfPassedCourses)&&(identical(other.currentSemester, currentSemester) || other.currentSemester == currentSemester));
}


@override
int get hashCode => Object.hashAll([runtimeType,facultyName,faculty,school,firstName,lastName,code,cohort,enrollmentSemester,curriculumSemester,lastSemester,cumulativeWeightedAverage,cumulativeWeightedAverageOfPassedCourses,lastCumulativeWeightedAverage,totalCreditsOfPassedCourses,curriculumMandatoryCredits,curriculumElectiveCredits,mandatoryCreditsOfPassedCourses,electiveCreditsOfPassedCourses,currentSemester]);

@override
String toString() {
  return 'AcademicReport(facultyName: $facultyName, faculty: $faculty, school: $school, firstName: $firstName, lastName: $lastName, code: $code, cohort: $cohort, enrollmentSemester: $enrollmentSemester, curriculumSemester: $curriculumSemester, lastSemester: $lastSemester, cumulativeWeightedAverage: $cumulativeWeightedAverage, cumulativeWeightedAverageOfPassedCourses: $cumulativeWeightedAverageOfPassedCourses, lastCumulativeWeightedAverage: $lastCumulativeWeightedAverage, totalCreditsOfPassedCourses: $totalCreditsOfPassedCourses, curriculumMandatoryCredits: $curriculumMandatoryCredits, curriculumElectiveCredits: $curriculumElectiveCredits, mandatoryCreditsOfPassedCourses: $mandatoryCreditsOfPassedCourses, electiveCreditsOfPassedCourses: $electiveCreditsOfPassedCourses, currentSemester: $currentSemester)';
}


}

/// @nodoc
abstract mixin class _$AcademicReportCopyWith<$Res> implements $AcademicReportCopyWith<$Res> {
  factory _$AcademicReportCopyWith(_AcademicReport value, $Res Function(_AcademicReport) _then) = __$AcademicReportCopyWithImpl;
@override @useResult
$Res call({
 String facultyName, Faculty? faculty, String school, String firstName, String lastName, String code, String cohort, ScheduledTermIdentifier enrollmentSemester, String curriculumSemester, ScheduledTermIdentifier? lastSemester, double cumulativeWeightedAverage, double cumulativeWeightedAverageOfPassedCourses, double lastCumulativeWeightedAverage, int totalCreditsOfPassedCourses, int curriculumMandatoryCredits, int curriculumElectiveCredits, int mandatoryCreditsOfPassedCourses, int electiveCreditsOfPassedCourses, ScheduledTermIdentifier currentSemester
});




}
/// @nodoc
class __$AcademicReportCopyWithImpl<$Res>
    implements _$AcademicReportCopyWith<$Res> {
  __$AcademicReportCopyWithImpl(this._self, this._then);

  final _AcademicReport _self;
  final $Res Function(_AcademicReport) _then;

/// Create a copy of AcademicReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? facultyName = null,Object? faculty = freezed,Object? school = null,Object? firstName = null,Object? lastName = null,Object? code = null,Object? cohort = null,Object? enrollmentSemester = null,Object? curriculumSemester = null,Object? lastSemester = freezed,Object? cumulativeWeightedAverage = null,Object? cumulativeWeightedAverageOfPassedCourses = null,Object? lastCumulativeWeightedAverage = null,Object? totalCreditsOfPassedCourses = null,Object? curriculumMandatoryCredits = null,Object? curriculumElectiveCredits = null,Object? mandatoryCreditsOfPassedCourses = null,Object? electiveCreditsOfPassedCourses = null,Object? currentSemester = null,}) {
  return _then(_AcademicReport(
facultyName: null == facultyName ? _self.facultyName : facultyName // ignore: cast_nullable_to_non_nullable
as String,faculty: freezed == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as Faculty?,school: null == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,cohort: null == cohort ? _self.cohort : cohort // ignore: cast_nullable_to_non_nullable
as String,enrollmentSemester: null == enrollmentSemester ? _self.enrollmentSemester : enrollmentSemester // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier,curriculumSemester: null == curriculumSemester ? _self.curriculumSemester : curriculumSemester // ignore: cast_nullable_to_non_nullable
as String,lastSemester: freezed == lastSemester ? _self.lastSemester : lastSemester // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier?,cumulativeWeightedAverage: null == cumulativeWeightedAverage ? _self.cumulativeWeightedAverage : cumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,cumulativeWeightedAverageOfPassedCourses: null == cumulativeWeightedAverageOfPassedCourses ? _self.cumulativeWeightedAverageOfPassedCourses : cumulativeWeightedAverageOfPassedCourses // ignore: cast_nullable_to_non_nullable
as double,lastCumulativeWeightedAverage: null == lastCumulativeWeightedAverage ? _self.lastCumulativeWeightedAverage : lastCumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,totalCreditsOfPassedCourses: null == totalCreditsOfPassedCourses ? _self.totalCreditsOfPassedCourses : totalCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,curriculumMandatoryCredits: null == curriculumMandatoryCredits ? _self.curriculumMandatoryCredits : curriculumMandatoryCredits // ignore: cast_nullable_to_non_nullable
as int,curriculumElectiveCredits: null == curriculumElectiveCredits ? _self.curriculumElectiveCredits : curriculumElectiveCredits // ignore: cast_nullable_to_non_nullable
as int,mandatoryCreditsOfPassedCourses: null == mandatoryCreditsOfPassedCourses ? _self.mandatoryCreditsOfPassedCourses : mandatoryCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsOfPassedCourses: null == electiveCreditsOfPassedCourses ? _self.electiveCreditsOfPassedCourses : electiveCreditsOfPassedCourses // ignore: cast_nullable_to_non_nullable
as int,currentSemester: null == currentSemester ? _self.currentSemester : currentSemester // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier,
  ));
}


}

// dart format on
