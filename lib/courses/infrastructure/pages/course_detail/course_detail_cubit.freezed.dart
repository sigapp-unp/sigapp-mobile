// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailState()';
}


}

/// @nodoc
class $CourseDetailStateCopyWith<$Res>  {
$CourseDetailStateCopyWith(CourseDetailState _, $Res Function(CourseDetailState) __);
}


/// Adds pattern-matching-related methods to [CourseDetailState].
extension CourseDetailStatePatterns on CourseDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CourseDetailEmptyState value)?  empty,TResult Function( CourseDetailReadyState value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CourseDetailEmptyState() when empty != null:
return empty(_that);case CourseDetailReadyState() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CourseDetailEmptyState value)  empty,required TResult Function( CourseDetailReadyState value)  ready,}){
final _that = this;
switch (_that) {
case CourseDetailEmptyState():
return empty(_that);case CourseDetailReadyState():
return ready(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CourseDetailEmptyState value)?  empty,TResult? Function( CourseDetailReadyState value)?  ready,}){
final _that = this;
switch (_that) {
case CourseDetailEmptyState() when empty != null:
return empty(_that);case CourseDetailReadyState() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( EnrolledCourse course,  String regevaScheduledCourseId,  CourseDetailSyllabusState syllabus,  CourseDetailGradesState grades)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CourseDetailEmptyState() when empty != null:
return empty();case CourseDetailReadyState() when ready != null:
return ready(_that.course,_that.regevaScheduledCourseId,_that.syllabus,_that.grades);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( EnrolledCourse course,  String regevaScheduledCourseId,  CourseDetailSyllabusState syllabus,  CourseDetailGradesState grades)  ready,}) {final _that = this;
switch (_that) {
case CourseDetailEmptyState():
return empty();case CourseDetailReadyState():
return ready(_that.course,_that.regevaScheduledCourseId,_that.syllabus,_that.grades);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( EnrolledCourse course,  String regevaScheduledCourseId,  CourseDetailSyllabusState syllabus,  CourseDetailGradesState grades)?  ready,}) {final _that = this;
switch (_that) {
case CourseDetailEmptyState() when empty != null:
return empty();case CourseDetailReadyState() when ready != null:
return ready(_that.course,_that.regevaScheduledCourseId,_that.syllabus,_that.grades);case _:
  return null;

}
}

}

/// @nodoc


class CourseDetailEmptyState implements CourseDetailState {
  const CourseDetailEmptyState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailEmptyState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailState.empty()';
}


}




/// @nodoc


class CourseDetailReadyState implements CourseDetailState {
  const CourseDetailReadyState({required this.course, required this.regevaScheduledCourseId, required this.syllabus, required this.grades});
  

 final  EnrolledCourse course;
 final  String regevaScheduledCourseId;
 final  CourseDetailSyllabusState syllabus;
 final  CourseDetailGradesState grades;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailReadyStateCopyWith<CourseDetailReadyState> get copyWith => _$CourseDetailReadyStateCopyWithImpl<CourseDetailReadyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailReadyState&&(identical(other.course, course) || other.course == course)&&(identical(other.regevaScheduledCourseId, regevaScheduledCourseId) || other.regevaScheduledCourseId == regevaScheduledCourseId)&&(identical(other.syllabus, syllabus) || other.syllabus == syllabus)&&(identical(other.grades, grades) || other.grades == grades));
}


@override
int get hashCode => Object.hash(runtimeType,course,regevaScheduledCourseId,syllabus,grades);

@override
String toString() {
  return 'CourseDetailState.ready(course: $course, regevaScheduledCourseId: $regevaScheduledCourseId, syllabus: $syllabus, grades: $grades)';
}


}

