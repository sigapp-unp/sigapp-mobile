// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_class_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetClassScheduleModel {

 String get HoraFinal; String get HoraInicio; String get Lunes; String get Martes; String get Miercoles; String get Jueves; String get Viernes; String get Sabado;
/// Create a copy of GetClassScheduleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetClassScheduleModelCopyWith<GetClassScheduleModel> get copyWith => _$GetClassScheduleModelCopyWithImpl<GetClassScheduleModel>(this as GetClassScheduleModel, _$identity);

  /// Serializes this GetClassScheduleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetClassScheduleModel&&(identical(other.HoraFinal, HoraFinal) || other.HoraFinal == HoraFinal)&&(identical(other.HoraInicio, HoraInicio) || other.HoraInicio == HoraInicio)&&(identical(other.Lunes, Lunes) || other.Lunes == Lunes)&&(identical(other.Martes, Martes) || other.Martes == Martes)&&(identical(other.Miercoles, Miercoles) || other.Miercoles == Miercoles)&&(identical(other.Jueves, Jueves) || other.Jueves == Jueves)&&(identical(other.Viernes, Viernes) || other.Viernes == Viernes)&&(identical(other.Sabado, Sabado) || other.Sabado == Sabado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,HoraFinal,HoraInicio,Lunes,Martes,Miercoles,Jueves,Viernes,Sabado);

@override
String toString() {
  return 'GetClassScheduleModel(HoraFinal: $HoraFinal, HoraInicio: $HoraInicio, Lunes: $Lunes, Martes: $Martes, Miercoles: $Miercoles, Jueves: $Jueves, Viernes: $Viernes, Sabado: $Sabado)';
}


}

