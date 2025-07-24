// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'career_page_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareerPageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareerPageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareerPageState()';
}


}

/// @nodoc
class $CareerPageStateCopyWith<$Res>  {
$CareerPageStateCopyWith(CareerPageState _, $Res Function(CareerPageState) __);
}


/// Adds pattern-matching-related methods to [CareerPageState].
extension CareerPageStatePatterns on CareerPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CareerPageLoadingState value)?  loading,TResult Function( CareerPageSuccessState value)?  success,TResult Function( CareerPageErrorState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CareerPageLoadingState() when loading != null:
return loading(_that);case CareerPageSuccessState() when success != null:
return success(_that);case CareerPageErrorState() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CareerPageLoadingState value)  loading,required TResult Function( CareerPageSuccessState value)  success,required TResult Function( CareerPageErrorState value)  error,}){
final _that = this;
switch (_that) {
case CareerPageLoadingState():
return loading(_that);case CareerPageSuccessState():
return success(_that);case CareerPageErrorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CareerPageLoadingState value)?  loading,TResult? Function( CareerPageSuccessState value)?  success,TResult? Function( CareerPageErrorState value)?  error,}){
final _that = this;
switch (_that) {
case CareerPageLoadingState() when loading != null:
return loading(_that);case CareerPageSuccessState() when success != null:
return success(_that);case CareerPageErrorState() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( ProgramCurriculumProgress programCurriculumProgress,  AcademicReport academicReport)?  success,TResult Function( Object error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CareerPageLoadingState() when loading != null:
return loading();case CareerPageSuccessState() when success != null:
return success(_that.programCurriculumProgress,_that.academicReport);case CareerPageErrorState() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( ProgramCurriculumProgress programCurriculumProgress,  AcademicReport academicReport)  success,required TResult Function( Object error)  error,}) {final _that = this;
switch (_that) {
case CareerPageLoadingState():
return loading();case CareerPageSuccessState():
return success(_that.programCurriculumProgress,_that.academicReport);case CareerPageErrorState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( ProgramCurriculumProgress programCurriculumProgress,  AcademicReport academicReport)?  success,TResult? Function( Object error)?  error,}) {final _that = this;
switch (_that) {
case CareerPageLoadingState() when loading != null:
return loading();case CareerPageSuccessState() when success != null:
return success(_that.programCurriculumProgress,_that.academicReport);case CareerPageErrorState() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class CareerPageLoadingState implements CareerPageState {
  const CareerPageLoadingState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareerPageLoadingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CareerPageState.loading()';
}


}




/// @nodoc


class CareerPageSuccessState implements CareerPageState {
  const CareerPageSuccessState({required this.programCurriculumProgress, required this.academicReport});
  

 final  ProgramCurriculumProgress programCurriculumProgress;
 final  AcademicReport academicReport;

/// Create a copy of CareerPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareerPageSuccessStateCopyWith<CareerPageSuccessState> get copyWith => _$CareerPageSuccessStateCopyWithImpl<CareerPageSuccessState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareerPageSuccessState&&(identical(other.programCurriculumProgress, programCurriculumProgress) || other.programCurriculumProgress == programCurriculumProgress)&&(identical(other.academicReport, academicReport) || other.academicReport == academicReport));
}


@override
int get hashCode => Object.hash(runtimeType,programCurriculumProgress,academicReport);

@override
String toString() {
  return 'CareerPageState.success(programCurriculumProgress: $programCurriculumProgress, academicReport: $academicReport)';
}


}

/// @nodoc
abstract mixin class $CareerPageSuccessStateCopyWith<$Res> implements $CareerPageStateCopyWith<$Res> {
  factory $CareerPageSuccessStateCopyWith(CareerPageSuccessState value, $Res Function(CareerPageSuccessState) _then) = _$CareerPageSuccessStateCopyWithImpl;
@useResult
$Res call({
 ProgramCurriculumProgress programCurriculumProgress, AcademicReport academicReport
});


$AcademicReportCopyWith<$Res> get academicReport;

}
/// @nodoc
class _$CareerPageSuccessStateCopyWithImpl<$Res>
    implements $CareerPageSuccessStateCopyWith<$Res> {
  _$CareerPageSuccessStateCopyWithImpl(this._self, this._then);

  final CareerPageSuccessState _self;
  final $Res Function(CareerPageSuccessState) _then;

/// Create a copy of CareerPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? programCurriculumProgress = null,Object? academicReport = null,}) {
  return _then(CareerPageSuccessState(
programCurriculumProgress: null == programCurriculumProgress ? _self.programCurriculumProgress : programCurriculumProgress // ignore: cast_nullable_to_non_nullable
as ProgramCurriculumProgress,academicReport: null == academicReport ? _self.academicReport : academicReport // ignore: cast_nullable_to_non_nullable
as AcademicReport,
  ));
}

/// Create a copy of CareerPageState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicReportCopyWith<$Res> get academicReport {
  
  return $AcademicReportCopyWith<$Res>(_self.academicReport, (value) {
    return _then(_self.copyWith(academicReport: value));
  });
}
}

/// @nodoc


class CareerPageErrorState implements CareerPageState {
  const CareerPageErrorState(this.error);
  

 final  Object error;

/// Create a copy of CareerPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareerPageErrorStateCopyWith<CareerPageErrorState> get copyWith => _$CareerPageErrorStateCopyWithImpl<CareerPageErrorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareerPageErrorState&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'CareerPageState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $CareerPageErrorStateCopyWith<$Res> implements $CareerPageStateCopyWith<$Res> {
  factory $CareerPageErrorStateCopyWith(CareerPageErrorState value, $Res Function(CareerPageErrorState) _then) = _$CareerPageErrorStateCopyWithImpl;
@useResult
$Res call({
 Object error
});




}
/// @nodoc
class _$CareerPageErrorStateCopyWithImpl<$Res>
    implements $CareerPageErrorStateCopyWith<$Res> {
  _$CareerPageErrorStateCopyWithImpl(this._self, this._then);

  final CareerPageErrorState _self;
  final $Res Function(CareerPageErrorState) _then;

/// Create a copy of CareerPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(CareerPageErrorState(
null == error ? _self.error : error ,
  ));
}


}

// dart format on
