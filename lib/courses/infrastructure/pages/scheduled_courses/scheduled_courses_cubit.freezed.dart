// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_courses_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduledCoursesPageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduledCoursesPageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScheduledCoursesPageState()';
}


}

/// @nodoc
class $ScheduledCoursesPageStateCopyWith<$Res>  {
$ScheduledCoursesPageStateCopyWith(ScheduledCoursesPageState _, $Res Function(ScheduledCoursesPageState) __);
}


/// Adds pattern-matching-related methods to [ScheduledCoursesPageState].
extension ScheduledCoursesPageStatePatterns on ScheduledCoursesPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CoursesPageLoadingState value)?  loading,TResult Function( ScheduledCoursesPageSuccessState value)?  success,TResult Function( CoursesPageErrorState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CoursesPageLoadingState() when loading != null:
return loading(_that);case ScheduledCoursesPageSuccessState() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CoursesPageLoadingState value)  loading,required TResult Function( ScheduledCoursesPageSuccessState value)  success,required TResult Function( CoursesPageErrorState value)  error,}){
final _that = this;
switch (_that) {
case CoursesPageLoadingState():
return loading(_that);case ScheduledCoursesPageSuccessState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CoursesPageLoadingState value)?  loading,TResult? Function( ScheduledCoursesPageSuccessState value)?  success,TResult? Function( CoursesPageErrorState value)?  error,}){
final _that = this;
switch (_that) {
case CoursesPageLoadingState() when loading != null:
return loading(_that);case ScheduledCoursesPageSuccessState() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<ScheduledCourse> scheduledCourses,  List<ScheduledCourse> filteredCourses,  String searchQuery)?  success,TResult Function( Object error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CoursesPageLoadingState() when loading != null:
return loading();case ScheduledCoursesPageSuccessState() when success != null:
return success(_that.scheduledCourses,_that.filteredCourses,_that.searchQuery);case CoursesPageErrorState() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<ScheduledCourse> scheduledCourses,  List<ScheduledCourse> filteredCourses,  String searchQuery)  success,required TResult Function( Object error)  error,}) {final _that = this;
switch (_that) {
case CoursesPageLoadingState():
return loading();case ScheduledCoursesPageSuccessState():
return success(_that.scheduledCourses,_that.filteredCourses,_that.searchQuery);case CoursesPageErrorState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<ScheduledCourse> scheduledCourses,  List<ScheduledCourse> filteredCourses,  String searchQuery)?  success,TResult? Function( Object error)?  error,}) {final _that = this;
switch (_that) {
case CoursesPageLoadingState() when loading != null:
return loading();case ScheduledCoursesPageSuccessState() when success != null:
return success(_that.scheduledCourses,_that.filteredCourses,_that.searchQuery);case CoursesPageErrorState() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class CoursesPageLoadingState implements ScheduledCoursesPageState {
  const CoursesPageLoadingState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoursesPageLoadingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScheduledCoursesPageState.loading()';
}


}




/// @nodoc


class ScheduledCoursesPageSuccessState implements ScheduledCoursesPageState {
  const ScheduledCoursesPageSuccessState({required final  List<ScheduledCourse> scheduledCourses, required final  List<ScheduledCourse> filteredCourses, required this.searchQuery}): _scheduledCourses = scheduledCourses,_filteredCourses = filteredCourses;
  

 final  List<ScheduledCourse> _scheduledCourses;
 List<ScheduledCourse> get scheduledCourses {
  if (_scheduledCourses is EqualUnmodifiableListView) return _scheduledCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scheduledCourses);
}

 final  List<ScheduledCourse> _filteredCourses;
 List<ScheduledCourse> get filteredCourses {
  if (_filteredCourses is EqualUnmodifiableListView) return _filteredCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredCourses);
}

 final  String searchQuery;

/// Create a copy of ScheduledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduledCoursesPageSuccessStateCopyWith<ScheduledCoursesPageSuccessState> get copyWith => _$ScheduledCoursesPageSuccessStateCopyWithImpl<ScheduledCoursesPageSuccessState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduledCoursesPageSuccessState&&const DeepCollectionEquality().equals(other._scheduledCourses, _scheduledCourses)&&const DeepCollectionEquality().equals(other._filteredCourses, _filteredCourses)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_scheduledCourses),const DeepCollectionEquality().hash(_filteredCourses),searchQuery);

@override
String toString() {
  return 'ScheduledCoursesPageState.success(scheduledCourses: $scheduledCourses, filteredCourses: $filteredCourses, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $ScheduledCoursesPageSuccessStateCopyWith<$Res> implements $ScheduledCoursesPageStateCopyWith<$Res> {
  factory $ScheduledCoursesPageSuccessStateCopyWith(ScheduledCoursesPageSuccessState value, $Res Function(ScheduledCoursesPageSuccessState) _then) = _$ScheduledCoursesPageSuccessStateCopyWithImpl;
@useResult
$Res call({
 List<ScheduledCourse> scheduledCourses, List<ScheduledCourse> filteredCourses, String searchQuery
});




}
/// @nodoc
class _$ScheduledCoursesPageSuccessStateCopyWithImpl<$Res>
    implements $ScheduledCoursesPageSuccessStateCopyWith<$Res> {
  _$ScheduledCoursesPageSuccessStateCopyWithImpl(this._self, this._then);

  final ScheduledCoursesPageSuccessState _self;
  final $Res Function(ScheduledCoursesPageSuccessState) _then;

/// Create a copy of ScheduledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? scheduledCourses = null,Object? filteredCourses = null,Object? searchQuery = null,}) {
  return _then(ScheduledCoursesPageSuccessState(
scheduledCourses: null == scheduledCourses ? _self._scheduledCourses : scheduledCourses // ignore: cast_nullable_to_non_nullable
as List<ScheduledCourse>,filteredCourses: null == filteredCourses ? _self._filteredCourses : filteredCourses // ignore: cast_nullable_to_non_nullable
as List<ScheduledCourse>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CoursesPageErrorState implements ScheduledCoursesPageState {
  const CoursesPageErrorState(this.error);
  

 final  Object error;

/// Create a copy of ScheduledCoursesPageState
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
  return 'ScheduledCoursesPageState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $CoursesPageErrorStateCopyWith<$Res> implements $ScheduledCoursesPageStateCopyWith<$Res> {
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

/// Create a copy of ScheduledCoursesPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(CoursesPageErrorState(
null == error ? _self.error : error ,
  ));
}


}

// dart format on
