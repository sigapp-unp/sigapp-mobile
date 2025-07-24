// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrolled_courses_page_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnrolledCoursesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrolledCoursesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnrolledCoursesState()';
}


}

/// @nodoc
class $EnrolledCoursesStateCopyWith<$Res>  {
$EnrolledCoursesStateCopyWith(EnrolledCoursesState _, $Res Function(EnrolledCoursesState) __);
}


/// Adds pattern-matching-related methods to [EnrolledCoursesState].
extension EnrolledCoursesStatePatterns on EnrolledCoursesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EnrolledCoursesLoadingState value)?  loading,TResult Function( EnrolledCoursesSuccessState value)?  success,TResult Function( EnrolledCoursesErrorState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EnrolledCoursesLoadingState() when loading != null:
return loading(_that);case EnrolledCoursesSuccessState() when success != null:
return success(_that);case EnrolledCoursesErrorState() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EnrolledCoursesLoadingState value)  loading,required TResult Function( EnrolledCoursesSuccessState value)  success,required TResult Function( EnrolledCoursesErrorState value)  error,}){
final _that = this;
switch (_that) {
case EnrolledCoursesLoadingState():
return loading(_that);case EnrolledCoursesSuccessState():
return success(_that);case EnrolledCoursesErrorState():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EnrolledCoursesLoadingState value)?  loading,TResult? Function( EnrolledCoursesSuccessState value)?  success,TResult? Function( EnrolledCoursesErrorState value)?  error,}){
final _that = this;
switch (_that) {
case EnrolledCoursesLoadingState() when loading != null:
return loading(_that);case EnrolledCoursesSuccessState() when success != null:
return success(_that);case EnrolledCoursesErrorState() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<EnrolledCourse> value)?  success,TResult Function( Object error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EnrolledCoursesLoadingState() when loading != null:
return loading();case EnrolledCoursesSuccessState() when success != null:
return success(_that.value);case EnrolledCoursesErrorState() when error != null:
return error(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<EnrolledCourse> value)  success,required TResult Function( Object error)  error,}) {final _that = this;
switch (_that) {
case EnrolledCoursesLoadingState():
return loading();case EnrolledCoursesSuccessState():
return success(_that.value);case EnrolledCoursesErrorState():
return error(_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<EnrolledCourse> value)?  success,TResult? Function( Object error)?  error,}) {final _that = this;
switch (_that) {
case EnrolledCoursesLoadingState() when loading != null:
return loading();case EnrolledCoursesSuccessState() when success != null:
return success(_that.value);case EnrolledCoursesErrorState() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class EnrolledCoursesLoadingState implements EnrolledCoursesState {
  const EnrolledCoursesLoadingState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrolledCoursesLoadingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnrolledCoursesState.loading()';
}


}




/// @nodoc


class EnrolledCoursesSuccessState implements EnrolledCoursesState {
  const EnrolledCoursesSuccessState({required final  List<EnrolledCourse> value}): _value = value;
  

 final  List<EnrolledCourse> _value;
 List<EnrolledCourse> get value {
  if (_value is EqualUnmodifiableListView) return _value;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_value);
}


/// Create a copy of EnrolledCoursesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrolledCoursesSuccessStateCopyWith<EnrolledCoursesSuccessState> get copyWith => _$EnrolledCoursesSuccessStateCopyWithImpl<EnrolledCoursesSuccessState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrolledCoursesSuccessState&&const DeepCollectionEquality().equals(other._value, _value));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_value));

@override
String toString() {
  return 'EnrolledCoursesState.success(value: $value)';
}


}

/// @nodoc
abstract mixin class $EnrolledCoursesSuccessStateCopyWith<$Res> implements $EnrolledCoursesStateCopyWith<$Res> {
  factory $EnrolledCoursesSuccessStateCopyWith(EnrolledCoursesSuccessState value, $Res Function(EnrolledCoursesSuccessState) _then) = _$EnrolledCoursesSuccessStateCopyWithImpl;
@useResult
$Res call({
 List<EnrolledCourse> value
});




}
/// @nodoc
class _$EnrolledCoursesSuccessStateCopyWithImpl<$Res>
    implements $EnrolledCoursesSuccessStateCopyWith<$Res> {
  _$EnrolledCoursesSuccessStateCopyWithImpl(this._self, this._then);

  final EnrolledCoursesSuccessState _self;
  final $Res Function(EnrolledCoursesSuccessState) _then;

/// Create a copy of EnrolledCoursesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(EnrolledCoursesSuccessState(
value: null == value ? _self._value : value // ignore: cast_nullable_to_non_nullable
as List<EnrolledCourse>,
  ));
}


}

/// @nodoc


class EnrolledCoursesErrorState implements EnrolledCoursesState {
  const EnrolledCoursesErrorState(this.error);
  