/// @nodoc
abstract mixin class $CourseDetailReadyStateCopyWith<$Res> implements $CourseDetailStateCopyWith<$Res> {
  factory $CourseDetailReadyStateCopyWith(CourseDetailReadyState value, $Res Function(CourseDetailReadyState) _then) = _$CourseDetailReadyStateCopyWithImpl;
@useResult
$Res call({
 EnrolledCourse course, String regevaScheduledCourseId, CourseDetailSyllabusState syllabus, CourseDetailGradesState grades
});


$CourseDetailSyllabusStateCopyWith<$Res> get syllabus;$CourseDetailGradesStateCopyWith<$Res> get grades;

}
/// @nodoc
class _$CourseDetailReadyStateCopyWithImpl<$Res>
    implements $CourseDetailReadyStateCopyWith<$Res> {
  _$CourseDetailReadyStateCopyWithImpl(this._self, this._then);

  final CourseDetailReadyState _self;
  final $Res Function(CourseDetailReadyState) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? course = null,Object? regevaScheduledCourseId = null,Object? syllabus = null,Object? grades = null,}) {
  return _then(CourseDetailReadyState(
course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as EnrolledCourse,regevaScheduledCourseId: null == regevaScheduledCourseId ? _self.regevaScheduledCourseId : regevaScheduledCourseId // ignore: cast_nullable_to_non_nullable
as String,syllabus: null == syllabus ? _self.syllabus : syllabus // ignore: cast_nullable_to_non_nullable
as CourseDetailSyllabusState,grades: null == grades ? _self.grades : grades // ignore: cast_nullable_to_non_nullable
as CourseDetailGradesState,
  ));
}

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseDetailSyllabusStateCopyWith<$Res> get syllabus {
  
  return $CourseDetailSyllabusStateCopyWith<$Res>(_self.syllabus, (value) {
    return _then(_self.copyWith(syllabus: value));
  });
}/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseDetailGradesStateCopyWith<$Res> get grades {
  
  return $CourseDetailGradesStateCopyWith<$Res>(_self.grades, (value) {
    return _then(_self.copyWith(grades: value));
  });
}
}

/// @nodoc
mixin _$CourseDetailSyllabusState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailSyllabusState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailSyllabusState()';
}


}

/// @nodoc
class $CourseDetailSyllabusStateCopyWith<$Res>  {
$CourseDetailSyllabusStateCopyWith(CourseDetailSyllabusState _, $Res Function(CourseDetailSyllabusState) __);
}


