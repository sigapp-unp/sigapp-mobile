// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
