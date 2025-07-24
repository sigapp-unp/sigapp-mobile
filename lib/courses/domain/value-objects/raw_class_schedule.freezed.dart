// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_class_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawClassSchedule {

 String get startHour; String get endHour; String get monday; String get tuesday; String get wednesday; String get thursday; String get friday; String get saturday;
/// Create a copy of RawClassSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawClassScheduleCopyWith<RawClassSchedule> get copyWith => _$RawClassScheduleCopyWithImpl<RawClassSchedule>(this as RawClassSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawClassSchedule&&(identical(other.startHour, startHour) || other.startHour == startHour)&&(identical(other.endHour, endHour) || other.endHour == endHour)&&(identical(other.monday, monday) || other.monday == monday)&&(identical(other.tuesday, tuesday) || other.tuesday == tuesday)&&(identical(other.wednesday, wednesday) || other.wednesday == wednesday)&&(identical(other.thursday, thursday) || other.thursday == thursday)&&(identical(other.friday, friday) || other.friday == friday)&&(identical(other.saturday, saturday) || other.saturday == saturday));
}


@override
int get hashCode => Object.hash(runtimeType,startHour,endHour,monday,tuesday,wednesday,thursday,friday,saturday);

@override
String toString() {
  return 'RawClassSchedule(startHour: $startHour, endHour: $endHour, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday)';
}


}

/// @nodoc
abstract mixin class $RawClassScheduleCopyWith<$Res>  {
  factory $RawClassScheduleCopyWith(RawClassSchedule value, $Res Function(RawClassSchedule) _then) = _$RawClassScheduleCopyWithImpl;
@useResult
$Res call({
 String startHour, String endHour, String monday, String tuesday, String wednesday, String thursday, String friday, String saturday
});




}
/// @nodoc
class _$RawClassScheduleCopyWithImpl<$Res>
    implements $RawClassScheduleCopyWith<$Res> {
  _$RawClassScheduleCopyWithImpl(this._self, this._then);

  final RawClassSchedule _self;
  final $Res Function(RawClassSchedule) _then;

/// Create a copy of RawClassSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startHour = null,Object? endHour = null,Object? monday = null,Object? tuesday = null,Object? wednesday = null,Object? thursday = null,Object? friday = null,Object? saturday = null,}) {
  return _then(_self.copyWith(
startHour: null == startHour ? _self.startHour : startHour // ignore: cast_nullable_to_non_nullable
as String,endHour: null == endHour ? _self.endHour : endHour // ignore: cast_nullable_to_non_nullable
as String,monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as String,tuesday: null == tuesday ? _self.tuesday : tuesday // ignore: cast_nullable_to_non_nullable
as String,wednesday: null == wednesday ? _self.wednesday : wednesday // ignore: cast_nullable_to_non_nullable
as String,thursday: null == thursday ? _self.thursday : thursday // ignore: cast_nullable_to_non_nullable
as String,friday: null == friday ? _self.friday : friday // ignore: cast_nullable_to_non_nullable
as String,saturday: null == saturday ? _self.saturday : saturday // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RawClassSchedule].
extension RawClassSchedulePatterns on RawClassSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawClassSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawClassSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawClassSchedule value)  $default,){
final _that = this;
switch (_that) {
case _RawClassSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawClassSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _RawClassSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String startHour,  String endHour,  String monday,  String tuesday,  String wednesday,  String thursday,  String friday,  String saturday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawClassSchedule() when $default != null:
return $default(_that.startHour,_that.endHour,_that.monday,_that.tuesday,_that.wednesday,_that.thursday,_that.friday,_that.saturday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String startHour,  String endHour,  String monday,  String tuesday,  String wednesday,  String thursday,  String friday,  String saturday)  $default,) {final _that = this;
switch (_that) {
case _RawClassSchedule():
return $default(_that.startHour,_that.endHour,_that.monday,_that.tuesday,_that.wednesday,_that.thursday,_that.friday,_that.saturday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String startHour,  String endHour,  String monday,  String tuesday,  String wednesday,  String thursday,  String friday,  String saturday)?  $default,) {final _that = this;
switch (_that) {
case _RawClassSchedule() when $default != null:
return $default(_that.startHour,_that.endHour,_that.monday,_that.tuesday,_that.wednesday,_that.thursday,_that.friday,_that.saturday);case _:
  return null;

}
}

}

/// @nodoc


class _RawClassSchedule implements RawClassSchedule {
   _RawClassSchedule({required this.startHour, required this.endHour, required this.monday, required this.tuesday, required this.wednesday, required this.thursday, required this.friday, required this.saturday});
  

@override final  String startHour;
@override final  String endHour;
@override final  String monday;
@override final  String tuesday;
@override final  String wednesday;
@override final  String thursday;
@override final  String friday;
@override final  String saturday;

/// Create a copy of RawClassSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawClassScheduleCopyWith<_RawClassSchedule> get copyWith => __$RawClassScheduleCopyWithImpl<_RawClassSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawClassSchedule&&(identical(other.startHour, startHour) || other.startHour == startHour)&&(identical(other.endHour, endHour) || other.endHour == endHour)&&(identical(other.monday, monday) || other.monday == monday)&&(identical(other.tuesday, tuesday) || other.tuesday == tuesday)&&(identical(other.wednesday, wednesday) || other.wednesday == wednesday)&&(identical(other.thursday, thursday) || other.thursday == thursday)&&(identical(other.friday, friday) || other.friday == friday)&&(identical(other.saturday, saturday) || other.saturday == saturday));
}


@override
int get hashCode => Object.hash(runtimeType,startHour,endHour,monday,tuesday,wednesday,thursday,friday,saturday);

@override
String toString() {
  return 'RawClassSchedule(startHour: $startHour, endHour: $endHour, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday)';
}


}

/// @nodoc
abstract mixin class _$RawClassScheduleCopyWith<$Res> implements $RawClassScheduleCopyWith<$Res> {
  factory _$RawClassScheduleCopyWith(_RawClassSchedule value, $Res Function(_RawClassSchedule) _then) = __$RawClassScheduleCopyWithImpl;
@override @useResult
$Res call({
 String startHour, String endHour, String monday, String tuesday, String wednesday, String thursday, String friday, String saturday
});




}
/// @nodoc
class __$RawClassScheduleCopyWithImpl<$Res>
    implements _$RawClassScheduleCopyWith<$Res> {
  __$RawClassScheduleCopyWithImpl(this._self, this._then);

  final _RawClassSchedule _self;
  final $Res Function(_RawClassSchedule) _then;

/// Create a copy of RawClassSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startHour = null,Object? endHour = null,Object? monday = null,Object? tuesday = null,Object? wednesday = null,Object? thursday = null,Object? friday = null,Object? saturday = null,}) {
  return _then(_RawClassSchedule(
startHour: null == startHour ? _self.startHour : startHour // ignore: cast_nullable_to_non_nullable
as String,endHour: null == endHour ? _self.endHour : endHour // ignore: cast_nullable_to_non_nullable
as String,monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as String,tuesday: null == tuesday ? _self.tuesday : tuesday // ignore: cast_nullable_to_non_nullable
as String,wednesday: null == wednesday ? _self.wednesday : wednesday // ignore: cast_nullable_to_non_nullable
as String,thursday: null == thursday ? _self.thursday : thursday // ignore: cast_nullable_to_non_nullable
as String,friday: null == friday ? _self.friday : friday // ignore: cast_nullable_to_non_nullable
as String,saturday: null == saturday ? _self.saturday : saturday // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