/// @nodoc
abstract mixin class $GetClassScheduleModelCopyWith<$Res>  {
  factory $GetClassScheduleModelCopyWith(GetClassScheduleModel value, $Res Function(GetClassScheduleModel) _then) = _$GetClassScheduleModelCopyWithImpl;
@useResult
$Res call({
 String HoraFinal, String HoraInicio, String Lunes, String Martes, String Miercoles, String Jueves, String Viernes, String Sabado
});




}
/// @nodoc
class _$GetClassScheduleModelCopyWithImpl<$Res>
    implements $GetClassScheduleModelCopyWith<$Res> {
  _$GetClassScheduleModelCopyWithImpl(this._self, this._then);

  final GetClassScheduleModel _self;
  final $Res Function(GetClassScheduleModel) _then;

/// Create a copy of GetClassScheduleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? HoraFinal = null,Object? HoraInicio = null,Object? Lunes = null,Object? Martes = null,Object? Miercoles = null,Object? Jueves = null,Object? Viernes = null,Object? Sabado = null,}) {
  return _then(_self.copyWith(
HoraFinal: null == HoraFinal ? _self.HoraFinal : HoraFinal // ignore: cast_nullable_to_non_nullable
as String,HoraInicio: null == HoraInicio ? _self.HoraInicio : HoraInicio // ignore: cast_nullable_to_non_nullable
as String,Lunes: null == Lunes ? _self.Lunes : Lunes // ignore: cast_nullable_to_non_nullable
as String,Martes: null == Martes ? _self.Martes : Martes // ignore: cast_nullable_to_non_nullable
as String,Miercoles: null == Miercoles ? _self.Miercoles : Miercoles // ignore: cast_nullable_to_non_nullable
as String,Jueves: null == Jueves ? _self.Jueves : Jueves // ignore: cast_nullable_to_non_nullable
as String,Viernes: null == Viernes ? _self.Viernes : Viernes // ignore: cast_nullable_to_non_nullable
as String,Sabado: null == Sabado ? _self.Sabado : Sabado // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetClassScheduleModel].
extension GetClassScheduleModelPatterns on GetClassScheduleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetClassScheduleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetClassScheduleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetClassScheduleModel value)  $default,){
final _that = this;
switch (_that) {
case _GetClassScheduleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetClassScheduleModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetClassScheduleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String HoraFinal,  String HoraInicio,  String Lunes,  String Martes,  String Miercoles,  String Jueves,  String Viernes,  String Sabado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetClassScheduleModel() when $default != null:
return $default(_that.HoraFinal,_that.HoraInicio,_that.Lunes,_that.Martes,_that.Miercoles,_that.Jueves,_that.Viernes,_that.Sabado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String HoraFinal,  String HoraInicio,  String Lunes,  String Martes,  String Miercoles,  String Jueves,  String Viernes,  String Sabado)  $default,) {final _that = this;
switch (_that) {
case _GetClassScheduleModel():
return $default(_that.HoraFinal,_that.HoraInicio,_that.Lunes,_that.Martes,_that.Miercoles,_that.Jueves,_that.Viernes,_that.Sabado);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String HoraFinal,  String HoraInicio,  String Lunes,  String Martes,  String Miercoles,  String Jueves,  String Viernes,  String Sabado)?  $default,) {final _that = this;
switch (_that) {
case _GetClassScheduleModel() when $default != null:
return $default(_that.HoraFinal,_that.HoraInicio,_that.Lunes,_that.Martes,_that.Miercoles,_that.Jueves,_that.Viernes,_that.Sabado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetClassScheduleModel implements GetClassScheduleModel {
   _GetClassScheduleModel({required this.HoraFinal, required this.HoraInicio, required this.Lunes, required this.Martes, required this.Miercoles, required this.Jueves, required this.Viernes, required this.Sabado});
  factory _GetClassScheduleModel.fromJson(Map<String, dynamic> json) => _$GetClassScheduleModelFromJson(json);

@override final  String HoraFinal;
@override final  String HoraInicio;
@override final  String Lunes;
@override final  String Martes;
@override final  String Miercoles;
@override final  String Jueves;
@override final  String Viernes;
@override final  String Sabado;

/// Create a copy of GetClassScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetClassScheduleModelCopyWith<_GetClassScheduleModel> get copyWith => __$GetClassScheduleModelCopyWithImpl<_GetClassScheduleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetClassScheduleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetClassScheduleModel&&(identical(other.HoraFinal, HoraFinal) || other.HoraFinal == HoraFinal)&&(identical(other.HoraInicio, HoraInicio) || other.HoraInicio == HoraInicio)&&(identical(other.Lunes, Lunes) || other.Lunes == Lunes)&&(identical(other.Martes, Martes) || other.Martes == Martes)&&(identical(other.Miercoles, Miercoles) || other.Miercoles == Miercoles)&&(identical(other.Jueves, Jueves) || other.Jueves == Jueves)&&(identical(other.Viernes, Viernes) || other.Viernes == Viernes)&&(identical(other.Sabado, Sabado) || other.Sabado == Sabado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,HoraFinal,HoraInicio,Lunes,Martes,Miercoles,Jueves,Viernes,Sabado);

@override
String toString() {
  return 'GetClassScheduleModel(HoraFinal: $HoraFinal, HoraInicio: $HoraInicio, Lunes: $Lunes, Martes: $Martes, Miercoles: $Miercoles, Jueves: $Jueves, Viernes: $Viernes, Sabado: $Sabado)';
}


}

/// @nodoc
abstract mixin class _$GetClassScheduleModelCopyWith<$Res> implements $GetClassScheduleModelCopyWith<$Res> {
  factory _$GetClassScheduleModelCopyWith(_GetClassScheduleModel value, $Res Function(_GetClassScheduleModel) _then) = __$GetClassScheduleModelCopyWithImpl;
@override @useResult
$Res call({
 String HoraFinal, String HoraInicio, String Lunes, String Martes, String Miercoles, String Jueves, String Viernes, String Sabado
});




}
/// @nodoc
class __$GetClassScheduleModelCopyWithImpl<$Res>
    implements _$GetClassScheduleModelCopyWith<$Res> {
  __$GetClassScheduleModelCopyWithImpl(this._self, this._then);

  final _GetClassScheduleModel _self;
  final $Res Function(_GetClassScheduleModel) _then;

/// Create a copy of GetClassScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? HoraFinal = null,Object? HoraInicio = null,Object? Lunes = null,Object? Martes = null,Object? Miercoles = null,Object? Jueves = null,Object? Viernes = null,Object? Sabado = null,}) {
  return _then(_GetClassScheduleModel(
HoraFinal: null == HoraFinal ? _self.HoraFinal : HoraFinal // ignore: cast_nullable_to_non_nullable
as String,HoraInicio: null == HoraInicio ? _self.HoraInicio : HoraInicio // ignore: cast_nullable_to_non_nullable
as String,Lunes: null == Lunes ? _self.Lunes : Lunes // ignore: cast_nullable_to_non_nullable
as String,Martes: null == Martes ? _self.Martes : Martes // ignore: cast_nullable_to_non_nullable
as String,Miercoles: null == Miercoles ? _self.Miercoles : Miercoles // ignore: cast_nullable_to_non_nullable
as String,Jueves: null == Jueves ? _self.Jueves : Jueves // ignore: cast_nullable_to_non_nullable
as String,Viernes: null == Viernes ? _self.Viernes : Viernes // ignore: cast_nullable_to_non_nullable
as String,Sabado: null == Sabado ? _self.Sabado : Sabado // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
