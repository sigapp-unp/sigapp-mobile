// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_academic_history_term.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetAcademicHistoryTermModel implements DiagnosticableTreeMixin {

 String get termLabel; GetAcademicHistoryTermStatisticsModel? get statistics; List<GetAcademicHistoryCourseModel> get courses;
/// Create a copy of GetAcademicHistoryTermModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetAcademicHistoryTermModelCopyWith<GetAcademicHistoryTermModel> get copyWith => _$GetAcademicHistoryTermModelCopyWithImpl<GetAcademicHistoryTermModel>(this as GetAcademicHistoryTermModel, _$identity);

  /// Serializes this GetAcademicHistoryTermModel to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GetAcademicHistoryTermModel'))
    ..add(DiagnosticsProperty('termLabel', termLabel))..add(DiagnosticsProperty('statistics', statistics))..add(DiagnosticsProperty('courses', courses));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetAcademicHistoryTermModel&&(identical(other.termLabel, termLabel) || other.termLabel == termLabel)&&(identical(other.statistics, statistics) || other.statistics == statistics)&&const DeepCollectionEquality().equals(other.courses, courses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,termLabel,statistics,const DeepCollectionEquality().hash(courses));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GetAcademicHistoryTermModel(termLabel: $termLabel, statistics: $statistics, courses: $courses)';
}


}

