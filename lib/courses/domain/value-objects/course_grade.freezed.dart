// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_grade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseGradePreview {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseGradePreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseGradePreview()';
}


}

/// @nodoc
class $CourseGradePreviewCopyWith<$Res>  {
$CourseGradePreviewCopyWith(CourseGradePreview _, $Res Function(CourseGradePreview) __);
}


/// Adds pattern-matching-related methods to [CourseGradePreview].
extension CourseGradePreviewPatterns on CourseGradePreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CourseGradePreviewLoaded value)?  loaded,TResult Function( CourseGradePreviewEmpty value)?  empty,TResult Function( CourseGradePreviewError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CourseGradePreviewLoaded() when loaded != null:
return loaded(_that);case CourseGradePreviewEmpty() when empty != null:
return empty(_that);case CourseGradePreviewError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CourseGradePreviewLoaded value)  loaded,required TResult Function( CourseGradePreviewEmpty value)  empty,required TResult Function( CourseGradePreviewError value)  error,}){
final _that = this;
switch (_that) {
case CourseGradePreviewLoaded():
return loaded(_that);case CourseGradePreviewEmpty():
return empty(_that);case CourseGradePreviewError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CourseGradePreviewLoaded value)?  loaded,TResult? Function( CourseGradePreviewEmpty value)?  empty,TResult? Function( CourseGradePreviewError value)?  error,}){
final _that = this;
switch (_that) {
case CourseGradePreviewLoaded() when loaded != null:
return loaded(_that);case CourseGradePreviewEmpty() when empty != null:
return empty(_that);case CourseGradePreviewError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CourseGradeValue value)?  loaded,TResult Function()?  empty,TResult Function( dynamic error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CourseGradePreviewLoaded() when loaded != null:
return loaded(_that.value);case CourseGradePreviewEmpty() when empty != null:
return empty();case CourseGradePreviewError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CourseGradeValue value)  loaded,required TResult Function()  empty,required TResult Function( dynamic error)  error,}) {final _that = this;
switch (_that) {
case CourseGradePreviewLoaded():
return loaded(_that.value);case CourseGradePreviewEmpty():
return empty();case CourseGradePreviewError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CourseGradeValue value)?  loaded,TResult? Function()?  empty,TResult? Function( dynamic error)?  error,}) {final _that = this;
switch (_that) {
case CourseGradePreviewLoaded() when loaded != null:
return loaded(_that.value);case CourseGradePreviewEmpty() when empty != null:
return empty();case CourseGradePreviewError() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class CourseGradePreviewLoaded implements CourseGradePreview {
   CourseGradePreviewLoaded(this.value);
  

 final  CourseGradeValue value;

/// Create a copy of CourseGradePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseGradePreviewLoadedCopyWith<CourseGradePreviewLoaded> get copyWith => _$CourseGradePreviewLoadedCopyWithImpl<CourseGradePreviewLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseGradePreviewLoaded&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'CourseGradePreview.loaded(value: $value)';
}


}

/// @nodoc
abstract mixin class $CourseGradePreviewLoadedCopyWith<$Res> implements $CourseGradePreviewCopyWith<$Res> {
  factory $CourseGradePreviewLoadedCopyWith(CourseGradePreviewLoaded value, $Res Function(CourseGradePreviewLoaded) _then) = _$CourseGradePreviewLoadedCopyWithImpl;
@useResult
$Res call({
 CourseGradeValue value
});




}
/// @nodoc
class _$CourseGradePreviewLoadedCopyWithImpl<$Res>
    implements $CourseGradePreviewLoadedCopyWith<$Res> {
  _$CourseGradePreviewLoadedCopyWithImpl(this._self, this._then);

  final CourseGradePreviewLoaded _self;
  final $Res Function(CourseGradePreviewLoaded) _then;

/// Create a copy of CourseGradePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(CourseGradePreviewLoaded(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as CourseGradeValue,
  ));
}


}

/// @nodoc


class CourseGradePreviewEmpty implements CourseGradePreview {
   CourseGradePreviewEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseGradePreviewEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CourseGradePreview.empty()';
}


}




/// @nodoc


class CourseGradePreviewError implements CourseGradePreview {
   CourseGradePreviewError(this.error);
  

 final  dynamic error;

/// Create a copy of CourseGradePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseGradePreviewErrorCopyWith<CourseGradePreviewError> get copyWith => _$CourseGradePreviewErrorCopyWithImpl<CourseGradePreviewError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseGradePreviewError&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'CourseGradePreview.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $CourseGradePreviewErrorCopyWith<$Res> implements $CourseGradePreviewCopyWith<$Res> {
  factory $CourseGradePreviewErrorCopyWith(CourseGradePreviewError value, $Res Function(CourseGradePreviewError) _then) = _$CourseGradePreviewErrorCopyWithImpl;
@useResult
$Res call({
 dynamic error
});




}
/// @nodoc
class _$CourseGradePreviewErrorCopyWithImpl<$Res>
    implements $CourseGradePreviewErrorCopyWith<$Res> {
  _$CourseGradePreviewErrorCopyWithImpl(this._self, this._then);

  final CourseGradePreviewError _self;
  final $Res Function(CourseGradePreviewError) _then;

/// Create a copy of CourseGradePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(CourseGradePreviewError(
freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
