// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GlobalPreferences {

 CourseChainPreferences get courseChain;
/// Create a copy of GlobalPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalPreferencesCopyWith<GlobalPreferences> get copyWith => _$GlobalPreferencesCopyWithImpl<GlobalPreferences>(this as GlobalPreferences, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalPreferences&&(identical(other.courseChain, courseChain) || other.courseChain == courseChain));
}


@override
int get hashCode => Object.hash(runtimeType,courseChain);

@override
String toString() {
  return 'GlobalPreferences(courseChain: $courseChain)';
}


}

/// @nodoc
abstract mixin class $GlobalPreferencesCopyWith<$Res>  {
  factory $GlobalPreferencesCopyWith(GlobalPreferences value, $Res Function(GlobalPreferences) _then) = _$GlobalPreferencesCopyWithImpl;
@useResult
$Res call({
 CourseChainPreferences courseChain
});


$CourseChainPreferencesCopyWith<$Res> get courseChain;

}
/// @nodoc
class _$GlobalPreferencesCopyWithImpl<$Res>
    implements $GlobalPreferencesCopyWith<$Res> {
  _$GlobalPreferencesCopyWithImpl(this._self, this._then);

  final GlobalPreferences _self;
  final $Res Function(GlobalPreferences) _then;

/// Create a copy of GlobalPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseChain = null,}) {
  return _then(_self.copyWith(
courseChain: null == courseChain ? _self.courseChain : courseChain // ignore: cast_nullable_to_non_nullable
as CourseChainPreferences,
  ));
}
/// Create a copy of GlobalPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseChainPreferencesCopyWith<$Res> get courseChain {
  
  return $CourseChainPreferencesCopyWith<$Res>(_self.courseChain, (value) {
    return _then(_self.copyWith(courseChain: value));
  });
}
}


/// Adds pattern-matching-related methods to [GlobalPreferences].
extension GlobalPreferencesPatterns on GlobalPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalPreferences value)  $default,){
final _that = this;
switch (_that) {
case _GlobalPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CourseChainPreferences courseChain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalPreferences() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CourseChainPreferences courseChain)  $default,) {final _that = this;
switch (_that) {
case _GlobalPreferences():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CourseChainPreferences courseChain)?  $default,) {final _that = this;
switch (_that) {
case _GlobalPreferences() when $default != null:
return $default(_that.courseChain);case _:
  return null;

}
}

}

/// @nodoc


class _GlobalPreferences implements GlobalPreferences {
   _GlobalPreferences({required this.courseChain});
  

@override final  CourseChainPreferences courseChain;

/// Create a copy of GlobalPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalPreferencesCopyWith<_GlobalPreferences> get copyWith => __$GlobalPreferencesCopyWithImpl<_GlobalPreferences>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalPreferences&&(identical(other.courseChain, courseChain) || other.courseChain == courseChain));
}


@override
int get hashCode => Object.hash(runtimeType,courseChain);

@override
String toString() {
  return 'GlobalPreferences(courseChain: $courseChain)';
}


}

/// @nodoc
abstract mixin class _$GlobalPreferencesCopyWith<$Res> implements $GlobalPreferencesCopyWith<$Res> {
  factory _$GlobalPreferencesCopyWith(_GlobalPreferences value, $Res Function(_GlobalPreferences) _then) = __$GlobalPreferencesCopyWithImpl;
@override @useResult
$Res call({
 CourseChainPreferences courseChain
});


@override $CourseChainPreferencesCopyWith<$Res> get courseChain;

}
/// @nodoc
class __$GlobalPreferencesCopyWithImpl<$Res>
    implements _$GlobalPreferencesCopyWith<$Res> {
  __$GlobalPreferencesCopyWithImpl(this._self, this._then);

  final _GlobalPreferences _self;
  final $Res Function(_GlobalPreferences) _then;

/// Create a copy of GlobalPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseChain = null,}) {
  return _then(_GlobalPreferences(
courseChain: null == courseChain ? _self.courseChain : courseChain // ignore: cast_nullable_to_non_nullable
as CourseChainPreferences,
  ));
}

/// Create a copy of GlobalPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseChainPreferencesCopyWith<$Res> get courseChain {
  
  return $CourseChainPreferencesCopyWith<$Res>(_self.courseChain, (value) {
    return _then(_self.copyWith(courseChain: value));
  });
}
}

// dart format on