/// @nodoc
abstract mixin class $GetAcademicHistoryTermModelCopyWith<$Res>  {
  factory $GetAcademicHistoryTermModelCopyWith(GetAcademicHistoryTermModel value, $Res Function(GetAcademicHistoryTermModel) _then) = _$GetAcademicHistoryTermModelCopyWithImpl;
@useResult
$Res call({
 String termLabel, GetAcademicHistoryTermStatisticsModel? statistics, List<GetAcademicHistoryCourseModel> courses
});


$GetAcademicHistoryTermStatisticsModelCopyWith<$Res>? get statistics;

}
/// @nodoc
class _$GetAcademicHistoryTermModelCopyWithImpl<$Res>
    implements $GetAcademicHistoryTermModelCopyWith<$Res> {
  _$GetAcademicHistoryTermModelCopyWithImpl(this._self, this._then);

  final GetAcademicHistoryTermModel _self;
  final $Res Function(GetAcademicHistoryTermModel) _then;

/// Create a copy of GetAcademicHistoryTermModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? termLabel = null,Object? statistics = freezed,Object? courses = null,}) {
  return _then(_self.copyWith(
termLabel: null == termLabel ? _self.termLabel : termLabel // ignore: cast_nullable_to_non_nullable
as String,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as GetAcademicHistoryTermStatisticsModel?,courses: null == courses ? _self.courses : courses // ignore: cast_nullable_to_non_nullable
as List<GetAcademicHistoryCourseModel>,
  ));
}
/// Create a copy of GetAcademicHistoryTermModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GetAcademicHistoryTermStatisticsModelCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $GetAcademicHistoryTermStatisticsModelCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// Adds pattern-matching-related methods to [GetAcademicHistoryTermModel].
extension GetAcademicHistoryTermModelPatterns on GetAcademicHistoryTermModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetAcademicHistoryTermModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetAcademicHistoryTermModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetAcademicHistoryTermModel value)  $default,){
final _that = this;
switch (_that) {
case _GetAcademicHistoryTermModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetAcademicHistoryTermModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetAcademicHistoryTermModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String termLabel,  GetAcademicHistoryTermStatisticsModel? statistics,  List<GetAcademicHistoryCourseModel> courses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetAcademicHistoryTermModel() when $default != null:
return $default(_that.termLabel,_that.statistics,_that.courses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String termLabel,  GetAcademicHistoryTermStatisticsModel? statistics,  List<GetAcademicHistoryCourseModel> courses)  $default,) {final _that = this;
switch (_that) {
case _GetAcademicHistoryTermModel():
return $default(_that.termLabel,_that.statistics,_that.courses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String termLabel,  GetAcademicHistoryTermStatisticsModel? statistics,  List<GetAcademicHistoryCourseModel> courses)?  $default,) {final _that = this;
switch (_that) {
case _GetAcademicHistoryTermModel() when $default != null:
return $default(_that.termLabel,_that.statistics,_that.courses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetAcademicHistoryTermModel with DiagnosticableTreeMixin implements GetAcademicHistoryTermModel {
  const _GetAcademicHistoryTermModel({required this.termLabel, required this.statistics, required final  List<GetAcademicHistoryCourseModel> courses}): _courses = courses;
  factory _GetAcademicHistoryTermModel.fromJson(Map<String, dynamic> json) => _$GetAcademicHistoryTermModelFromJson(json);

@override final  String termLabel;
@override final  GetAcademicHistoryTermStatisticsModel? statistics;
 final  List<GetAcademicHistoryCourseModel> _courses;
@override List<GetAcademicHistoryCourseModel> get courses {
  if (_courses is EqualUnmodifiableListView) return _courses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_courses);
}


/// Create a copy of GetAcademicHistoryTermModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetAcademicHistoryTermModelCopyWith<_GetAcademicHistoryTermModel> get copyWith => __$GetAcademicHistoryTermModelCopyWithImpl<_GetAcademicHistoryTermModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetAcademicHistoryTermModelToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GetAcademicHistoryTermModel'))
    ..add(DiagnosticsProperty('termLabel', termLabel))..add(DiagnosticsProperty('statistics', statistics))..add(DiagnosticsProperty('courses', courses));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetAcademicHistoryTermModel&&(identical(other.termLabel, termLabel) || other.termLabel == termLabel)&&(identical(other.statistics, statistics) || other.statistics == statistics)&&const DeepCollectionEquality().equals(other._courses, _courses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,termLabel,statistics,const DeepCollectionEquality().hash(_courses));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GetAcademicHistoryTermModel(termLabel: $termLabel, statistics: $statistics, courses: $courses)';
}


}

/// @nodoc
abstract mixin class _$GetAcademicHistoryTermModelCopyWith<$Res> implements $GetAcademicHistoryTermModelCopyWith<$Res> {
  factory _$GetAcademicHistoryTermModelCopyWith(_GetAcademicHistoryTermModel value, $Res Function(_GetAcademicHistoryTermModel) _then) = __$GetAcademicHistoryTermModelCopyWithImpl;
@override @useResult
$Res call({
 String termLabel, GetAcademicHistoryTermStatisticsModel? statistics, List<GetAcademicHistoryCourseModel> courses
});


@override $GetAcademicHistoryTermStatisticsModelCopyWith<$Res>? get statistics;

}
/// @nodoc
class __$GetAcademicHistoryTermModelCopyWithImpl<$Res>
    implements _$GetAcademicHistoryTermModelCopyWith<$Res> {
  __$GetAcademicHistoryTermModelCopyWithImpl(this._self, this._then);

  final _GetAcademicHistoryTermModel _self;
  final $Res Function(_GetAcademicHistoryTermModel) _then;

/// Create a copy of GetAcademicHistoryTermModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? termLabel = null,Object? statistics = freezed,Object? courses = null,}) {
  return _then(_GetAcademicHistoryTermModel(
termLabel: null == termLabel ? _self.termLabel : termLabel // ignore: cast_nullable_to_non_nullable
as String,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as GetAcademicHistoryTermStatisticsModel?,courses: null == courses ? _self._courses : courses // ignore: cast_nullable_to_non_nullable
as List<GetAcademicHistoryCourseModel>,
  ));
}

/// Create a copy of GetAcademicHistoryTermModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GetAcademicHistoryTermStatisticsModelCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $GetAcademicHistoryTermStatisticsModelCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// @nodoc
mixin _$GetAcademicHistoryTermStatisticsModel implements DiagnosticableTreeMixin {

 double get PPS; double get PPSAprob; double get PPA; double get PPAApr; double get CreOblLlev; double get CreElLlev; double get CreOblApr; double get CreEleApr; double get CreOblConv; double get CredEleConv; double get TotalCredOblLlev; double get TotalCredElLlev; double get TotalCredOblAprob; double get TotalCredElAprob; double get TotalCredOblConv;
/// Create a copy of GetAcademicHistoryTermStatisticsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetAcademicHistoryTermStatisticsModelCopyWith<GetAcademicHistoryTermStatisticsModel> get copyWith => _$GetAcademicHistoryTermStatisticsModelCopyWithImpl<GetAcademicHistoryTermStatisticsModel>(this as GetAcademicHistoryTermStatisticsModel, _$identity);

  /// Serializes this GetAcademicHistoryTermStatisticsModel to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GetAcademicHistoryTermStatisticsModel'))
    ..add(DiagnosticsProperty('PPS', PPS))..add(DiagnosticsProperty('PPSAprob', PPSAprob))..add(DiagnosticsProperty('PPA', PPA))..add(DiagnosticsProperty('PPAApr', PPAApr))..add(DiagnosticsProperty('CreOblLlev', CreOblLlev))..add(DiagnosticsProperty('CreElLlev', CreElLlev))..add(DiagnosticsProperty('CreOblApr', CreOblApr))..add(DiagnosticsProperty('CreEleApr', CreEleApr))..add(DiagnosticsProperty('CreOblConv', CreOblConv))..add(DiagnosticsProperty('CredEleConv', CredEleConv))..add(DiagnosticsProperty('TotalCredOblLlev', TotalCredOblLlev))..add(DiagnosticsProperty('TotalCredElLlev', TotalCredElLlev))..add(DiagnosticsProperty('TotalCredOblAprob', TotalCredOblAprob))..add(DiagnosticsProperty('TotalCredElAprob', TotalCredElAprob))..add(DiagnosticsProperty('TotalCredOblConv', TotalCredOblConv));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetAcademicHistoryTermStatisticsModel&&(identical(other.PPS, PPS) || other.PPS == PPS)&&(identical(other.PPSAprob, PPSAprob) || other.PPSAprob == PPSAprob)&&(identical(other.PPA, PPA) || other.PPA == PPA)&&(identical(other.PPAApr, PPAApr) || other.PPAApr == PPAApr)&&(identical(other.CreOblLlev, CreOblLlev) || other.CreOblLlev == CreOblLlev)&&(identical(other.CreElLlev, CreElLlev) || other.CreElLlev == CreElLlev)&&(identical(other.CreOblApr, CreOblApr) || other.CreOblApr == CreOblApr)&&(identical(other.CreEleApr, CreEleApr) || other.CreEleApr == CreEleApr)&&(identical(other.CreOblConv, CreOblConv) || other.CreOblConv == CreOblConv)&&(identical(other.CredEleConv, CredEleConv) || other.CredEleConv == CredEleConv)&&(identical(other.TotalCredOblLlev, TotalCredOblLlev) || other.TotalCredOblLlev == TotalCredOblLlev)&&(identical(other.TotalCredElLlev, TotalCredElLlev) || other.TotalCredElLlev == TotalCredElLlev)&&(identical(other.TotalCredOblAprob, TotalCredOblAprob) || other.TotalCredOblAprob == TotalCredOblAprob)&&(identical(other.TotalCredElAprob, TotalCredElAprob) || other.TotalCredElAprob == TotalCredElAprob)&&(identical(other.TotalCredOblConv, TotalCredOblConv) || other.TotalCredOblConv == TotalCredOblConv));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,PPS,PPSAprob,PPA,PPAApr,CreOblLlev,CreElLlev,CreOblApr,CreEleApr,CreOblConv,CredEleConv,TotalCredOblLlev,TotalCredElLlev,TotalCredOblAprob,TotalCredElAprob,TotalCredOblConv);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GetAcademicHistoryTermStatisticsModel(PPS: $PPS, PPSAprob: $PPSAprob, PPA: $PPA, PPAApr: $PPAApr, CreOblLlev: $CreOblLlev, CreElLlev: $CreElLlev, CreOblApr: $CreOblApr, CreEleApr: $CreEleApr, CreOblConv: $CreOblConv, CredEleConv: $CredEleConv, TotalCredOblLlev: $TotalCredOblLlev, TotalCredElLlev: $TotalCredElLlev, TotalCredOblAprob: $TotalCredOblAprob, TotalCredElAprob: $TotalCredElAprob, TotalCredOblConv: $TotalCredOblConv)';
}


}