/// Adds pattern-matching-related methods to [CourseDetailSyllabusState].
extension CourseDetailSyllabusStatePatterns on CourseDetailSyllabusState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CourseDetailSyllabusStateInitial value)?  initial,TResult Function( CourseDetailSyllabusStateLoading value)?  loading,TResult Function( CourseDetailSyllabusStateLoaded value)?  loaded,TResult Function( CourseDetailSyllabusStateNotFound value)?  notFound,TResult Function( CourseDetailSyllabusStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CourseDetailSyllabusStateInitial() when initial != null:
return initial(_that);case CourseDetailSyllabusStateLoading() when loading != null:
return loading(_that);case CourseDetailSyllabusStateLoaded() when loaded != null:
return loaded(_that);case CourseDetailSyllabusStateNotFound() when notFound != null:
return notFound(_that);case CourseDetailSyllabusStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CourseDetailSyllabusStateInitial value)  initial,required TResult Function( CourseDetailSyllabusStateLoading value)  loading,required TResult Function( CourseDetailSyllabusStateLoaded value)  loaded,required TResult Function( CourseDetailSyllabusStateNotFound value)  notFound,required TResult Function( CourseDetailSyllabusStateError value)  error,}){
final _that = this;
switch (_that) {
case CourseDetailSyllabusStateInitial():
return initial(_that);case CourseDetailSyllabusStateLoading():
return loading(_that);case CourseDetailSyllabusStateLoaded():
return loaded(_that);case CourseDetailSyllabusStateNotFound():
return notFound(_that);case CourseDetailSyllabusStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CourseDetailSyllabusStateInitial value)?  initial,TResult? Function( CourseDetailSyllabusStateLoading value)?  loading,TResult? Function( CourseDetailSyllabusStateLoaded value)?  loaded,TResult? Function( CourseDetailSyllabusStateNotFound value)?  notFound,TResult? Function( CourseDetailSyllabusStateError value)?  error,}){
final _that = this;
switch (_that) {
case CourseDetailSyllabusStateInitial() when initial != null:
return initial(_that);case CourseDetailSyllabusStateLoading() when loading != null:
return loading(_that);case CourseDetailSyllabusStateLoaded() when loaded != null:
return loaded(_that);case CourseDetailSyllabusStateNotFound() when notFound != null:
return notFound(_that);case CourseDetailSyllabusStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( File syllabusFile)?  loaded,TResult Function()?  notFound,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CourseDetailSyllabusStateInitial() when initial != null:
return initial();case CourseDetailSyllabusStateLoading() when loading != null:
return loading();case CourseDetailSyllabusStateLoaded() when loaded != null:
return loaded(_that.syllabusFile);case CourseDetailSyllabusStateNotFound() when notFound != null:
return notFound();case CourseDetailSyllabusStateError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( File syllabusFile)  loaded,required TResult Function()  notFound,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CourseDetailSyllabusStateInitial():
return initial();case CourseDetailSyllabusStateLoading():
return loading();case CourseDetailSyllabusStateLoaded():
return loaded(_that.syllabusFile);case CourseDetailSyllabusStateNotFound():
return notFound();case CourseDetailSyllabusStateError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( File syllabusFile)?  loaded,TResult? Function()?  notFound,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CourseDetailSyllabusStateInitial() when initial != null:
return initial();case CourseDetailSyllabusStateLoading() when loading != null:
return loading();case CourseDetailSyllabusStateLoaded() when loaded != null:
return loaded(_that.syllabusFile);case CourseDetailSyllabusStateNotFound() when notFound != null:
return notFound();case CourseDetailSyllabusStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CourseDetailSyllabusStateInitial implements CourseDetailSyllabusState {
  const CourseDetailSyllabusStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailSyllabusStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailSyllabusState.initial()';
}


}




/// @nodoc


class CourseDetailSyllabusStateLoading implements CourseDetailSyllabusState {
  const CourseDetailSyllabusStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailSyllabusStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailSyllabusState.loading()';
}


}




/// @nodoc


class CourseDetailSyllabusStateLoaded implements CourseDetailSyllabusState {
  const CourseDetailSyllabusStateLoaded(this.syllabusFile);
  

 final  File syllabusFile;

/// Create a copy of CourseDetailSyllabusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailSyllabusStateLoadedCopyWith<CourseDetailSyllabusStateLoaded> get copyWith => _$CourseDetailSyllabusStateLoadedCopyWithImpl<CourseDetailSyllabusStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailSyllabusStateLoaded&&(identical(other.syllabusFile, syllabusFile) || other.syllabusFile == syllabusFile));
}


@override
int get hashCode => Object.hash(runtimeType,syllabusFile);

@override
String toString() {
  return 'CourseDetailSyllabusState.loaded(syllabusFile: $syllabusFile)';
}


}

/// @nodoc
abstract mixin class $CourseDetailSyllabusStateLoadedCopyWith<$Res> implements $CourseDetailSyllabusStateCopyWith<$Res> {
  factory $CourseDetailSyllabusStateLoadedCopyWith(CourseDetailSyllabusStateLoaded value, $Res Function(CourseDetailSyllabusStateLoaded) _then) = _$CourseDetailSyllabusStateLoadedCopyWithImpl;
@useResult
$Res call({
 File syllabusFile
});




}
/// @nodoc
class _$CourseDetailSyllabusStateLoadedCopyWithImpl<$Res>
    implements $CourseDetailSyllabusStateLoadedCopyWith<$Res> {
  _$CourseDetailSyllabusStateLoadedCopyWithImpl(this._self, this._then);

  final CourseDetailSyllabusStateLoaded _self;
  final $Res Function(CourseDetailSyllabusStateLoaded) _then;

/// Create a copy of CourseDetailSyllabusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? syllabusFile = null,}) {
  return _then(CourseDetailSyllabusStateLoaded(
null == syllabusFile ? _self.syllabusFile : syllabusFile // ignore: cast_nullable_to_non_nullable
as File,
  ));
}


}

