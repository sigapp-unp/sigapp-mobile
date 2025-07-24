// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_share_button_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleShareButtonState {

 bool get loadingShare; String? get errorMessage; bool? get errorMessageWasShown;
/// Create a copy of ScheduleShareButtonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleShareButtonStateCopyWith<ScheduleShareButtonState> get copyWith => _$ScheduleShareButtonStateCopyWithImpl<ScheduleShareButtonState>(this as ScheduleShareButtonState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleShareButtonState&&(identical(other.loadingShare, loadingShare) || other.loadingShare == loadingShare)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorMessageWasShown, errorMessageWasShown) || other.errorMessageWasShown == errorMessageWasShown));
}


@override
int get hashCode => Object.hash(runtimeType,loadingShare,errorMessage,errorMessageWasShown);

@override
String toString() {
  return 'ScheduleShareButtonState(loadingShare: $loadingShare, errorMessage: $errorMessage, errorMessageWasShown: $errorMessageWasShown)';
}


}

/// @nodoc
abstract mixin class $ScheduleShareButtonStateCopyWith<$Res>  {
  factory $ScheduleShareButtonStateCopyWith(ScheduleShareButtonState value, $Res Function(ScheduleShareButtonState) _then) = _$ScheduleShareButtonStateCopyWithImpl;
@useResult
$Res call({
 bool loadingShare, String? errorMessage, bool? errorMessageWasShown
});




}
/// @nodoc
class _$ScheduleShareButtonStateCopyWithImpl<$Res>
    implements $ScheduleShareButtonStateCopyWith<$Res> {
  _$ScheduleShareButtonStateCopyWithImpl(this._self, this._then);

  final ScheduleShareButtonState _self;
  final $Res Function(ScheduleShareButtonState) _then;

/// Create a copy of ScheduleShareButtonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingShare = null,Object? errorMessage = freezed,Object? errorMessageWasShown = freezed,}) {
  return _then(_self.copyWith(
loadingShare: null == loadingShare ? _self.loadingShare : loadingShare // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorMessageWasShown: freezed == errorMessageWasShown ? _self.errorMessageWasShown : errorMessageWasShown // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleShareButtonState].
extension ScheduleShareButtonStatePatterns on ScheduleShareButtonState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleShareButtonState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleShareButtonState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleShareButtonState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleShareButtonState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleShareButtonState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleShareButtonState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loadingShare,  String? errorMessage,  bool? errorMessageWasShown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleShareButtonState() when $default != null:
return $default(_that.loadingShare,_that.errorMessage,_that.errorMessageWasShown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loadingShare,  String? errorMessage,  bool? errorMessageWasShown)  $default,) {final _that = this;
switch (_that) {
case _ScheduleShareButtonState():
return $default(_that.loadingShare,_that.errorMessage,_that.errorMessageWasShown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loadingShare,  String? errorMessage,  bool? errorMessageWasShown)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleShareButtonState() when $default != null:
return $default(_that.loadingShare,_that.errorMessage,_that.errorMessageWasShown);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleShareButtonState implements ScheduleShareButtonState {
  const _ScheduleShareButtonState({required this.loadingShare, this.errorMessage, this.errorMessageWasShown});
  

@override final  bool loadingShare;
@override final  String? errorMessage;
@override final  bool? errorMessageWasShown;

/// Create a copy of ScheduleShareButtonState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleShareButtonStateCopyWith<_ScheduleShareButtonState> get copyWith => __$ScheduleShareButtonStateCopyWithImpl<_ScheduleShareButtonState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleShareButtonState&&(identical(other.loadingShare, loadingShare) || other.loadingShare == loadingShare)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorMessageWasShown, errorMessageWasShown) || other.errorMessageWasShown == errorMessageWasShown));
}


@override
int get hashCode => Object.hash(runtimeType,loadingShare,errorMessage,errorMessageWasShown);

@override
String toString() {
  return 'ScheduleShareButtonState(loadingShare: $loadingShare, errorMessage: $errorMessage, errorMessageWasShown: $errorMessageWasShown)';
}


}

/// @nodoc
abstract mixin class _$ScheduleShareButtonStateCopyWith<$Res> implements $ScheduleShareButtonStateCopyWith<$Res> {
  factory _$ScheduleShareButtonStateCopyWith(_ScheduleShareButtonState value, $Res Function(_ScheduleShareButtonState) _then) = __$ScheduleShareButtonStateCopyWithImpl;
@override @useResult
$Res call({
 bool loadingShare, String? errorMessage, bool? errorMessageWasShown
});




}
/// @nodoc
class __$ScheduleShareButtonStateCopyWithImpl<$Res>
    implements _$ScheduleShareButtonStateCopyWith<$Res> {
  __$ScheduleShareButtonStateCopyWithImpl(this._self, this._then);

  final _ScheduleShareButtonState _self;
  final $Res Function(_ScheduleShareButtonState) _then;

/// Create a copy of ScheduleShareButtonState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingShare = null,Object? errorMessage = freezed,Object? errorMessageWasShown = freezed,}) {
  return _then(_ScheduleShareButtonState(
loadingShare: null == loadingShare ? _self.loadingShare : loadingShare // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorMessageWasShown: freezed == errorMessageWasShown ? _self.errorMessageWasShown : errorMessageWasShown // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