/// @nodoc
abstract mixin class $GetAcademicHistoryTermStatisticsModelCopyWith<$Res>  {
  factory $GetAcademicHistoryTermStatisticsModelCopyWith(GetAcademicHistoryTermStatisticsModel value, $Res Function(GetAcademicHistoryTermStatisticsModel) _then) = _$GetAcademicHistoryTermStatisticsModelCopyWithImpl;
@useResult
$Res call({
 double PPS, double PPSAprob, double PPA, double PPAApr, double CreOblLlev, double CreElLlev, double CreOblApr, double CreEleApr, double CreOblConv, double CredEleConv, double TotalCredOblLlev, double TotalCredElLlev, double TotalCredOblAprob, double TotalCredElAprob, double TotalCredOblConv
});




}
/// @nodoc
class _$GetAcademicHistoryTermStatisticsModelCopyWithImpl<$Res>
    implements $GetAcademicHistoryTermStatisticsModelCopyWith<$Res> {
  _$GetAcademicHistoryTermStatisticsModelCopyWithImpl(this._self, this._then);

  final GetAcademicHistoryTermStatisticsModel _self;
  final $Res Function(GetAcademicHistoryTermStatisticsModel) _then;

/// Create a copy of GetAcademicHistoryTermStatisticsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? PPS = null,Object? PPSAprob = null,Object? PPA = null,Object? PPAApr = null,Object? CreOblLlev = null,Object? CreElLlev = null,Object? CreOblApr = null,Object? CreEleApr = null,Object? CreOblConv = null,Object? CredEleConv = null,Object? TotalCredOblLlev = null,Object? TotalCredElLlev = null,Object? TotalCredOblAprob = null,Object? TotalCredElAprob = null,Object? TotalCredOblConv = null,}) {
  return _then(_self.copyWith(
PPS: null == PPS ? _self.PPS : PPS // ignore: cast_nullable_to_non_nullable
as double,PPSAprob: null == PPSAprob ? _self.PPSAprob : PPSAprob // ignore: cast_nullable_to_non_nullable
as double,PPA: null == PPA ? _self.PPA : PPA // ignore: cast_nullable_to_non_nullable
as double,PPAApr: null == PPAApr ? _self.PPAApr : PPAApr // ignore: cast_nullable_to_non_nullable
as double,CreOblLlev: null == CreOblLlev ? _self.CreOblLlev : CreOblLlev // ignore: cast_nullable_to_non_nullable
as double,CreElLlev: null == CreElLlev ? _self.CreElLlev : CreElLlev // ignore: cast_nullable_to_non_nullable
as double,CreOblApr: null == CreOblApr ? _self.CreOblApr : CreOblApr // ignore: cast_nullable_to_non_nullable
as double,CreEleApr: null == CreEleApr ? _self.CreEleApr : CreEleApr // ignore: cast_nullable_to_non_nullable
as double,CreOblConv: null == CreOblConv ? _self.CreOblConv : CreOblConv // ignore: cast_nullable_to_non_nullable
as double,CredEleConv: null == CredEleConv ? _self.CredEleConv : CredEleConv // ignore: cast_nullable_to_non_nullable
as double,TotalCredOblLlev: null == TotalCredOblLlev ? _self.TotalCredOblLlev : TotalCredOblLlev // ignore: cast_nullable_to_non_nullable
as double,TotalCredElLlev: null == TotalCredElLlev ? _self.TotalCredElLlev : TotalCredElLlev // ignore: cast_nullable_to_non_nullable
as double,TotalCredOblAprob: null == TotalCredOblAprob ? _self.TotalCredOblAprob : TotalCredOblAprob // ignore: cast_nullable_to_non_nullable
as double,TotalCredElAprob: null == TotalCredElAprob ? _self.TotalCredElAprob : TotalCredElAprob // ignore: cast_nullable_to_non_nullable
as double,TotalCredOblConv: null == TotalCredOblConv ? _self.TotalCredOblConv : TotalCredOblConv // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GetAcademicHistoryTermStatisticsModel].
extension GetAcademicHistoryTermStatisticsModelPatterns on GetAcademicHistoryTermStatisticsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetAcademicHistoryTermStatisticsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetAcademicHistoryTermStatisticsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetAcademicHistoryTermStatisticsModel value)  $default,){
final _that = this;
switch (_that) {
case _GetAcademicHistoryTermStatisticsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetAcademicHistoryTermStatisticsModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetAcademicHistoryTermStatisticsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double PPS,  double PPSAprob,  double PPA,  double PPAApr,  double CreOblLlev,  double CreElLlev,  double CreOblApr,  double CreEleApr,  double CreOblConv,  double CredEleConv,  double TotalCredOblLlev,  double TotalCredElLlev,  double TotalCredOblAprob,  double TotalCredElAprob,  double TotalCredOblConv)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetAcademicHistoryTermStatisticsModel() when $default != null:
return $default(_that.PPS,_that.PPSAprob,_that.PPA,_that.PPAApr,_that.CreOblLlev,_that.CreElLlev,_that.CreOblApr,_that.CreEleApr,_that.CreOblConv,_that.CredEleConv,_that.TotalCredOblLlev,_that.TotalCredElLlev,_that.TotalCredOblAprob,_that.TotalCredElAprob,_that.TotalCredOblConv);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double PPS,  double PPSAprob,  double PPA,  double PPAApr,  double CreOblLlev,  double CreElLlev,  double CreOblApr,  double CreEleApr,  double CreOblConv,  double CredEleConv,  double TotalCredOblLlev,  double TotalCredElLlev,  double TotalCredOblAprob,  double TotalCredElAprob,  double TotalCredOblConv)  $default,) {final _that = this;
switch (_that) {
case _GetAcademicHistoryTermStatisticsModel():
return $default(_that.PPS,_that.PPSAprob,_that.PPA,_that.PPAApr,_that.CreOblLlev,_that.CreElLlev,_that.CreOblApr,_that.CreEleApr,_that.CreOblConv,_that.CredEleConv,_that.TotalCredOblLlev,_that.TotalCredElLlev,_that.TotalCredOblAprob,_that.TotalCredElAprob,_that.TotalCredOblConv);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double PPS,  double PPSAprob,  double PPA,  double PPAApr,  double CreOblLlev,  double CreElLlev,  double CreOblApr,  double CreEleApr,  double CreOblConv,  double CredEleConv,  double TotalCredOblLlev,  double TotalCredElLlev,  double TotalCredOblAprob,  double TotalCredElAprob,  double TotalCredOblConv)?  $default,) {final _that = this;
switch (_that) {
case _GetAcademicHistoryTermStatisticsModel() when $default != null:
return $default(_that.PPS,_that.PPSAprob,_that.PPA,_that.PPAApr,_that.CreOblLlev,_that.CreElLlev,_that.CreOblApr,_that.CreEleApr,_that.CreOblConv,_that.CredEleConv,_that.TotalCredOblLlev,_that.TotalCredElLlev,_that.TotalCredOblAprob,_that.TotalCredElAprob,_that.TotalCredOblConv);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetAcademicHistoryTermStatisticsModel with DiagnosticableTreeMixin implements GetAcademicHistoryTermStatisticsModel {
  const _GetAcademicHistoryTermStatisticsModel({required this.PPS, required this.PPSAprob, required this.PPA, required this.PPAApr, required this.CreOblLlev, required this.CreElLlev, required this.CreOblApr, required this.CreEleApr, required this.CreOblConv, required this.CredEleConv, required this.TotalCredOblLlev, required this.TotalCredElLlev, required this.TotalCredOblAprob, required this.TotalCredElAprob, required this.TotalCredOblConv});
  factory _GetAcademicHistoryTermStatisticsModel.fromJson(Map<String, dynamic> json) => _$GetAcademicHistoryTermStatisticsModelFromJson(json);

@override final  double PPS;
@override final  double PPSAprob;
@override final  double PPA;
@override final  double PPAApr;
@override final  double CreOblLlev;
@override final  double CreElLlev;
@override final  double CreOblApr;
@override final  double CreEleApr;
@override final  double CreOblConv;
@override final  double CredEleConv;
@override final  double TotalCredOblLlev;
@override final  double TotalCredElLlev;
@override final  double TotalCredOblAprob;
@override final  double TotalCredElAprob;
@override final  double TotalCredOblConv;

/// Create a copy of GetAcademicHistoryTermStatisticsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetAcademicHistoryTermStatisticsModelCopyWith<_GetAcademicHistoryTermStatisticsModel> get copyWith => __$GetAcademicHistoryTermStatisticsModelCopyWithImpl<_GetAcademicHistoryTermStatisticsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetAcademicHistoryTermStatisticsModelToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GetAcademicHistoryTermStatisticsModel'))
    ..add(DiagnosticsProperty('PPS', PPS))..add(DiagnosticsProperty('PPSAprob', PPSAprob))..add(DiagnosticsProperty('PPA', PPA))..add(DiagnosticsProperty('PPAApr', PPAApr))..add(DiagnosticsProperty('CreOblLlev', CreOblLlev))..add(DiagnosticsProperty('CreElLlev', CreElLlev))..add(DiagnosticsProperty('CreOblApr', CreOblApr))..add(DiagnosticsProperty('CreEleApr', CreEleApr))..add(DiagnosticsProperty('CreOblConv', CreOblConv))..add(DiagnosticsProperty('CredEleConv', CredEleConv))..add(DiagnosticsProperty('TotalCredOblLlev', TotalCredOblLlev))..add(DiagnosticsProperty('TotalCredElLlev', TotalCredElLlev))..add(DiagnosticsProperty('TotalCredOblAprob', TotalCredOblAprob))..add(DiagnosticsProperty('TotalCredElAprob', TotalCredElAprob))..add(DiagnosticsProperty('TotalCredOblConv', TotalCredOblConv));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetAcademicHistoryTermStatisticsModel&&(identical(other.PPS, PPS) || other.PPS == PPS)&&(identical(other.PPSAprob, PPSAprob) || other.PPSAprob == PPSAprob)&&(identical(other.PPA, PPA) || other.PPA == PPA)&&(identical(other.PPAApr, PPAApr) || other.PPAApr == PPAApr)&&(identical(other.CreOblLlev, CreOblLlev) || other.CreOblLlev == CreOblLlev)&&(identical(other.CreElLlev, CreElLlev) || other.CreElLlev == CreElLlev)&&(identical(other.CreOblApr, CreOblApr) || other.CreOblApr == CreOblApr)&&(identical(other.CreEleApr, CreEleApr) || other.CreEleApr == CreEleApr)&&(identical(other.CreOblConv, CreOblConv) || other.CreOblConv == CreOblConv)&&(identical(other.CredEleConv, CredEleConv) || other.CredEleConv == CredEleConv)&&(identical(other.TotalCredOblLlev, TotalCredOblLlev) || other.TotalCredOblLlev == TotalCredOblLlev)&&(identical(other.TotalCredElLlev, TotalCredElLlev) || other.TotalCredElLlev == TotalCredElLlev)&&(identical(other.TotalCredOblAprob, TotalCredOblAprob) || other.TotalCredOblAprob == TotalCredOblAprob)&&(identical(other.TotalCredElAprob, TotalCredElAprob) || other.TotalCredElAprob == TotalCredElAprob)&&(identical(other.TotalCredOblConv, TotalCredOblConv) || other.TotalCredOblConv == TotalCredOblConv));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,PPS,PPSAprob,PPA,PPAApr,CreOblLlev,CreElLlev,CreOblApr,CreEleApr,CreOblConv,CredEleConv,TotalCredOblLlev,TotalCredElLlev,TotalCredOblAprob,TotalCredElAprob,TotalCredOblConv);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GetAcademicHistoryTermStatisticsModel(PPS: $PPS, PPSAprob: $PPSAprob, PPA: $PPA, PPAApr: $PPAApr, CreOblLlev: $CreOblLlev, CreElLlev: $CreElLlev, CreOblApr: $CreOblApr, CreEleApr: $CreEleApr, CreOblConv: $CreOblConv, CredEleConv: $CredEleConv, TotalCredOblLlev: $TotalCredOblLlev, TotalCredElLlev: $TotalCredElLlev, TotalCredOblAprob: $TotalCredOblAprob, TotalCredElAprob: $TotalCredElAprob, TotalCredOblConv: $TotalCredOblConv)';
}


}

