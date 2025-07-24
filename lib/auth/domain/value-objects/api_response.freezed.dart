// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiResponse {

 ApiPathAndMethod get pathAndMethod; int get statusCode; Map<String, List<String>> get headers; String? get messageLevel1; String? get messageLevel2; String? get messageLevel3;
/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiResponseCopyWith<ApiResponse> get copyWith => _$ApiResponseCopyWithImpl<ApiResponse>(this as ApiResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResponse&&(identical(other.pathAndMethod, pathAndMethod) || other.pathAndMethod == pathAndMethod)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other.headers, headers)&&(identical(other.messageLevel1, messageLevel1) || other.messageLevel1 == messageLevel1)&&(identical(other.messageLevel2, messageLevel2) || other.messageLevel2 == messageLevel2)&&(identical(other.messageLevel3, messageLevel3) || other.messageLevel3 == messageLevel3));
}


@override
int get hashCode => Object.hash(runtimeType,pathAndMethod,statusCode,const DeepCollectionEquality().hash(headers),messageLevel1,messageLevel2,messageLevel3);

@override
String toString() {
  return 'ApiResponse(pathAndMethod: $pathAndMethod, statusCode: $statusCode, headers: $headers, messageLevel1: $messageLevel1, messageLevel2: $messageLevel2, messageLevel3: $messageLevel3)';
}


}

/// @nodoc
abstract mixin class $ApiResponseCopyWith<$Res>  {
  factory $ApiResponseCopyWith(ApiResponse value, $Res Function(ApiResponse) _then) = _$ApiResponseCopyWithImpl;
@useResult
$Res call({
 ApiPathAndMethod pathAndMethod, int statusCode, Map<String, List<String>> headers, String? messageLevel1, String? messageLevel2, String? messageLevel3
});


$ApiPathAndMethodCopyWith<$Res> get pathAndMethod;

}
/// @nodoc
class _$ApiResponseCopyWithImpl<$Res>
    implements $ApiResponseCopyWith<$Res> {
  _$ApiResponseCopyWithImpl(this._self, this._then);

  final ApiResponse _self;
  final $Res Function(ApiResponse) _then;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pathAndMethod = null,Object? statusCode = null,Object? headers = null,Object? messageLevel1 = freezed,Object? messageLevel2 = freezed,Object? messageLevel3 = freezed,}) {
  return _then(_self.copyWith(
pathAndMethod: null == pathAndMethod ? _self.pathAndMethod : pathAndMethod // ignore: cast_nullable_to_non_nullable
as ApiPathAndMethod,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,messageLevel1: freezed == messageLevel1 ? _self.messageLevel1 : messageLevel1 // ignore: cast_nullable_to_non_nullable
as String?,messageLevel2: freezed == messageLevel2 ? _self.messageLevel2 : messageLevel2 // ignore: cast_nullable_to_non_nullable
as String?,messageLevel3: freezed == messageLevel3 ? _self.messageLevel3 : messageLevel3 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiPathAndMethodCopyWith<$Res> get pathAndMethod {
  
  return $ApiPathAndMethodCopyWith<$Res>(_self.pathAndMethod, (value) {
    return _then(_self.copyWith(pathAndMethod: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApiResponse].
extension ApiResponsePatterns on ApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _ApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiPathAndMethod pathAndMethod,  int statusCode,  Map<String, List<String>> headers,  String? messageLevel1,  String? messageLevel2,  String? messageLevel3)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiResponse() when $default != null:
return $default(_that.pathAndMethod,_that.statusCode,_that.headers,_that.messageLevel1,_that.messageLevel2,_that.messageLevel3);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiPathAndMethod pathAndMethod,  int statusCode,  Map<String, List<String>> headers,  String? messageLevel1,  String? messageLevel2,  String? messageLevel3)  $default,) {final _that = this;
switch (_that) {
case _ApiResponse():
return $default(_that.pathAndMethod,_that.statusCode,_that.headers,_that.messageLevel1,_that.messageLevel2,_that.messageLevel3);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiPathAndMethod pathAndMethod,  int statusCode,  Map<String, List<String>> headers,  String? messageLevel1,  String? messageLevel2,  String? messageLevel3)?  $default,) {final _that = this;
switch (_that) {
case _ApiResponse() when $default != null:
return $default(_that.pathAndMethod,_that.statusCode,_that.headers,_that.messageLevel1,_that.messageLevel2,_that.messageLevel3);case _:
  return null;

}
}

}

/// @nodoc


class _ApiResponse implements ApiResponse {
   _ApiResponse({required this.pathAndMethod, required this.statusCode, required final  Map<String, List<String>> headers, this.messageLevel1, this.messageLevel2, this.messageLevel3}): _headers = headers;
  

@override final  ApiPathAndMethod pathAndMethod;
@override final  int statusCode;
 final  Map<String, List<String>> _headers;
@override Map<String, List<String>> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}

@override final  String? messageLevel1;
@override final  String? messageLevel2;
@override final  String? messageLevel3;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiResponseCopyWith<_ApiResponse> get copyWith => __$ApiResponseCopyWithImpl<_ApiResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiResponse&&(identical(other.pathAndMethod, pathAndMethod) || other.pathAndMethod == pathAndMethod)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other._headers, _headers)&&(identical(other.messageLevel1, messageLevel1) || other.messageLevel1 == messageLevel1)&&(identical(other.messageLevel2, messageLevel2) || other.messageLevel2 == messageLevel2)&&(identical(other.messageLevel3, messageLevel3) || other.messageLevel3 == messageLevel3));
}