/// @nodoc


class CourseDetailSyllabusStateNotFound implements CourseDetailSyllabusState {
  const CourseDetailSyllabusStateNotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailSyllabusStateNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailSyllabusState.notFound()';
}


}




/// @nodoc


class CourseDetailSyllabusStateError implements CourseDetailSyllabusState {
  const CourseDetailSyllabusStateError(this.message);
  

 final  String message;

/// Create a copy of CourseDetailSyllabusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailSyllabusStateErrorCopyWith<CourseDetailSyllabusStateError> get copyWith => _$CourseDetailSyllabusStateErrorCopyWithImpl<CourseDetailSyllabusStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailSyllabusStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CourseDetailSyllabusState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CourseDetailSyllabusStateErrorCopyWith<$Res> implements $CourseDetailSyllabusStateCopyWith<$Res> {
  factory $CourseDetailSyllabusStateErrorCopyWith(CourseDetailSyllabusStateError value, $Res Function(CourseDetailSyllabusStateError) _then) = _$CourseDetailSyllabusStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CourseDetailSyllabusStateErrorCopyWithImpl<$Res>
    implements $CourseDetailSyllabusStateErrorCopyWith<$Res> {
  _$CourseDetailSyllabusStateErrorCopyWithImpl(this._self, this._then);

  final CourseDetailSyllabusStateError _self;
  final $Res Function(CourseDetailSyllabusStateError) _then;

/// Create a copy of CourseDetailSyllabusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CourseDetailSyllabusStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CourseDetailGradesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailGradesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailGradesState()';
}


}

/// @nodoc
class $CourseDetailGradesStateCopyWith<$Res>  {
$CourseDetailGradesStateCopyWith(CourseDetailGradesState _, $Res Function(CourseDetailGradesState) __);
}


/// Adds pattern-matching-related methods to [CourseDetailGradesState].
extension CourseDetailGradesStatePatterns on CourseDetailGradesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CourseDetailGradesStateInitial value)?  initial,TResult Function( CourseDetailGradesStateLoading value)?  loading,TResult Function( CourseDetailGradesStateLoaded value)?  loaded,TResult Function( CourseDetailGradesStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CourseDetailGradesStateInitial() when initial != null:
return initial(_that);case CourseDetailGradesStateLoading() when loading != null:
return loading(_that);case CourseDetailGradesStateLoaded() when loaded != null:
return loaded(_that);case CourseDetailGradesStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CourseDetailGradesStateInitial value)  initial,required TResult Function( CourseDetailGradesStateLoading value)  loading,required TResult Function( CourseDetailGradesStateLoaded value)  loaded,required TResult Function( CourseDetailGradesStateError value)  error,}){
final _that = this;
switch (_that) {
case CourseDetailGradesStateInitial():
return initial(_that);case CourseDetailGradesStateLoading():
return loading(_that);case CourseDetailGradesStateLoaded():
return loaded(_that);case CourseDetailGradesStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CourseDetailGradesStateInitial value)?  initial,TResult? Function( CourseDetailGradesStateLoading value)?  loading,TResult? Function( CourseDetailGradesStateLoaded value)?  loaded,TResult? Function( CourseDetailGradesStateError value)?  error,}){
final _that = this;
switch (_that) {
case CourseDetailGradesStateInitial() when initial != null:
return initial(_that);case CourseDetailGradesStateLoading() when loading != null:
return loading(_that);case CourseDetailGradesStateLoaded() when loaded != null:
return loaded(_that);case CourseDetailGradesStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( CourseGradeInfo value)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CourseDetailGradesStateInitial() when initial != null:
return initial();case CourseDetailGradesStateLoading() when loading != null:
return loading();case CourseDetailGradesStateLoaded() when loaded != null:
return loaded(_that.value);case CourseDetailGradesStateError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( CourseGradeInfo value)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CourseDetailGradesStateInitial():
return initial();case CourseDetailGradesStateLoading():
return loading();case CourseDetailGradesStateLoaded():
return loaded(_that.value);case CourseDetailGradesStateError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( CourseGradeInfo value)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CourseDetailGradesStateInitial() when initial != null:
return initial();case CourseDetailGradesStateLoading() when loading != null:
return loading();case CourseDetailGradesStateLoaded() when loaded != null:
return loaded(_that.value);case CourseDetailGradesStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CourseDetailGradesStateInitial implements CourseDetailGradesState {
  const CourseDetailGradesStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailGradesStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailGradesState.initial()';
}


}




/// @nodoc


class CourseDetailGradesStateLoading implements CourseDetailGradesState {
  const CourseDetailGradesStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailGradesStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseDetailGradesState.loading()';
}


}