/// @nodoc
abstract mixin class _$GetAcademicHistoryTermStatisticsModelCopyWith<$Res> implements $GetAcademicHistoryTermStatisticsModelCopyWith<$Res> {
  factory _$GetAcademicHistoryTermStatisticsModelCopyWith(_GetAcademicHistoryTermStatisticsModel value, $Res Function(_GetAcademicHistoryTermStatisticsModel) _then) = __$GetAcademicHistoryTermStatisticsModelCopyWithImpl;
@override @useResult
$Res call({
 double PPS, double PPSAprob, double PPA, double PPAApr, double CreOblLlev, double CreElLlev, double CreOblApr, double CreEleApr, double CreOblConv, double CredEleConv, double TotalCredOblLlev, double TotalCredElLlev, double TotalCredOblAprob, double TotalCredElAprob, double TotalCredOblConv
});




}
/// @nodoc
class __$GetAcademicHistoryTermStatisticsModelCopyWithImpl<$Res>
    implements _$GetAcademicHistoryTermStatisticsModelCopyWith<$Res> {
  __$GetAcademicHistoryTermStatisticsModelCopyWithImpl(this._self, this._then);

  final _GetAcademicHistoryTermStatisticsModel _self;
  final $Res Function(_GetAcademicHistoryTermStatisticsModel) _then;

/// Create a copy of GetAcademicHistoryTermStatisticsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? PPS = null,Object? PPSAprob = null,Object? PPA = null,Object? PPAApr = null,Object? CreOblLlev = null,Object? CreElLlev = null,Object? CreOblApr = null,Object? CreEleApr = null,Object? CreOblConv = null,Object? CredEleConv = null,Object? TotalCredOblLlev = null,Object? TotalCredElLlev = null,Object? TotalCredOblAprob = null,Object? TotalCredElAprob = null,Object? TotalCredOblConv = null,}) {
  return _then(_GetAcademicHistoryTermStatisticsModel(
PPS: null == PPS ? _self.PPS : PPS // ignore: cast_nullable_to_non_nullable
as double,PPSAprob: null == PPSAprob ? _self.PPSAprob : PPSAprob // ignore: cast_nullable_to_non_nullable
as double,PPA: null == PPA ? _self.PPA : PPA // ignore: cast_nullable_to_non_nullable
as double,PPAApr: null == PPAApr ? _self.PPAApr : PPAApr // ignore: cast_nullable_to_non_nullable
as double,CreOblLlev: null == CreOblLlev ? _self.CreOblLlev : CreOblLlev // ignore: cast_nullable_to_non_nullable
as double,CreElLlev: null == CreElLlev ? _self.CreElLlev : CreElLlev // ignore: cast_nullable_to_non_nullable
as double,CreOblApr: null == CreOblApr ? _self.CreOblApr : CreOblApr // ignore: cast_nullable_to_non_nullable
as double,CreEleApr: null == CreEleApr ? _self.CreEleApr : CreEleApr // ignore: cast_nullable_to_non_nullable
as double,CreOblConv: null == CreOblConv ? _self.CreOblConv : CreOblConv // ignore: cast_nullable_to_non_nullable
as double,CredEleConv: null == CredEleConv ? _self.CredEleConv : CredEleConv // ignore: cast_nullable_to_non_nullable
as double,TotalCredOblLlev: null == TotalCredOblLlev ? _self.TotalCredOblLlev : TotalCredOblLlev // ignore: cast_nullable_to_non_nullable
as double,TotalCredElLlev: null == TotalCredElLlev ? _self.TotalCredElLlev : TotalCredElLlev // ignore: cast_nullable_to_non_nullable
as double,TotalCredOblAprob: null == TotalCredOblAprob ? _self.TotalCredOblAprob : TotalCredOblAprob // ignore: cast_nullable_to_non_nullable
as double,TotalCredElAprob: null == TotalCredElAprob ? _self.TotalCredElAprob : TotalCredElAprob // ignore: cast_nullable_to_non_nullable
as double,TotalCredOblConv: null == TotalCredOblConv ? _self.TotalCredOblConv : TotalCredOblConv // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$GetAcademicHistoryCourseModel implements DiagnosticableTreeMixin {

 String get courseCode; String get courseName; String get courseType; int get credits; double get grade;
/// Create a copy of GetAcademicHistoryCourseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetAcademicHistoryCourseModelCopyWith<GetAcademicHistoryCourseModel> get copyWith => _$GetAcademicHistoryCourseModelCopyWithImpl<GetAcademicHistoryCourseModel>(this as GetAcademicHistoryCourseModel, _$identity);

  /// Serializes this GetAcademicHistoryCourseModel to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GetAcademicHistoryCourseModel'))
    ..add(DiagnosticsProperty('courseCode', courseCode))..add(DiagnosticsProperty('courseName', courseName))..add(DiagnosticsProperty('courseType', courseType))..add(DiagnosticsProperty('credits', credits))..add(DiagnosticsProperty('grade', grade));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetAcademicHistoryCourseModel&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.courseType, courseType) || other.courseType == courseType)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.grade, grade) || other.grade == grade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseCode,courseName,courseType,credits,grade);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GetAcademicHistoryCourseModel(courseCode: $courseCode, courseName: $courseName, courseType: $courseType, credits: $credits, grade: $grade)';
}


}