@override
int get hashCode => Object.hash(runtimeType,pathAndMethod,statusCode,const DeepCollectionEquality().hash(_headers),messageLevel1,messageLevel2,messageLevel3);

@override
String toString() {
  return 'ApiResponse(pathAndMethod: $pathAndMethod, statusCode: $statusCode, headers: $headers, messageLevel1: $messageLevel1, messageLevel2: $messageLevel2, messageLevel3: $messageLevel3)';
}


}

/// @nodoc
abstract mixin class _$ApiResponseCopyWith<$Res> implements $ApiResponseCopyWith<$Res> {
  factory _$ApiResponseCopyWith(_ApiResponse value, $Res Function(_ApiResponse) _then) = __$ApiResponseCopyWithImpl;
@override @useResult
$Res call({
 ApiPathAndMethod pathAndMethod, int statusCode, Map<String, List<String>> headers, String? messageLevel1, String? messageLevel2, String? messageLevel3
});


@override $ApiPathAndMethodCopyWith<$Res> get pathAndMethod;

}
/// @nodoc
class __$ApiResponseCopyWithImpl<$Res>
    implements _$ApiResponseCopyWith<$Res> {
  __$ApiResponseCopyWithImpl(this._self, this._then);

  final _ApiResponse _self;
  final $Res Function(_ApiResponse) _then;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pathAndMethod = null,Object? statusCode = null,Object? headers = null,Object? messageLevel1 = freezed,Object? messageLevel2 = freezed,Object? messageLevel3 = freezed,}) {
  return _then(_ApiResponse(
pathAndMethod: null == pathAndMethod ? _self.pathAndMethod : pathAndMethod // ignore: cast_nullable_to_non_nullable
as ApiPathAndMethod,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,messageLevel1: freezed == messageLevel1 ? _self.messageLevel1 : messageLevel1 // ignore: cast_nullable_to_non_nullable
as String?,messageLevel2: freezed == messageLevel2 ? _self.messageLevel2 : messageLevel2 // ignore: cast_nullable_to_non_nullable
as String?,messageLevel3: freezed == messageLevel3 ? _self.messageLevel3 : messageLevel3 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiPathAndMethodCopyWith<$Res> get pathAndMethod {
  
  return $ApiPathAndMethodCopyWith<$Res>(_self.pathAndMethod, (value) {
    return _then(_self.copyWith(pathAndMethod: value));
  });
}
}

// dart format on
