// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_course_requirements.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetCourseRequirementsModel {

 String get CodCursoPlan; String get CodCursoRequisito; String get DescCursoRequisito; String get Nota; String get Semestre;
/// Create a copy of GetCourseRequirementsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCourseRequirementsModelCopyWith<GetCourseRequirementsModel> get copyWith => _$GetCourseRequirementsModelCopyWithImpl<GetCourseRequirementsModel>(this as GetCourseRequirementsModel, _$identity);

  /// Serializes this GetCourseRequirementsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCourseRequirementsModel&&(identical(other.CodCursoPlan, CodCursoPlan) || other.CodCursoPlan == CodCursoPlan)&&(identical(other.CodCursoRequisito, CodCursoRequisito) || other.CodCursoRequisito == CodCursoRequisito)&&(identical(other.DescCursoRequisito, DescCursoRequisito) || other.DescCursoRequisito == DescCursoRequisito)&&(identical(other.Nota, Nota) || other.Nota == Nota)&&(identical(other.Semestre, Semestre) || other.Semestre == Semestre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,CodCursoPlan,CodCursoRequisito,DescCursoRequisito,Nota,Semestre);

@override
String toString() {
  return 'GetCourseRequirementsModel(CodCursoPlan: $CodCursoPlan, CodCursoRequisito: $CodCursoRequisito, DescCursoRequisito: $DescCursoRequisito, Nota: $Nota, Semestre: $Semestre)';
}


}