/// @nodoc
abstract mixin class $GetAcademicHistoryCourseModelCopyWith<$Res>  {
  factory $GetAcademicHistoryCourseModelCopyWith(GetAcademicHistoryCourseModel value, $Res Function(GetAcademicHistoryCourseModel) _then) = _$GetAcademicHistoryCourseModelCopyWithImpl;
@useResult
$Res call({
 String courseCode, String courseName, String courseType, int credits, double grade
});




}
/// @nodoc
class _$GetAcademicHistoryCourseModelCopyWithImpl<$Res>
    implements $GetAcademicHistoryCourseModelCopyWith<$Res> {
  _$GetAcademicHistoryCourseModelCopyWithImpl(this._self, this._then);

  final GetAcademicHistoryCourseModel _self;
  final $Res Function(GetAcademicHistoryCourseModel) _then;

/// Create a copy of GetAcademicHistoryCourseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseCode = null,Object? courseName = null,Object? courseType = null,Object? credits = null,Object? grade = null,}) {
  return _then(_self.copyWith(
courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,courseType: null == courseType ? _self.courseType : courseType // ignore: cast_nullable_to_non_nullable
as String,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GetAcademicHistoryCourseModel].
extension GetAcademicHistoryCourseModelPatterns on GetAcademicHistoryCourseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetAcademicHistoryCourseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetAcademicHistoryCourseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetAcademicHistoryCourseModel value)  $default,){
final _that = this;
switch (_that) {
case _GetAcademicHistoryCourseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetAcademicHistoryCourseModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetAcademicHistoryCourseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String courseCode,  String courseName,  String courseType,  int credits,  double grade)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetAcademicHistoryCourseModel() when $default != null:
return $default(_that.courseCode,_that.courseName,_that.courseType,_that.credits,_that.grade);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String courseCode,  String courseName,  String courseType,  int credits,  double grade)  $default,) {final _that = this;
switch (_that) {
case _GetAcademicHistoryCourseModel():
return $default(_that.courseCode,_that.courseName,_that.courseType,_that.credits,_that.grade);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String courseCode,  String courseName,  String courseType,  int credits,  double grade)?  $default,) {final _that = this;
switch (_that) {
case _GetAcademicHistoryCourseModel() when $default != null:
return $default(_that.courseCode,_that.courseName,_that.courseType,_that.credits,_that.grade);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetAcademicHistoryCourseModel with DiagnosticableTreeMixin implements GetAcademicHistoryCourseModel {
  const _GetAcademicHistoryCourseModel({required this.courseCode, required this.courseName, required this.courseType, required this.credits, required this.grade});
  factory _GetAcademicHistoryCourseModel.fromJson(Map<String, dynamic> json) => _$GetAcademicHistoryCourseModelFromJson(json);

@override final  String courseCode;
@override final  String courseName;
@override final  String courseType;
@override final  int credits;
@override final  double grade;

/// Create a copy of GetAcademicHistoryCourseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetAcademicHistoryCourseModelCopyWith<_GetAcademicHistoryCourseModel> get copyWith => __$GetAcademicHistoryCourseModelCopyWithImpl<_GetAcademicHistoryCourseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetAcademicHistoryCourseModelToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GetAcademicHistoryCourseModel'))
    ..add(DiagnosticsProperty('courseCode', courseCode))..add(DiagnosticsProperty('courseName', courseName))..add(DiagnosticsProperty('courseType', courseType))..add(DiagnosticsProperty('credits', credits))..add(DiagnosticsProperty('grade', grade));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetAcademicHistoryCourseModel&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.courseType, courseType) || other.courseType == courseType)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.grade, grade) || other.grade == grade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseCode,courseName,courseType,credits,grade);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GetAcademicHistoryCourseModel(courseCode: $courseCode, courseName: $courseName, courseType: $courseType, credits: $credits, grade: $grade)';
}


}

/// @nodoc
abstract mixin class _$GetAcademicHistoryCourseModelCopyWith<$Res> implements $GetAcademicHistoryCourseModelCopyWith<$Res> {
  factory _$GetAcademicHistoryCourseModelCopyWith(_GetAcademicHistoryCourseModel value, $Res Function(_GetAcademicHistoryCourseModel) _then) = __$GetAcademicHistoryCourseModelCopyWithImpl;
@override @useResult
$Res call({
 String courseCode, String courseName, String courseType, int credits, double grade
});




}
/// @nodoc
class __$GetAcademicHistoryCourseModelCopyWithImpl<$Res>
    implements _$GetAcademicHistoryCourseModelCopyWith<$Res> {
  __$GetAcademicHistoryCourseModelCopyWithImpl(this._self, this._then);

  final _GetAcademicHistoryCourseModel _self;
  final $Res Function(_GetAcademicHistoryCourseModel) _then;

/// Create a copy of GetAcademicHistoryCourseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseCode = null,Object? courseName = null,Object? courseType = null,Object? credits = null,Object? grade = null,}) {
  return _then(_GetAcademicHistoryCourseModel(
courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,courseType: null == courseType ? _self.courseType : courseType // ignore: cast_nullable_to_non_nullable
as String,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