 final  Object error;

/// Create a copy of EnrolledCoursesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrolledCoursesErrorStateCopyWith<EnrolledCoursesErrorState> get copyWith => _$EnrolledCoursesErrorStateCopyWithImpl<EnrolledCoursesErrorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrolledCoursesErrorState&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'EnrolledCoursesState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $EnrolledCoursesErrorStateCopyWith<$Res> implements $EnrolledCoursesStateCopyWith<$Res> {
  factory $EnrolledCoursesErrorStateCopyWith(EnrolledCoursesErrorState value, $Res Function(EnrolledCoursesErrorState) _then) = _$EnrolledCoursesErrorStateCopyWithImpl;
@useResult
$Res call({
 Object error
});




}
/// @nodoc
class _$EnrolledCoursesErrorStateCopyWithImpl<$Res>
    implements $EnrolledCoursesErrorStateCopyWith<$Res> {
  _$EnrolledCoursesErrorStateCopyWithImpl(this._self, this._then);

  final EnrolledCoursesErrorState _self;
  final $Res Function(EnrolledCoursesErrorState) _then;

/// Create a copy of EnrolledCoursesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(EnrolledCoursesErrorState(
null == error ? _self.error : error ,
  ));
}


}

/// @nodoc
mixin _$EnrolledCoursesPageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrolledCoursesPageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnrolledCoursesPageState()';
}


}

/// @nodoc
class $EnrolledCoursesPageStateCopyWith<$Res>  {
$EnrolledCoursesPageStateCopyWith(EnrolledCoursesPageState _, $Res Function(EnrolledCoursesPageState) __);
}


