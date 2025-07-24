// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrolled_course_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnrolledCourseData implements DiagnosticableTreeMixin {

// required String? Acta,
 String? get googleClassroomCode;// required String? Activo,
// required String Aula,
 String get url;// required int CeroEnActa,
// required String ClaveCurso,
// required String CodCurso,
 String get courseCode;// required int Creditos,
 int get credits;// required int Cupos,
// required String Curso,
 String get courseName;// required int Desaprobados,
// required String Docente,
 String get professor;// required String? EstadoInscripcion,
// required String Fecha,
 DateTime get date;// required String FechaInscripcion,
// required String Grupo,
 String get group;// required int Item,
// required String ItemProg,
 String get regevaScheduledCourseId;// required String Observacion,
// required String Seccion,
 String get section;// required dynamic Sylabus,
// required String TipoCurso,
 CourseType? get courseType;
/// Create a copy of EnrolledCourseData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrolledCourseDataCopyWith<EnrolledCourseData> get copyWith => _$EnrolledCourseDataCopyWithImpl<EnrolledCourseData>(this as EnrolledCourseData, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EnrolledCourseData'))
    ..add(DiagnosticsProperty('googleClassroomCode', googleClassroomCode))..add(DiagnosticsProperty('url', url))..add(DiagnosticsProperty('courseCode', courseCode))..add(DiagnosticsProperty('credits', credits))..add(DiagnosticsProperty('courseName', courseName))..add(DiagnosticsProperty('professor', professor))..add(DiagnosticsProperty('date', date))..add(DiagnosticsProperty('group', group))..add(DiagnosticsProperty('regevaScheduledCourseId', regevaScheduledCourseId))..add(DiagnosticsProperty('section', section))..add(DiagnosticsProperty('courseType', courseType));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrolledCourseData&&(identical(other.googleClassroomCode, googleClassroomCode) || other.googleClassroomCode == googleClassroomCode)&&(identical(other.url, url) || other.url == url)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.date, date) || other.date == date)&&(identical(other.group, group) || other.group == group)&&(identical(other.regevaScheduledCourseId, regevaScheduledCourseId) || other.regevaScheduledCourseId == regevaScheduledCourseId)&&(identical(other.section, section) || other.section == section)&&(identical(other.courseType, courseType) || other.courseType == courseType));
}


@override
int get hashCode => Object.hash(runtimeType,googleClassroomCode,url,courseCode,credits,courseName,professor,date,group,regevaScheduledCourseId,section,courseType);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EnrolledCourseData(googleClassroomCode: $googleClassroomCode, url: $url, courseCode: $courseCode, credits: $credits, courseName: $courseName, professor: $professor, date: $date, group: $group, regevaScheduledCourseId: $regevaScheduledCourseId, section: $section, courseType: $courseType)';
}


}

