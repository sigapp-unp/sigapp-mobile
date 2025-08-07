// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'semester_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SemesterPreferencesModel {

 List<String> get scheduleHiddenEvents;
/// Create a copy of SemesterPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SemesterPreferencesModelCopyWith<SemesterPreferencesModel> get copyWith => _$SemesterPreferencesModelCopyWithImpl<SemesterPreferencesModel>(this as SemesterPreferencesModel, _$identity);

  /// Serializes this SemesterPreferencesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SemesterPreferencesModel&&const DeepCollectionEquality().equals(other.scheduleHiddenEvents, scheduleHiddenEvents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(scheduleHiddenEvents));

@override
String toString() {
  return 'SemesterPreferencesModel(scheduleHiddenEvents: $scheduleHiddenEvents)';
}


}

/// @nodoc
abstract mixin class $SemesterPreferencesModelCopyWith<$Res>  {
  factory $SemesterPreferencesModelCopyWith(SemesterPreferencesModel value, $Res Function(SemesterPreferencesModel) _then) = _$SemesterPreferencesModelCopyWithImpl;
@useResult
$Res call({
 List<String> scheduleHiddenEvents
});




}
/// @nodoc
class _$SemesterPreferencesModelCopyWithImpl<$Res>
    implements $SemesterPreferencesModelCopyWith<$Res> {
  _$SemesterPreferencesModelCopyWithImpl(this._self, this._then);

  final SemesterPreferencesModel _self;
  final $Res Function(SemesterPreferencesModel) _then;

/// Create a copy of SemesterPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleHiddenEvents = null,}) {
  return _then(_self.copyWith(
scheduleHiddenEvents: null == scheduleHiddenEvents ? _self.scheduleHiddenEvents : scheduleHiddenEvents // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SemesterPreferencesModel].
extension SemesterPreferencesModelPatterns on SemesterPreferencesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SemesterPreferencesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SemesterPreferencesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SemesterPreferencesModel value)  $default,){
final _that = this;
switch (_that) {
case _SemesterPreferencesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SemesterPreferencesModel value)?  $default,){
final _that = this;
switch (_that) {
case _SemesterPreferencesModel() when $default != null:
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
case _SemesterPreferencesModel() when $default != null:
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
case _SemesterPreferencesModel():
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
case _SemesterPreferencesModel() when $default != null:
return $default(_that.scheduleHiddenEvents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SemesterPreferencesModel implements SemesterPreferencesModel {
  const _SemesterPreferencesModel({final  List<String> scheduleHiddenEvents = const []}): _scheduleHiddenEvents = scheduleHiddenEvents;
  factory _SemesterPreferencesModel.fromJson(Map<String, dynamic> json) => _$SemesterPreferencesModelFromJson(json);

 final  List<String> _scheduleHiddenEvents;
@override@JsonKey() List<String> get scheduleHiddenEvents {
  if (_scheduleHiddenEvents is EqualUnmodifiableListView) return _scheduleHiddenEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scheduleHiddenEvents);
}


/// Create a copy of SemesterPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SemesterPreferencesModelCopyWith<_SemesterPreferencesModel> get copyWith => __$SemesterPreferencesModelCopyWithImpl<_SemesterPreferencesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SemesterPreferencesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SemesterPreferencesModel&&const DeepCollectionEquality().equals(other._scheduleHiddenEvents, _scheduleHiddenEvents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_scheduleHiddenEvents));

@override
String toString() {
  return 'SemesterPreferencesModel(scheduleHiddenEvents: $scheduleHiddenEvents)';
}


}

/// @nodoc
abstract mixin class _$SemesterPreferencesModelCopyWith<$Res> implements $SemesterPreferencesModelCopyWith<$Res> {
  factory _$SemesterPreferencesModelCopyWith(_SemesterPreferencesModel value, $Res Function(_SemesterPreferencesModel) _then) = __$SemesterPreferencesModelCopyWithImpl;
@override @useResult
$Res call({
 List<String> scheduleHiddenEvents
});




}
/// @nodoc
class __$SemesterPreferencesModelCopyWithImpl<$Res>
    implements _$SemesterPreferencesModelCopyWith<$Res> {
  __$SemesterPreferencesModelCopyWithImpl(this._self, this._then);

  final _SemesterPreferencesModel _self;
  final $Res Function(_SemesterPreferencesModel) _then;

/// Create a copy of SemesterPreferencesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleHiddenEvents = null,}) {
  return _then(_SemesterPreferencesModel(
scheduleHiddenEvents: null == scheduleHiddenEvents ? _self._scheduleHiddenEvents : scheduleHiddenEvents // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