/// Adds pattern-matching-related methods to [EnrolledCoursesPageState].
extension EnrolledCoursesPageStatePatterns on EnrolledCoursesPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CoursesPageLoadingState value)?  loading,TResult Function( CoursesPageSuccessState value)?  success,TResult Function( CoursesPageErrorState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CoursesPageLoadingState() when loading != null:
return loading(_that);case CoursesPageSuccessState() when success != null:
return success(_that);case CoursesPageErrorState() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CoursesPageLoadingState value)  loading,required TResult Function( CoursesPageSuccessState value)  success,required TResult Function( CoursesPageErrorState value)  error,}){
final _that = this;
switch (_that) {
case CoursesPageLoadingState():
return loading(_that);case CoursesPageSuccessState():
return success(_that);case CoursesPageErrorState():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CoursesPageLoadingState value)?  loading,TResult? Function( CoursesPageSuccessState value)?  success,TResult? Function( CoursesPageErrorState value)?  error,}){
final _that = this;
switch (_that) {
case CoursesPageLoadingState() when loading != null:
return loading(_that);case CoursesPageSuccessState() when success != null:
return success(_that);case CoursesPageErrorState() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( AcademicReport academicReport,  SemesterContext semesterContext,  ScheduledTermIdentifier selectedSemester,  EnrolledCoursesState enrolledCourses)?  success,TResult Function( Object error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CoursesPageLoadingState() when loading != null:
return loading();case CoursesPageSuccessState() when success != null:
return success(_that.academicReport,_that.semesterContext,_that.selectedSemester,_that.enrolledCourses);case CoursesPageErrorState() when error != null:
return error(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( AcademicReport academicReport,  SemesterContext semesterContext,  ScheduledTermIdentifier selectedSemester,  EnrolledCoursesState enrolledCourses)  success,required TResult Function( Object error)  error,}) {final _that = this;
switch (_that) {
case CoursesPageLoadingState():
return loading();case CoursesPageSuccessState():
return success(_that.academicReport,_that.semesterContext,_that.selectedSemester,_that.enrolledCourses);case CoursesPageErrorState():
return error(_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( AcademicReport academicReport,  SemesterContext semesterContext,  ScheduledTermIdentifier selectedSemester,  EnrolledCoursesState enrolledCourses)?  success,TResult? Function( Object error)?  error,}) {final _that = this;
switch (_that) {
case CoursesPageLoadingState() when loading != null:
return loading();case CoursesPageSuccessState() when success != null:
return success(_that.academicReport,_that.semesterContext,_that.selectedSemester,_that.enrolledCourses);case CoursesPageErrorState() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class CoursesPageLoadingState implements EnrolledCoursesPageState {
  const CoursesPageLoadingState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoursesPageLoadingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnrolledCoursesPageState.loading()';
}


}




/// @nodoc


class CoursesPageSuccessState implements EnrolledCoursesPageState {
  const CoursesPageSuccessState({required this.academicReport, required this.semesterContext, required this.selectedSemester, required this.enrolledCourses});
  

 final  AcademicReport academicReport;
 final  SemesterContext semesterContext;
 final  ScheduledTermIdentifier selectedSemester;
 final  EnrolledCoursesState enrolledCourses;

/// Create a copy of EnrolledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoursesPageSuccessStateCopyWith<CoursesPageSuccessState> get copyWith => _$CoursesPageSuccessStateCopyWithImpl<CoursesPageSuccessState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoursesPageSuccessState&&(identical(other.academicReport, academicReport) || other.academicReport == academicReport)&&(identical(other.semesterContext, semesterContext) || other.semesterContext == semesterContext)&&(identical(other.selectedSemester, selectedSemester) || other.selectedSemester == selectedSemester)&&(identical(other.enrolledCourses, enrolledCourses) || other.enrolledCourses == enrolledCourses));
}


@override
int get hashCode => Object.hash(runtimeType,academicReport,semesterContext,selectedSemester,enrolledCourses);

@override
String toString() {
  return 'EnrolledCoursesPageState.success(academicReport: $academicReport, semesterContext: $semesterContext, selectedSemester: $selectedSemester, enrolledCourses: $enrolledCourses)';
}


}

/// @nodoc
abstract mixin class $CoursesPageSuccessStateCopyWith<$Res> implements $EnrolledCoursesPageStateCopyWith<$Res> {
  factory $CoursesPageSuccessStateCopyWith(CoursesPageSuccessState value, $Res Function(CoursesPageSuccessState) _then) = _$CoursesPageSuccessStateCopyWithImpl;
@useResult
$Res call({
 AcademicReport academicReport, SemesterContext semesterContext, ScheduledTermIdentifier selectedSemester, EnrolledCoursesState enrolledCourses
});


$AcademicReportCopyWith<$Res> get academicReport;$EnrolledCoursesStateCopyWith<$Res> get enrolledCourses;

}
/// @nodoc
class _$CoursesPageSuccessStateCopyWithImpl<$Res>
    implements $CoursesPageSuccessStateCopyWith<$Res> {
  _$CoursesPageSuccessStateCopyWithImpl(this._self, this._then);

  final CoursesPageSuccessState _self;
  final $Res Function(CoursesPageSuccessState) _then;

/// Create a copy of EnrolledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? academicReport = null,Object? semesterContext = null,Object? selectedSemester = null,Object? enrolledCourses = null,}) {
  return _then(CoursesPageSuccessState(
academicReport: null == academicReport ? _self.academicReport : academicReport // ignore: cast_nullable_to_non_nullable
as AcademicReport,semesterContext: null == semesterContext ? _self.semesterContext : semesterContext // ignore: cast_nullable_to_non_nullable
as SemesterContext,selectedSemester: null == selectedSemester ? _self.selectedSemester : selectedSemester // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier,enrolledCourses: null == enrolledCourses ? _self.enrolledCourses : enrolledCourses // ignore: cast_nullable_to_non_nullable
as EnrolledCoursesState,
  ));
}

/// Create a copy of EnrolledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicReportCopyWith<$Res> get academicReport {
  
  return $AcademicReportCopyWith<$Res>(_self.academicReport, (value) {
    return _then(_self.copyWith(academicReport: value));
  });
}/// Create a copy of EnrolledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnrolledCoursesStateCopyWith<$Res> get enrolledCourses {
  
  return $EnrolledCoursesStateCopyWith<$Res>(_self.enrolledCourses, (value) {
    return _then(_self.copyWith(enrolledCourses: value));
  });
}
}

/// @nodoc


class CoursesPageErrorState implements EnrolledCoursesPageState {
  const CoursesPageErrorState(this.error);
  

 final  Object error;

/// Create a copy of EnrolledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoursesPageErrorStateCopyWith<CoursesPageErrorState> get copyWith => _$CoursesPageErrorStateCopyWithImpl<CoursesPageErrorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoursesPageErrorState&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'EnrolledCoursesPageState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $CoursesPageErrorStateCopyWith<$Res> implements $EnrolledCoursesPageStateCopyWith<$Res> {
  factory $CoursesPageErrorStateCopyWith(CoursesPageErrorState value, $Res Function(CoursesPageErrorState) _then) = _$CoursesPageErrorStateCopyWithImpl;
@useResult
$Res call({
 Object error
});




}
/// @nodoc
class _$CoursesPageErrorStateCopyWithImpl<$Res>
    implements $CoursesPageErrorStateCopyWith<$Res> {
  _$CoursesPageErrorStateCopyWithImpl(this._self, this._then);

  final CoursesPageErrorState _self;
  final $Res Function(CoursesPageErrorState) _then;

/// Create a copy of EnrolledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(CoursesPageErrorState(
null == error ? _self.error : error ,
  ));
}


}

// dart format on
