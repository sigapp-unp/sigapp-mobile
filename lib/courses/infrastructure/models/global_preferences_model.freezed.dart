// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GlobalPreferencesModel {

 CourseChainPreferencesModel get courseChain;
/// Create a copy of GlobalPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalPreferencesModelCopyWith<GlobalPreferencesModel> get copyWith => _$GlobalPreferencesModelCopyWithImpl<GlobalPreferencesModel>(this as GlobalPreferencesModel, _$identity);

  /// Serializes this GlobalPreferencesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalPreferencesModel&&(identical(other.courseChain, courseChain) || other.courseChain == courseChain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseChain);

@override
String toString() {
  return 'GlobalPreferencesModel(courseChain: $courseChain)';
}


}

/// @nodoc
abstract mixin class $GlobalPreferencesModelCopyWith<$Res>  {
  factory $GlobalPreferencesModelCopyWith(GlobalPreferencesModel value, $Res Function(GlobalPreferencesModel) _then) = _$GlobalPreferencesModelCopyWithImpl;
@useResult
$Res call({
 CourseChainPreferencesModel courseChain
});


$CourseChainPreferencesModelCopyWith<$Res> get courseChain;

}
/// @nodoc
class _$GlobalPreferencesModelCopyWithImpl<$Res>
    implements $GlobalPreferencesModelCopyWith<$Res> {
  _$GlobalPreferencesModelCopyWithImpl(this._self, this._then);

  final GlobalPreferencesModel _self;
  final $Res Function(GlobalPreferencesModel) _then;

/// Create a copy of GlobalPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseChain = null,}) {
  return _then(_self.copyWith(
courseChain: null == courseChain ? _self.courseChain : courseChain // ignore: cast_nullable_to_non_nullable
as CourseChainPreferencesModel,
  ));
}
/// Create a copy of GlobalPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseChainPreferencesModelCopyWith<$Res> get courseChain {
  
  return $CourseChainPreferencesModelCopyWith<$Res>(_self.courseChain, (value) {
    return _then(_self.copyWith(courseChain: value));
  });
}
}


/// Adds pattern-matching-related methods to [GlobalPreferencesModel].
extension GlobalPreferencesModelPatterns on GlobalPreferencesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalPreferencesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalPreferencesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalPreferencesModel value)  $default,){
final _that = this;
switch (_that) {
case _GlobalPreferencesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalPreferencesModel value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalPreferencesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CourseChainPreferencesModel courseChain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalPreferencesModel() when $default != null:
return $default(_that.courseChain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CourseChainPreferencesModel courseChain)  $default,) {final _that = this;
switch (_that) {
case _GlobalPreferencesModel():
return $default(_that.courseChain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CourseChainPreferencesModel courseChain)?  $default,) {final _that = this;
switch (_that) {
case _GlobalPreferencesModel() when $default != null:
return $default(_that.courseChain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalPreferencesModel implements GlobalPreferencesModel {
  const _GlobalPreferencesModel({this.courseChain = const CourseChainPreferencesModel()});
  factory _GlobalPreferencesModel.fromJson(Map<String, dynamic> json) => _$GlobalPreferencesModelFromJson(json);

@override@JsonKey() final  CourseChainPreferencesModel courseChain;

/// Create a copy of GlobalPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalPreferencesModelCopyWith<_GlobalPreferencesModel> get copyWith => __$GlobalPreferencesModelCopyWithImpl<_GlobalPreferencesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalPreferencesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalPreferencesModel&&(identical(other.courseChain, courseChain) || other.courseChain == courseChain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseChain);

@override
String toString() {
  return 'GlobalPreferencesModel(courseChain: $courseChain)';
}


}

/// @nodoc
abstract mixin class _$GlobalPreferencesModelCopyWith<$Res> implements $GlobalPreferencesModelCopyWith<$Res> {
  factory _$GlobalPreferencesModelCopyWith(_GlobalPreferencesModel value, $Res Function(_GlobalPreferencesModel) _then) = __$GlobalPreferencesModelCopyWithImpl;
@override @useResult
$Res call({
 CourseChainPreferencesModel courseChain
});


@override $CourseChainPreferencesModelCopyWith<$Res> get courseChain;

}
/// @nodoc
class __$GlobalPreferencesModelCopyWithImpl<$Res>
    implements _$GlobalPreferencesModelCopyWith<$Res> {
  __$GlobalPreferencesModelCopyWithImpl(this._self, this._then);

  final _GlobalPreferencesModel _self;
  final $Res Function(_GlobalPreferencesModel) _then;

/// Create a copy of GlobalPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseChain = null,}) {
  return _then(_GlobalPreferencesModel(
courseChain: null == courseChain ? _self.courseChain : courseChain // ignore: cast_nullable_to_non_nullable
as CourseChainPreferencesModel,
  ));
}

/// Create a copy of GlobalPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseChainPreferencesModelCopyWith<$Res> get courseChain {
  
  return $CourseChainPreferencesModelCopyWith<$Res>(_self.courseChain, (value) {
    return _then(_self.copyWith(courseChain: value));
  });
}
}

// dart format on
