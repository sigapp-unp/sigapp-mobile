// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_path_and_method.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiPathAndMethod {

 ApiMethod get method; String get path;
/// Create a copy of ApiPathAndMethod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiPathAndMethodCopyWith<ApiPathAndMethod> get copyWith => _$ApiPathAndMethodCopyWithImpl<ApiPathAndMethod>(this as ApiPathAndMethod, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiPathAndMethod&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,method,path);

@override
String toString() {
  return 'ApiPathAndMethod(method: $method, path: $path)';
}


}

/// @nodoc
abstract mixin class $ApiPathAndMethodCopyWith<$Res>  {
  factory $ApiPathAndMethodCopyWith(ApiPathAndMethod value, $Res Function(ApiPathAndMethod) _then) = _$ApiPathAndMethodCopyWithImpl;
@useResult
$Res call({
 ApiMethod method, String path
});




}
/// @nodoc
class _$ApiPathAndMethodCopyWithImpl<$Res>
    implements $ApiPathAndMethodCopyWith<$Res> {
  _$ApiPathAndMethodCopyWithImpl(this._self, this._then);

  final ApiPathAndMethod _self;
  final $Res Function(ApiPathAndMethod) _then;

/// Create a copy of ApiPathAndMethod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? path = null,}) {
  return _then(_self.copyWith(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ApiMethod,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiPathAndMethod].
extension ApiPathAndMethodPatterns on ApiPathAndMethod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiPathAndMethod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiPathAndMethod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiPathAndMethod value)  $default,){
final _that = this;
switch (_that) {
case _ApiPathAndMethod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiPathAndMethod value)?  $default,){
final _that = this;
switch (_that) {
case _ApiPathAndMethod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiMethod method,  String path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiPathAndMethod() when $default != null:
return $default(_that.method,_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiMethod method,  String path)  $default,) {final _that = this;
switch (_that) {
case _ApiPathAndMethod():
return $default(_that.method,_that.path);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiMethod method,  String path)?  $default,) {final _that = this;
switch (_that) {
case _ApiPathAndMethod() when $default != null:
return $default(_that.method,_that.path);case _:
  return null;

}
}

}

/// @nodoc


class _ApiPathAndMethod implements ApiPathAndMethod {
   _ApiPathAndMethod(this.method, this.path);
  

@override final  ApiMethod method;
@override final  String path;

/// Create a copy of ApiPathAndMethod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiPathAndMethodCopyWith<_ApiPathAndMethod> get copyWith => __$ApiPathAndMethodCopyWithImpl<_ApiPathAndMethod>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiPathAndMethod&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,method,path);

@override
String toString() {
  return 'ApiPathAndMethod(method: $method, path: $path)';
}


}

/// @nodoc
abstract mixin class _$ApiPathAndMethodCopyWith<$Res> implements $ApiPathAndMethodCopyWith<$Res> {
  factory _$ApiPathAndMethodCopyWith(_ApiPathAndMethod value, $Res Function(_ApiPathAndMethod) _then) = __$ApiPathAndMethodCopyWithImpl;
@override @useResult
$Res call({
 ApiMethod method, String path
});




}
/// @nodoc
class __$ApiPathAndMethodCopyWithImpl<$Res>
    implements _$ApiPathAndMethodCopyWith<$Res> {
  __$ApiPathAndMethodCopyWithImpl(this._self, this._then);

  final _ApiPathAndMethod _self;
  final $Res Function(_ApiPathAndMethod) _then;

/// Create a copy of ApiPathAndMethod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? path = null,}) {
  return _then(_ApiPathAndMethod(
null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ApiMethod,null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