/// @nodoc


class CourseDetailGradesStateLoaded implements CourseDetailGradesState {
  const CourseDetailGradesStateLoaded(this.value);
  

 final  CourseGradeInfo value;

/// Create a copy of CourseDetailGradesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailGradesStateLoadedCopyWith<CourseDetailGradesStateLoaded> get copyWith => _$CourseDetailGradesStateLoadedCopyWithImpl<CourseDetailGradesStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailGradesStateLoaded&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'CourseDetailGradesState.loaded(value: $value)';
}


}

/// @nodoc
abstract mixin class $CourseDetailGradesStateLoadedCopyWith<$Res> implements $CourseDetailGradesStateCopyWith<$Res> {
  factory $CourseDetailGradesStateLoadedCopyWith(CourseDetailGradesStateLoaded value, $Res Function(CourseDetailGradesStateLoaded) _then) = _$CourseDetailGradesStateLoadedCopyWithImpl;
@useResult
$Res call({
 CourseGradeInfo value
});




}
/// @nodoc
class _$CourseDetailGradesStateLoadedCopyWithImpl<$Res>
    implements $CourseDetailGradesStateLoadedCopyWith<$Res> {
  _$CourseDetailGradesStateLoadedCopyWithImpl(this._self, this._then);

  final CourseDetailGradesStateLoaded _self;
  final $Res Function(CourseDetailGradesStateLoaded) _then;

/// Create a copy of CourseDetailGradesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(CourseDetailGradesStateLoaded(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as CourseGradeInfo,
  ));
}


}

/// @nodoc


class CourseDetailGradesStateError implements CourseDetailGradesState {
  const CourseDetailGradesStateError(this.message);
  

 final  String message;

/// Create a copy of CourseDetailGradesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailGradesStateErrorCopyWith<CourseDetailGradesStateError> get copyWith => _$CourseDetailGradesStateErrorCopyWithImpl<CourseDetailGradesStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailGradesStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CourseDetailGradesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CourseDetailGradesStateErrorCopyWith<$Res> implements $CourseDetailGradesStateCopyWith<$Res> {
  factory $CourseDetailGradesStateErrorCopyWith(CourseDetailGradesStateError value, $Res Function(CourseDetailGradesStateError) _then) = _$CourseDetailGradesStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CourseDetailGradesStateErrorCopyWithImpl<$Res>
    implements $CourseDetailGradesStateErrorCopyWith<$Res> {
  _$CourseDetailGradesStateErrorCopyWithImpl(this._self, this._then);

  final CourseDetailGradesStateError _self;
  final $Res Function(CourseDetailGradesStateError) _then;

/// Create a copy of CourseDetailGradesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CourseDetailGradesStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