/// @nodoc
abstract mixin class $GetCourseRequirementsModelCopyWith<$Res>  {
  factory $GetCourseRequirementsModelCopyWith(GetCourseRequirementsModel value, $Res Function(GetCourseRequirementsModel) _then) = _$GetCourseRequirementsModelCopyWithImpl;
@useResult
$Res call({
 String CodCursoPlan, String CodCursoRequisito, String DescCursoRequisito, String Nota, String Semestre
});




}
/// @nodoc
class _$GetCourseRequirementsModelCopyWithImpl<$Res>
    implements $GetCourseRequirementsModelCopyWith<$Res> {
  _$GetCourseRequirementsModelCopyWithImpl(this._self, this._then);

  final GetCourseRequirementsModel _self;
  final $Res Function(GetCourseRequirementsModel) _then;

/// Create a copy of GetCourseRequirementsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? CodCursoPlan = null,Object? CodCursoRequisito = null,Object? DescCursoRequisito = null,Object? Nota = null,Object? Semestre = null,}) {
  return _then(_self.copyWith(
CodCursoPlan: null == CodCursoPlan ? _self.CodCursoPlan : CodCursoPlan // ignore: cast_nullable_to_non_nullable
as String,CodCursoRequisito: null == CodCursoRequisito ? _self.CodCursoRequisito : CodCursoRequisito // ignore: cast_nullable_to_non_nullable
as String,DescCursoRequisito: null == DescCursoRequisito ? _self.DescCursoRequisito : DescCursoRequisito // ignore: cast_nullable_to_non_nullable
as String,Nota: null == Nota ? _self.Nota : Nota // ignore: cast_nullable_to_non_nullable
as String,Semestre: null == Semestre ? _self.Semestre : Semestre // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetCourseRequirementsModel].
extension GetCourseRequirementsModelPatterns on GetCourseRequirementsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetCourseRequirementsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetCourseRequirementsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetCourseRequirementsModel value)  $default,){
final _that = this;
switch (_that) {
case _GetCourseRequirementsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetCourseRequirementsModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetCourseRequirementsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String CodCursoPlan,  String CodCursoRequisito,  String DescCursoRequisito,  String Nota,  String Semestre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetCourseRequirementsModel() when $default != null:
return $default(_that.CodCursoPlan,_that.CodCursoRequisito,_that.DescCursoRequisito,_that.Nota,_that.Semestre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String CodCursoPlan,  String CodCursoRequisito,  String DescCursoRequisito,  String Nota,  String Semestre)  $default,) {final _that = this;
switch (_that) {
case _GetCourseRequirementsModel():
return $default(_that.CodCursoPlan,_that.CodCursoRequisito,_that.DescCursoRequisito,_that.Nota,_that.Semestre);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String CodCursoPlan,  String CodCursoRequisito,  String DescCursoRequisito,  String Nota,  String Semestre)?  $default,) {final _that = this;
switch (_that) {
case _GetCourseRequirementsModel() when $default != null:
return $default(_that.CodCursoPlan,_that.CodCursoRequisito,_that.DescCursoRequisito,_that.Nota,_that.Semestre);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetCourseRequirementsModel implements GetCourseRequirementsModel {
   _GetCourseRequirementsModel({required this.CodCursoPlan, required this.CodCursoRequisito, required this.DescCursoRequisito, required this.Nota, required this.Semestre});
  factory _GetCourseRequirementsModel.fromJson(Map<String, dynamic> json) => _$GetCourseRequirementsModelFromJson(json);

@override final  String CodCursoPlan;
@override final  String CodCursoRequisito;
@override final  String DescCursoRequisito;
@override final  String Nota;
@override final  String Semestre;

/// Create a copy of GetCourseRequirementsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetCourseRequirementsModelCopyWith<_GetCourseRequirementsModel> get copyWith => __$GetCourseRequirementsModelCopyWithImpl<_GetCourseRequirementsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetCourseRequirementsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCourseRequirementsModel&&(identical(other.CodCursoPlan, CodCursoPlan) || other.CodCursoPlan == CodCursoPlan)&&(identical(other.CodCursoRequisito, CodCursoRequisito) || other.CodCursoRequisito == CodCursoRequisito)&&(identical(other.DescCursoRequisito, DescCursoRequisito) || other.DescCursoRequisito == DescCursoRequisito)&&(identical(other.Nota, Nota) || other.Nota == Nota)&&(identical(other.Semestre, Semestre) || other.Semestre == Semestre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,CodCursoPlan,CodCursoRequisito,DescCursoRequisito,Nota,Semestre);

@override
String toString() {
  return 'GetCourseRequirementsModel(CodCursoPlan: $CodCursoPlan, CodCursoRequisito: $CodCursoRequisito, DescCursoRequisito: $DescCursoRequisito, Nota: $Nota, Semestre: $Semestre)';
}


}

/// @nodoc
abstract mixin class _$GetCourseRequirementsModelCopyWith<$Res> implements $GetCourseRequirementsModelCopyWith<$Res> {
  factory _$GetCourseRequirementsModelCopyWith(_GetCourseRequirementsModel value, $Res Function(_GetCourseRequirementsModel) _then) = __$GetCourseRequirementsModelCopyWithImpl;
@override @useResult
$Res call({
 String CodCursoPlan, String CodCursoRequisito, String DescCursoRequisito, String Nota, String Semestre
});




}
/// @nodoc
class __$GetCourseRequirementsModelCopyWithImpl<$Res>
    implements _$GetCourseRequirementsModelCopyWith<$Res> {
  __$GetCourseRequirementsModelCopyWithImpl(this._self, this._then);

  final _GetCourseRequirementsModel _self;
  final $Res Function(_GetCourseRequirementsModel) _then;

/// Create a copy of GetCourseRequirementsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? CodCursoPlan = null,Object? CodCursoRequisito = null,Object? DescCursoRequisito = null,Object? Nota = null,Object? Semestre = null,}) {
  return _then(_GetCourseRequirementsModel(
CodCursoPlan: null == CodCursoPlan ? _self.CodCursoPlan : CodCursoPlan // ignore: cast_nullable_to_non_nullable
as String,CodCursoRequisito: null == CodCursoRequisito ? _self.CodCursoRequisito : CodCursoRequisito // ignore: cast_nullable_to_non_nullable
as String,DescCursoRequisito: null == DescCursoRequisito ? _self.DescCursoRequisito : DescCursoRequisito // ignore: cast_nullable_to_non_nullable
as String,Nota: null == Nota ? _self.Nota : Nota // ignore: cast_nullable_to_non_nullable
as String,Semestre: null == Semestre ? _self.Semestre : Semestre // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
