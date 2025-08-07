// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'semester_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SemesterPreferences {

 List<String> get scheduleHiddenEvents;
/// Create a copy of SemesterPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SemesterPreferencesCopyWith<SemesterPreferences> get copyWith => _$SemesterPreferencesCopyWithImpl<SemesterPreferences>(this as SemesterPreferences, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SemesterPreferences&&const DeepCollectionEquality().equals(other.scheduleHiddenEvents, scheduleHiddenEvents));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(scheduleHiddenEvents));

@override
String toString() {
  return 'SemesterPreferences(scheduleHiddenEvents: $scheduleHiddenEvents)';
}


}

/// @nodoc
abstract mixin class $SemesterPreferencesCopyWith<$Res>  {
  factory $SemesterPreferencesCopyWith(SemesterPreferences value, $Res Function(SemesterPreferences) _then) = _$SemesterPreferencesCopyWithImpl;
@useResult
$Res call({
 List<String> scheduleHiddenEvents
});




}
/// @nodoc
class _$SemesterPreferencesCopyWithImpl<$Res>
    implements $SemesterPreferencesCopyWith<$Res> {
  _$SemesterPreferencesCopyWithImpl(this._self, this._then);

  final SemesterPreferences _self;
  final $Res Function(SemesterPreferences) _then;

/// Create a copy of SemesterPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleHiddenEvents = null,}) {
  return _then(_self.copyWith(
scheduleHiddenEvents: null == scheduleHiddenEvents ? _self.scheduleHiddenEvents : scheduleHiddenEvents // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SemesterPreferences].
extension SemesterPreferencesPatterns on SemesterPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SemesterPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SemesterPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SemesterPreferences value)  $default,){
final _that = this;
switch (_that) {
case _SemesterPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SemesterPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _SemesterPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> scheduleHiddenEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SemesterPreferences() when $default != null:
return $default(_that.scheduleHiddenEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> scheduleHiddenEvents)  $default,) {final _that = this;
switch (_that) {
case _SemesterPreferences():
return $default(_that.scheduleHiddenEvents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> scheduleHiddenEvents)?  $default,) {final _that = this;
switch (_that) {
case _SemesterPreferences() when $default != null:
return $default(_that.scheduleHiddenEvents);case _:
  return null;

}
}

}

/// @nodoc


class _SemesterPreferences implements SemesterPreferences {
   _SemesterPreferences({required final  List<String> scheduleHiddenEvents}): _scheduleHiddenEvents = scheduleHiddenEvents;
  

 final  List<String> _scheduleHiddenEvents;
@override List<String> get scheduleHiddenEvents {
  if (_scheduleHiddenEvents is EqualUnmodifiableListView) return _scheduleHiddenEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scheduleHiddenEvents);
}


/// Create a copy of SemesterPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SemesterPreferencesCopyWith<_SemesterPreferences> get copyWith => __$SemesterPreferencesCopyWithImpl<_SemesterPreferences>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SemesterPreferences&&const DeepCollectionEquality().equals(other._scheduleHiddenEvents, _scheduleHiddenEvents));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_scheduleHiddenEvents));

@override
String toString() {
  return 'SemesterPreferences(scheduleHiddenEvents: $scheduleHiddenEvents)';
}


}

/// @nodoc
abstract mixin class _$SemesterPreferencesCopyWith<$Res> implements $SemesterPreferencesCopyWith<$Res> {
  factory _$SemesterPreferencesCopyWith(_SemesterPreferences value, $Res Function(_SemesterPreferences) _then) = __$SemesterPreferencesCopyWithImpl;
@override @useResult
$Res call({
 List<String> scheduleHiddenEvents
});




}
/// @nodoc
class __$SemesterPreferencesCopyWithImpl<$Res>
    implements _$SemesterPreferencesCopyWith<$Res> {
  __$SemesterPreferencesCopyWithImpl(this._self, this._then);

  final _SemesterPreferences _self;
  final $Res Function(_SemesterPreferences) _then;

/// Create a copy of SemesterPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleHiddenEvents = null,}) {
  return _then(_SemesterPreferences(
scheduleHiddenEvents: null == scheduleHiddenEvents ? _self._scheduleHiddenEvents : scheduleHiddenEvents // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