/// @nodoc
abstract mixin class $EnrolledCourseDataCopyWith<$Res>  {
  factory $EnrolledCourseDataCopyWith(EnrolledCourseData value, $Res Function(EnrolledCourseData) _then) = _$EnrolledCourseDataCopyWithImpl;
@useResult
$Res call({
 String? googleClassroomCode, String url, String courseCode, int credits, String courseName, String professor, DateTime date, String group, String regevaScheduledCourseId, String section, CourseType? courseType
});




}
/// @nodoc
class _$EnrolledCourseDataCopyWithImpl<$Res>
    implements $EnrolledCourseDataCopyWith<$Res> {
  _$EnrolledCourseDataCopyWithImpl(this._self, this._then);

  final EnrolledCourseData _self;
  final $Res Function(EnrolledCourseData) _then;

/// Create a copy of EnrolledCourseData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? googleClassroomCode = freezed,Object? url = null,Object? courseCode = null,Object? credits = null,Object? courseName = null,Object? professor = null,Object? date = null,Object? group = null,Object? regevaScheduledCourseId = null,Object? section = null,Object? courseType = freezed,}) {
  return _then(_self.copyWith(
googleClassroomCode: freezed == googleClassroomCode ? _self.googleClassroomCode : googleClassroomCode // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,regevaScheduledCourseId: null == regevaScheduledCourseId ? _self.regevaScheduledCourseId : regevaScheduledCourseId // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,courseType: freezed == courseType ? _self.courseType : courseType // ignore: cast_nullable_to_non_nullable
as CourseType?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnrolledCourseData].
extension EnrolledCourseDataPatterns on EnrolledCourseData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrolledCourseData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrolledCourseData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrolledCourseData value)  $default,){
final _that = this;
switch (_that) {
case _EnrolledCourseData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrolledCourseData value)?  $default,){
final _that = this;
switch (_that) {
case _EnrolledCourseData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? googleClassroomCode,  String url,  String courseCode,  int credits,  String courseName,  String professor,  DateTime date,  String group,  String regevaScheduledCourseId,  String section,  CourseType? courseType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrolledCourseData() when $default != null:
return $default(_that.googleClassroomCode,_that.url,_that.courseCode,_that.credits,_that.courseName,_that.professor,_that.date,_that.group,_that.regevaScheduledCourseId,_that.section,_that.courseType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? googleClassroomCode,  String url,  String courseCode,  int credits,  String courseName,  String professor,  DateTime date,  String group,  String regevaScheduledCourseId,  String section,  CourseType? courseType)  $default,) {final _that = this;
switch (_that) {
case _EnrolledCourseData():
return $default(_that.googleClassroomCode,_that.url,_that.courseCode,_that.credits,_that.courseName,_that.professor,_that.date,_that.group,_that.regevaScheduledCourseId,_that.section,_that.courseType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? googleClassroomCode,  String url,  String courseCode,  int credits,  String courseName,  String professor,  DateTime date,  String group,  String regevaScheduledCourseId,  String section,  CourseType? courseType)?  $default,) {final _that = this;
switch (_that) {
case _EnrolledCourseData() when $default != null:
return $default(_that.googleClassroomCode,_that.url,_that.courseCode,_that.credits,_that.courseName,_that.professor,_that.date,_that.group,_that.regevaScheduledCourseId,_that.section,_that.courseType);case _:
  return null;

}
}

}

/// @nodoc


class _EnrolledCourseData with DiagnosticableTreeMixin implements EnrolledCourseData {
  const _EnrolledCourseData({required this.googleClassroomCode, required this.url, required this.courseCode, required this.credits, required this.courseName, required this.professor, required this.date, required this.group, required this.regevaScheduledCourseId, required this.section, required this.courseType});
  

// required String? Acta,
@override final  String? googleClassroomCode;
// required String? Activo,
// required String Aula,
@override final  String url;
// required int CeroEnActa,
// required String ClaveCurso,
// required String CodCurso,
@override final  String courseCode;
// required int Creditos,
@override final  int credits;
// required int Cupos,
// required String Curso,
@override final  String courseName;
// required int Desaprobados,
// required String Docente,
@override final  String professor;
// required String? EstadoInscripcion,
// required String Fecha,
@override final  DateTime date;
// required String FechaInscripcion,
// required String Grupo,
@override final  String group;
// required int Item,
// required String ItemProg,
@override final  String regevaScheduledCourseId;
// required String Observacion,
// required String Seccion,
@override final  String section;
// required dynamic Sylabus,
// required String TipoCurso,
@override final  CourseType? courseType;

/// Create a copy of EnrolledCourseData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrolledCourseDataCopyWith<_EnrolledCourseData> get copyWith => __$EnrolledCourseDataCopyWithImpl<_EnrolledCourseData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EnrolledCourseData'))
    ..add(DiagnosticsProperty('googleClassroomCode', googleClassroomCode))..add(DiagnosticsProperty('url', url))..add(DiagnosticsProperty('courseCode', courseCode))..add(DiagnosticsProperty('credits', credits))..add(DiagnosticsProperty('courseName', courseName))..add(DiagnosticsProperty('professor', professor))..add(DiagnosticsProperty('date', date))..add(DiagnosticsProperty('group', group))..add(DiagnosticsProperty('regevaScheduledCourseId', regevaScheduledCourseId))..add(DiagnosticsProperty('section', section))..add(DiagnosticsProperty('courseType', courseType));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrolledCourseData&&(identical(other.googleClassroomCode, googleClassroomCode) || other.googleClassroomCode == googleClassroomCode)&&(identical(other.url, url) || other.url == url)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.professor, professor) || other.professor == professor)&&(identical(other.date, date) || other.date == date)&&(identical(other.group, group) || other.group == group)&&(identical(other.regevaScheduledCourseId, regevaScheduledCourseId) || other.regevaScheduledCourseId == regevaScheduledCourseId)&&(identical(other.section, section) || other.section == section)&&(identical(other.courseType, courseType) || other.courseType == courseType));
}


@override
int get hashCode => Object.hash(runtimeType,googleClassroomCode,url,courseCode,credits,courseName,professor,date,group,regevaScheduledCourseId,section,courseType);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EnrolledCourseData(googleClassroomCode: $googleClassroomCode, url: $url, courseCode: $courseCode, credits: $credits, courseName: $courseName, professor: $professor, date: $date, group: $group, regevaScheduledCourseId: $regevaScheduledCourseId, section: $section, courseType: $courseType)';
}


}

/// @nodoc
abstract mixin class _$EnrolledCourseDataCopyWith<$Res> implements $EnrolledCourseDataCopyWith<$Res> {
  factory _$EnrolledCourseDataCopyWith(_EnrolledCourseData value, $Res Function(_EnrolledCourseData) _then) = __$EnrolledCourseDataCopyWithImpl;
@override @useResult
$Res call({
 String? googleClassroomCode, String url, String courseCode, int credits, String courseName, String professor, DateTime date, String group, String regevaScheduledCourseId, String section, CourseType? courseType
});




}
/// @nodoc
class __$EnrolledCourseDataCopyWithImpl<$Res>
    implements _$EnrolledCourseDataCopyWith<$Res> {
  __$EnrolledCourseDataCopyWithImpl(this._self, this._then);

  final _EnrolledCourseData _self;
  final $Res Function(_EnrolledCourseData) _then;

/// Create a copy of EnrolledCourseData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? googleClassroomCode = freezed,Object? url = null,Object? courseCode = null,Object? credits = null,Object? courseName = null,Object? professor = null,Object? date = null,Object? group = null,Object? regevaScheduledCourseId = null,Object? section = null,Object? courseType = freezed,}) {
  return _then(_EnrolledCourseData(
googleClassroomCode: freezed == googleClassroomCode ? _self.googleClassroomCode : googleClassroomCode // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,professor: null == professor ? _self.professor : professor // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,regevaScheduledCourseId: null == regevaScheduledCourseId ? _self.regevaScheduledCourseId : regevaScheduledCourseId // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,courseType: freezed == courseType ? _self.courseType : courseType // ignore: cast_nullable_to_non_nullable
as CourseType?,
  ));
}


}

// dart format on
