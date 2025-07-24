// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'academic_history_term.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AcademicHistoryTerm implements DiagnosticableTreeMixin {

// required String termLabel,
 ScheduledTermIdentifier get term; AcademicHistoryTermStatistics? get statistics; List<AcademicHistoryCourse> get courses;
/// Create a copy of AcademicHistoryTerm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicHistoryTermCopyWith<AcademicHistoryTerm> get copyWith => _$AcademicHistoryTermCopyWithImpl<AcademicHistoryTerm>(this as AcademicHistoryTerm, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AcademicHistoryTerm'))
    ..add(DiagnosticsProperty('term', term))..add(DiagnosticsProperty('statistics', statistics))..add(DiagnosticsProperty('courses', courses));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicHistoryTerm&&(identical(other.term, term) || other.term == term)&&(identical(other.statistics, statistics) || other.statistics == statistics)&&const DeepCollectionEquality().equals(other.courses, courses));
}


@override
int get hashCode => Object.hash(runtimeType,term,statistics,const DeepCollectionEquality().hash(courses));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AcademicHistoryTerm(term: $term, statistics: $statistics, courses: $courses)';
}


}

/// @nodoc
abstract mixin class $AcademicHistoryTermCopyWith<$Res>  {
  factory $AcademicHistoryTermCopyWith(AcademicHistoryTerm value, $Res Function(AcademicHistoryTerm) _then) = _$AcademicHistoryTermCopyWithImpl;
@useResult
$Res call({
 ScheduledTermIdentifier term, AcademicHistoryTermStatistics? statistics, List<AcademicHistoryCourse> courses
});


$AcademicHistoryTermStatisticsCopyWith<$Res>? get statistics;

}
/// @nodoc
class _$AcademicHistoryTermCopyWithImpl<$Res>
    implements $AcademicHistoryTermCopyWith<$Res> {
  _$AcademicHistoryTermCopyWithImpl(this._self, this._then);

  final AcademicHistoryTerm _self;
  final $Res Function(AcademicHistoryTerm) _then;

/// Create a copy of AcademicHistoryTerm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? term = null,Object? statistics = freezed,Object? courses = null,}) {
  return _then(_self.copyWith(
term: null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as AcademicHistoryTermStatistics?,courses: null == courses ? _self.courses : courses // ignore: cast_nullable_to_non_nullable
as List<AcademicHistoryCourse>,
  ));
}
/// Create a copy of AcademicHistoryTerm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicHistoryTermStatisticsCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $AcademicHistoryTermStatisticsCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// Adds pattern-matching-related methods to [AcademicHistoryTerm].
extension AcademicHistoryTermPatterns on AcademicHistoryTerm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicHistoryTerm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicHistoryTerm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicHistoryTerm value)  $default,){
final _that = this;
switch (_that) {
case _AcademicHistoryTerm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicHistoryTerm value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicHistoryTerm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScheduledTermIdentifier term,  AcademicHistoryTermStatistics? statistics,  List<AcademicHistoryCourse> courses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicHistoryTerm() when $default != null:
return $default(_that.term,_that.statistics,_that.courses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScheduledTermIdentifier term,  AcademicHistoryTermStatistics? statistics,  List<AcademicHistoryCourse> courses)  $default,) {final _that = this;
switch (_that) {
case _AcademicHistoryTerm():
return $default(_that.term,_that.statistics,_that.courses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScheduledTermIdentifier term,  AcademicHistoryTermStatistics? statistics,  List<AcademicHistoryCourse> courses)?  $default,) {final _that = this;
switch (_that) {
case _AcademicHistoryTerm() when $default != null:
return $default(_that.term,_that.statistics,_that.courses);case _:
  return null;

}
}

}

/// @nodoc


class _AcademicHistoryTerm with DiagnosticableTreeMixin implements AcademicHistoryTerm {
  const _AcademicHistoryTerm({required this.term, required this.statistics, required final  List<AcademicHistoryCourse> courses}): _courses = courses;
  

// required String termLabel,
@override final  ScheduledTermIdentifier term;
@override final  AcademicHistoryTermStatistics? statistics;
 final  List<AcademicHistoryCourse> _courses;
@override List<AcademicHistoryCourse> get courses {
  if (_courses is EqualUnmodifiableListView) return _courses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_courses);
}


/// Create a copy of AcademicHistoryTerm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicHistoryTermCopyWith<_AcademicHistoryTerm> get copyWith => __$AcademicHistoryTermCopyWithImpl<_AcademicHistoryTerm>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AcademicHistoryTerm'))
    ..add(DiagnosticsProperty('term', term))..add(DiagnosticsProperty('statistics', statistics))..add(DiagnosticsProperty('courses', courses));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicHistoryTerm&&(identical(other.term, term) || other.term == term)&&(identical(other.statistics, statistics) || other.statistics == statistics)&&const DeepCollectionEquality().equals(other._courses, _courses));
}


@override
int get hashCode => Object.hash(runtimeType,term,statistics,const DeepCollectionEquality().hash(_courses));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AcademicHistoryTerm(term: $term, statistics: $statistics, courses: $courses)';
}


}

/// @nodoc
abstract mixin class _$AcademicHistoryTermCopyWith<$Res> implements $AcademicHistoryTermCopyWith<$Res> {
  factory _$AcademicHistoryTermCopyWith(_AcademicHistoryTerm value, $Res Function(_AcademicHistoryTerm) _then) = __$AcademicHistoryTermCopyWithImpl;
@override @useResult
$Res call({
 ScheduledTermIdentifier term, AcademicHistoryTermStatistics? statistics, List<AcademicHistoryCourse> courses
});


@override $AcademicHistoryTermStatisticsCopyWith<$Res>? get statistics;

}
/// @nodoc
class __$AcademicHistoryTermCopyWithImpl<$Res>
    implements _$AcademicHistoryTermCopyWith<$Res> {
  __$AcademicHistoryTermCopyWithImpl(this._self, this._then);

  final _AcademicHistoryTerm _self;
  final $Res Function(_AcademicHistoryTerm) _then;

/// Create a copy of AcademicHistoryTerm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? term = null,Object? statistics = freezed,Object? courses = null,}) {
  return _then(_AcademicHistoryTerm(
term: null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as ScheduledTermIdentifier,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as AcademicHistoryTermStatistics?,courses: null == courses ? _self._courses : courses // ignore: cast_nullable_to_non_nullable
as List<AcademicHistoryCourse>,
  ));
}

/// Create a copy of AcademicHistoryTerm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AcademicHistoryTermStatisticsCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $AcademicHistoryTermStatisticsCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}

/// @nodoc
mixin _$AcademicHistoryTermStatistics implements DiagnosticableTreeMixin {

// required String PPS,
 double get termWeightedAverage;// required String PPSAprob,
 double get termWeightedAveragePassed;// required String PPA,
 double get cumulativeWeightedAverage;// required String PPAApr,
 double get cumulativeWeightedAveragePassed;// required String CreOblLlev,
 int get mandatoryCreditsTaken;// required String CreElLlev,
 int get electiveCreditsTaken;// required String CreOblApr,
 int get mandatoryCreditsPassed;// required String CreEleApr,
 int get electiveCreditsPassed;// required String CreOblConv,
 int get mandatoryCreditsValidated;// required String CredEleConv,
 int get electiveCreditsValidated;// required String TotalCredOblLlev,
 int get totalMandatoryCreditsTaken;// required String TotalCredElLlev,
 int get totalElectiveCreditsTaken;// required String TotalCredOblAprob,
 int get totalMandatoryCreditsPassed;// required String TotalCredElAprob,
 int get totalElectiveCreditsPassed;// required String TotalCredOblConv,
 int get totalMandatoryCreditsValidated;
/// Create a copy of AcademicHistoryTermStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicHistoryTermStatisticsCopyWith<AcademicHistoryTermStatistics> get copyWith => _$AcademicHistoryTermStatisticsCopyWithImpl<AcademicHistoryTermStatistics>(this as AcademicHistoryTermStatistics, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AcademicHistoryTermStatistics'))
    ..add(DiagnosticsProperty('termWeightedAverage', termWeightedAverage))..add(DiagnosticsProperty('termWeightedAveragePassed', termWeightedAveragePassed))..add(DiagnosticsProperty('cumulativeWeightedAverage', cumulativeWeightedAverage))..add(DiagnosticsProperty('cumulativeWeightedAveragePassed', cumulativeWeightedAveragePassed))..add(DiagnosticsProperty('mandatoryCreditsTaken', mandatoryCreditsTaken))..add(DiagnosticsProperty('electiveCreditsTaken', electiveCreditsTaken))..add(DiagnosticsProperty('mandatoryCreditsPassed', mandatoryCreditsPassed))..add(DiagnosticsProperty('electiveCreditsPassed', electiveCreditsPassed))..add(DiagnosticsProperty('mandatoryCreditsValidated', mandatoryCreditsValidated))..add(DiagnosticsProperty('electiveCreditsValidated', electiveCreditsValidated))..add(DiagnosticsProperty('totalMandatoryCreditsTaken', totalMandatoryCreditsTaken))..add(DiagnosticsProperty('totalElectiveCreditsTaken', totalElectiveCreditsTaken))..add(DiagnosticsProperty('totalMandatoryCreditsPassed', totalMandatoryCreditsPassed))..add(DiagnosticsProperty('totalElectiveCreditsPassed', totalElectiveCreditsPassed))..add(DiagnosticsProperty('totalMandatoryCreditsValidated', totalMandatoryCreditsValidated));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicHistoryTermStatistics&&(identical(other.termWeightedAverage, termWeightedAverage) || other.termWeightedAverage == termWeightedAverage)&&(identical(other.termWeightedAveragePassed, termWeightedAveragePassed) || other.termWeightedAveragePassed == termWeightedAveragePassed)&&(identical(other.cumulativeWeightedAverage, cumulativeWeightedAverage) || other.cumulativeWeightedAverage == cumulativeWeightedAverage)&&(identical(other.cumulativeWeightedAveragePassed, cumulativeWeightedAveragePassed) || other.cumulativeWeightedAveragePassed == cumulativeWeightedAveragePassed)&&(identical(other.mandatoryCreditsTaken, mandatoryCreditsTaken) || other.mandatoryCreditsTaken == mandatoryCreditsTaken)&&(identical(other.electiveCreditsTaken, electiveCreditsTaken) || other.electiveCreditsTaken == electiveCreditsTaken)&&(identical(other.mandatoryCreditsPassed, mandatoryCreditsPassed) || other.mandatoryCreditsPassed == mandatoryCreditsPassed)&&(identical(other.electiveCreditsPassed, electiveCreditsPassed) || other.electiveCreditsPassed == electiveCreditsPassed)&&(identical(other.mandatoryCreditsValidated, mandatoryCreditsValidated) || other.mandatoryCreditsValidated == mandatoryCreditsValidated)&&(identical(other.electiveCreditsValidated, electiveCreditsValidated) || other.electiveCreditsValidated == electiveCreditsValidated)&&(identical(other.totalMandatoryCreditsTaken, totalMandatoryCreditsTaken) || other.totalMandatoryCreditsTaken == totalMandatoryCreditsTaken)&&(identical(other.totalElectiveCreditsTaken, totalElectiveCreditsTaken) || other.totalElectiveCreditsTaken == totalElectiveCreditsTaken)&&(identical(other.totalMandatoryCreditsPassed, totalMandatoryCreditsPassed) || other.totalMandatoryCreditsPassed == totalMandatoryCreditsPassed)&&(identical(other.totalElectiveCreditsPassed, totalElectiveCreditsPassed) || other.totalElectiveCreditsPassed == totalElectiveCreditsPassed)&&(identical(other.totalMandatoryCreditsValidated, totalMandatoryCreditsValidated) || other.totalMandatoryCreditsValidated == totalMandatoryCreditsValidated));
}


@override
int get hashCode => Object.hash(runtimeType,termWeightedAverage,termWeightedAveragePassed,cumulativeWeightedAverage,cumulativeWeightedAveragePassed,mandatoryCreditsTaken,electiveCreditsTaken,mandatoryCreditsPassed,electiveCreditsPassed,mandatoryCreditsValidated,electiveCreditsValidated,totalMandatoryCreditsTaken,totalElectiveCreditsTaken,totalMandatoryCreditsPassed,totalElectiveCreditsPassed,totalMandatoryCreditsValidated);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AcademicHistoryTermStatistics(termWeightedAverage: $termWeightedAverage, termWeightedAveragePassed: $termWeightedAveragePassed, cumulativeWeightedAverage: $cumulativeWeightedAverage, cumulativeWeightedAveragePassed: $cumulativeWeightedAveragePassed, mandatoryCreditsTaken: $mandatoryCreditsTaken, electiveCreditsTaken: $electiveCreditsTaken, mandatoryCreditsPassed: $mandatoryCreditsPassed, electiveCreditsPassed: $electiveCreditsPassed, mandatoryCreditsValidated: $mandatoryCreditsValidated, electiveCreditsValidated: $electiveCreditsValidated, totalMandatoryCreditsTaken: $totalMandatoryCreditsTaken, totalElectiveCreditsTaken: $totalElectiveCreditsTaken, totalMandatoryCreditsPassed: $totalMandatoryCreditsPassed, totalElectiveCreditsPassed: $totalElectiveCreditsPassed, totalMandatoryCreditsValidated: $totalMandatoryCreditsValidated)';
}


}

/// @nodoc
abstract mixin class $AcademicHistoryTermStatisticsCopyWith<$Res>  {
  factory $AcademicHistoryTermStatisticsCopyWith(AcademicHistoryTermStatistics value, $Res Function(AcademicHistoryTermStatistics) _then) = _$AcademicHistoryTermStatisticsCopyWithImpl;
@useResult
$Res call({
 double termWeightedAverage, double termWeightedAveragePassed, double cumulativeWeightedAverage, double cumulativeWeightedAveragePassed, int mandatoryCreditsTaken, int electiveCreditsTaken, int mandatoryCreditsPassed, int electiveCreditsPassed, int mandatoryCreditsValidated, int electiveCreditsValidated, int totalMandatoryCreditsTaken, int totalElectiveCreditsTaken, int totalMandatoryCreditsPassed, int totalElectiveCreditsPassed, int totalMandatoryCreditsValidated
});




}
/// @nodoc
class _$AcademicHistoryTermStatisticsCopyWithImpl<$Res>
    implements $AcademicHistoryTermStatisticsCopyWith<$Res> {
  _$AcademicHistoryTermStatisticsCopyWithImpl(this._self, this._then);

  final AcademicHistoryTermStatistics _self;
  final $Res Function(AcademicHistoryTermStatistics) _then;

/// Create a copy of AcademicHistoryTermStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? termWeightedAverage = null,Object? termWeightedAveragePassed = null,Object? cumulativeWeightedAverage = null,Object? cumulativeWeightedAveragePassed = null,Object? mandatoryCreditsTaken = null,Object? electiveCreditsTaken = null,Object? mandatoryCreditsPassed = null,Object? electiveCreditsPassed = null,Object? mandatoryCreditsValidated = null,Object? electiveCreditsValidated = null,Object? totalMandatoryCreditsTaken = null,Object? totalElectiveCreditsTaken = null,Object? totalMandatoryCreditsPassed = null,Object? totalElectiveCreditsPassed = null,Object? totalMandatoryCreditsValidated = null,}) {
  return _then(_self.copyWith(
termWeightedAverage: null == termWeightedAverage ? _self.termWeightedAverage : termWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,termWeightedAveragePassed: null == termWeightedAveragePassed ? _self.termWeightedAveragePassed : termWeightedAveragePassed // ignore: cast_nullable_to_non_nullable
as double,cumulativeWeightedAverage: null == cumulativeWeightedAverage ? _self.cumulativeWeightedAverage : cumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,cumulativeWeightedAveragePassed: null == cumulativeWeightedAveragePassed ? _self.cumulativeWeightedAveragePassed : cumulativeWeightedAveragePassed // ignore: cast_nullable_to_non_nullable
as double,mandatoryCreditsTaken: null == mandatoryCreditsTaken ? _self.mandatoryCreditsTaken : mandatoryCreditsTaken // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsTaken: null == electiveCreditsTaken ? _self.electiveCreditsTaken : electiveCreditsTaken // ignore: cast_nullable_to_non_nullable
as int,mandatoryCreditsPassed: null == mandatoryCreditsPassed ? _self.mandatoryCreditsPassed : mandatoryCreditsPassed // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsPassed: null == electiveCreditsPassed ? _self.electiveCreditsPassed : electiveCreditsPassed // ignore: cast_nullable_to_non_nullable
as int,mandatoryCreditsValidated: null == mandatoryCreditsValidated ? _self.mandatoryCreditsValidated : mandatoryCreditsValidated // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsValidated: null == electiveCreditsValidated ? _self.electiveCreditsValidated : electiveCreditsValidated // ignore: cast_nullable_to_non_nullable
as int,totalMandatoryCreditsTaken: null == totalMandatoryCreditsTaken ? _self.totalMandatoryCreditsTaken : totalMandatoryCreditsTaken // ignore: cast_nullable_to_non_nullable
as int,totalElectiveCreditsTaken: null == totalElectiveCreditsTaken ? _self.totalElectiveCreditsTaken : totalElectiveCreditsTaken // ignore: cast_nullable_to_non_nullable
as int,totalMandatoryCreditsPassed: null == totalMandatoryCreditsPassed ? _self.totalMandatoryCreditsPassed : totalMandatoryCreditsPassed // ignore: cast_nullable_to_non_nullable
as int,totalElectiveCreditsPassed: null == totalElectiveCreditsPassed ? _self.totalElectiveCreditsPassed : totalElectiveCreditsPassed // ignore: cast_nullable_to_non_nullable
as int,totalMandatoryCreditsValidated: null == totalMandatoryCreditsValidated ? _self.totalMandatoryCreditsValidated : totalMandatoryCreditsValidated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AcademicHistoryTermStatistics].
extension AcademicHistoryTermStatisticsPatterns on AcademicHistoryTermStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicHistoryTermStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicHistoryTermStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicHistoryTermStatistics value)  $default,){
final _that = this;
switch (_that) {
case _AcademicHistoryTermStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicHistoryTermStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicHistoryTermStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double termWeightedAverage,  double termWeightedAveragePassed,  double cumulativeWeightedAverage,  double cumulativeWeightedAveragePassed,  int mandatoryCreditsTaken,  int electiveCreditsTaken,  int mandatoryCreditsPassed,  int electiveCreditsPassed,  int mandatoryCreditsValidated,  int electiveCreditsValidated,  int totalMandatoryCreditsTaken,  int totalElectiveCreditsTaken,  int totalMandatoryCreditsPassed,  int totalElectiveCreditsPassed,  int totalMandatoryCreditsValidated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicHistoryTermStatistics() when $default != null:
return $default(_that.termWeightedAverage,_that.termWeightedAveragePassed,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAveragePassed,_that.mandatoryCreditsTaken,_that.electiveCreditsTaken,_that.mandatoryCreditsPassed,_that.electiveCreditsPassed,_that.mandatoryCreditsValidated,_that.electiveCreditsValidated,_that.totalMandatoryCreditsTaken,_that.totalElectiveCreditsTaken,_that.totalMandatoryCreditsPassed,_that.totalElectiveCreditsPassed,_that.totalMandatoryCreditsValidated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double termWeightedAverage,  double termWeightedAveragePassed,  double cumulativeWeightedAverage,  double cumulativeWeightedAveragePassed,  int mandatoryCreditsTaken,  int electiveCreditsTaken,  int mandatoryCreditsPassed,  int electiveCreditsPassed,  int mandatoryCreditsValidated,  int electiveCreditsValidated,  int totalMandatoryCreditsTaken,  int totalElectiveCreditsTaken,  int totalMandatoryCreditsPassed,  int totalElectiveCreditsPassed,  int totalMandatoryCreditsValidated)  $default,) {final _that = this;
switch (_that) {
case _AcademicHistoryTermStatistics():
return $default(_that.termWeightedAverage,_that.termWeightedAveragePassed,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAveragePassed,_that.mandatoryCreditsTaken,_that.electiveCreditsTaken,_that.mandatoryCreditsPassed,_that.electiveCreditsPassed,_that.mandatoryCreditsValidated,_that.electiveCreditsValidated,_that.totalMandatoryCreditsTaken,_that.totalElectiveCreditsTaken,_that.totalMandatoryCreditsPassed,_that.totalElectiveCreditsPassed,_that.totalMandatoryCreditsValidated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double termWeightedAverage,  double termWeightedAveragePassed,  double cumulativeWeightedAverage,  double cumulativeWeightedAveragePassed,  int mandatoryCreditsTaken,  int electiveCreditsTaken,  int mandatoryCreditsPassed,  int electiveCreditsPassed,  int mandatoryCreditsValidated,  int electiveCreditsValidated,  int totalMandatoryCreditsTaken,  int totalElectiveCreditsTaken,  int totalMandatoryCreditsPassed,  int totalElectiveCreditsPassed,  int totalMandatoryCreditsValidated)?  $default,) {final _that = this;
switch (_that) {
case _AcademicHistoryTermStatistics() when $default != null:
return $default(_that.termWeightedAverage,_that.termWeightedAveragePassed,_that.cumulativeWeightedAverage,_that.cumulativeWeightedAveragePassed,_that.mandatoryCreditsTaken,_that.electiveCreditsTaken,_that.mandatoryCreditsPassed,_that.electiveCreditsPassed,_that.mandatoryCreditsValidated,_that.electiveCreditsValidated,_that.totalMandatoryCreditsTaken,_that.totalElectiveCreditsTaken,_that.totalMandatoryCreditsPassed,_that.totalElectiveCreditsPassed,_that.totalMandatoryCreditsValidated);case _:
  return null;

}
}

}

/// @nodoc


class _AcademicHistoryTermStatistics with DiagnosticableTreeMixin implements AcademicHistoryTermStatistics {
  const _AcademicHistoryTermStatistics({required this.termWeightedAverage, required this.termWeightedAveragePassed, required this.cumulativeWeightedAverage, required this.cumulativeWeightedAveragePassed, required this.mandatoryCreditsTaken, required this.electiveCreditsTaken, required this.mandatoryCreditsPassed, required this.electiveCreditsPassed, required this.mandatoryCreditsValidated, required this.electiveCreditsValidated, required this.totalMandatoryCreditsTaken, required this.totalElectiveCreditsTaken, required this.totalMandatoryCreditsPassed, required this.totalElectiveCreditsPassed, required this.totalMandatoryCreditsValidated});
  

// required String PPS,
@override final  double termWeightedAverage;
// required String PPSAprob,
@override final  double termWeightedAveragePassed;
// required String PPA,
@override final  double cumulativeWeightedAverage;
// required String PPAApr,
@override final  double cumulativeWeightedAveragePassed;
// required String CreOblLlev,
@override final  int mandatoryCreditsTaken;
// required String CreElLlev,
@override final  int electiveCreditsTaken;
// required String CreOblApr,
@override final  int mandatoryCreditsPassed;
// required String CreEleApr,
@override final  int electiveCreditsPassed;
// required String CreOblConv,
@override final  int mandatoryCreditsValidated;
// required String CredEleConv,
@override final  int electiveCreditsValidated;
// required String TotalCredOblLlev,
@override final  int totalMandatoryCreditsTaken;
// required String TotalCredElLlev,
@override final  int totalElectiveCreditsTaken;
// required String TotalCredOblAprob,
@override final  int totalMandatoryCreditsPassed;
// required String TotalCredElAprob,
@override final  int totalElectiveCreditsPassed;
// required String TotalCredOblConv,
@override final  int totalMandatoryCreditsValidated;

/// Create a copy of AcademicHistoryTermStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicHistoryTermStatisticsCopyWith<_AcademicHistoryTermStatistics> get copyWith => __$AcademicHistoryTermStatisticsCopyWithImpl<_AcademicHistoryTermStatistics>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AcademicHistoryTermStatistics'))
    ..add(DiagnosticsProperty('termWeightedAverage', termWeightedAverage))..add(DiagnosticsProperty('termWeightedAveragePassed', termWeightedAveragePassed))..add(DiagnosticsProperty('cumulativeWeightedAverage', cumulativeWeightedAverage))..add(DiagnosticsProperty('cumulativeWeightedAveragePassed', cumulativeWeightedAveragePassed))..add(DiagnosticsProperty('mandatoryCreditsTaken', mandatoryCreditsTaken))..add(DiagnosticsProperty('electiveCreditsTaken', electiveCreditsTaken))..add(DiagnosticsProperty('mandatoryCreditsPassed', mandatoryCreditsPassed))..add(DiagnosticsProperty('electiveCreditsPassed', electiveCreditsPassed))..add(DiagnosticsProperty('mandatoryCreditsValidated', mandatoryCreditsValidated))..add(DiagnosticsProperty('electiveCreditsValidated', electiveCreditsValidated))..add(DiagnosticsProperty('totalMandatoryCreditsTaken', totalMandatoryCreditsTaken))..add(DiagnosticsProperty('totalElectiveCreditsTaken', totalElectiveCreditsTaken))..add(DiagnosticsProperty('totalMandatoryCreditsPassed', totalMandatoryCreditsPassed))..add(DiagnosticsProperty('totalElectiveCreditsPassed', totalElectiveCreditsPassed))..add(DiagnosticsProperty('totalMandatoryCreditsValidated', totalMandatoryCreditsValidated));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicHistoryTermStatistics&&(identical(other.termWeightedAverage, termWeightedAverage) || other.termWeightedAverage == termWeightedAverage)&&(identical(other.termWeightedAveragePassed, termWeightedAveragePassed) || other.termWeightedAveragePassed == termWeightedAveragePassed)&&(identical(other.cumulativeWeightedAverage, cumulativeWeightedAverage) || other.cumulativeWeightedAverage == cumulativeWeightedAverage)&&(identical(other.cumulativeWeightedAveragePassed, cumulativeWeightedAveragePassed) || other.cumulativeWeightedAveragePassed == cumulativeWeightedAveragePassed)&&(identical(other.mandatoryCreditsTaken, mandatoryCreditsTaken) || other.mandatoryCreditsTaken == mandatoryCreditsTaken)&&(identical(other.electiveCreditsTaken, electiveCreditsTaken) || other.electiveCreditsTaken == electiveCreditsTaken)&&(identical(other.mandatoryCreditsPassed, mandatoryCreditsPassed) || other.mandatoryCreditsPassed == mandatoryCreditsPassed)&&(identical(other.electiveCreditsPassed, electiveCreditsPassed) || other.electiveCreditsPassed == electiveCreditsPassed)&&(identical(other.mandatoryCreditsValidated, mandatoryCreditsValidated) || other.mandatoryCreditsValidated == mandatoryCreditsValidated)&&(identical(other.electiveCreditsValidated, electiveCreditsValidated) || other.electiveCreditsValidated == electiveCreditsValidated)&&(identical(other.totalMandatoryCreditsTaken, totalMandatoryCreditsTaken) || other.totalMandatoryCreditsTaken == totalMandatoryCreditsTaken)&&(identical(other.totalElectiveCreditsTaken, totalElectiveCreditsTaken) || other.totalElectiveCreditsTaken == totalElectiveCreditsTaken)&&(identical(other.totalMandatoryCreditsPassed, totalMandatoryCreditsPassed) || other.totalMandatoryCreditsPassed == totalMandatoryCreditsPassed)&&(identical(other.totalElectiveCreditsPassed, totalElectiveCreditsPassed) || other.totalElectiveCreditsPassed == totalElectiveCreditsPassed)&&(identical(other.totalMandatoryCreditsValidated, totalMandatoryCreditsValidated) || other.totalMandatoryCreditsValidated == totalMandatoryCreditsValidated));
}


@override
int get hashCode => Object.hash(runtimeType,termWeightedAverage,termWeightedAveragePassed,cumulativeWeightedAverage,cumulativeWeightedAveragePassed,mandatoryCreditsTaken,electiveCreditsTaken,mandatoryCreditsPassed,electiveCreditsPassed,mandatoryCreditsValidated,electiveCreditsValidated,totalMandatoryCreditsTaken,totalElectiveCreditsTaken,totalMandatoryCreditsPassed,totalElectiveCreditsPassed,totalMandatoryCreditsValidated);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AcademicHistoryTermStatistics(termWeightedAverage: $termWeightedAverage, termWeightedAveragePassed: $termWeightedAveragePassed, cumulativeWeightedAverage: $cumulativeWeightedAverage, cumulativeWeightedAveragePassed: $cumulativeWeightedAveragePassed, mandatoryCreditsTaken: $mandatoryCreditsTaken, electiveCreditsTaken: $electiveCreditsTaken, mandatoryCreditsPassed: $mandatoryCreditsPassed, electiveCreditsPassed: $electiveCreditsPassed, mandatoryCreditsValidated: $mandatoryCreditsValidated, electiveCreditsValidated: $electiveCreditsValidated, totalMandatoryCreditsTaken: $totalMandatoryCreditsTaken, totalElectiveCreditsTaken: $totalElectiveCreditsTaken, totalMandatoryCreditsPassed: $totalMandatoryCreditsPassed, totalElectiveCreditsPassed: $totalElectiveCreditsPassed, totalMandatoryCreditsValidated: $totalMandatoryCreditsValidated)';
}


}

/// @nodoc
abstract mixin class _$AcademicHistoryTermStatisticsCopyWith<$Res> implements $AcademicHistoryTermStatisticsCopyWith<$Res> {
  factory _$AcademicHistoryTermStatisticsCopyWith(_AcademicHistoryTermStatistics value, $Res Function(_AcademicHistoryTermStatistics) _then) = __$AcademicHistoryTermStatisticsCopyWithImpl;
@override @useResult
$Res call({
 double termWeightedAverage, double termWeightedAveragePassed, double cumulativeWeightedAverage, double cumulativeWeightedAveragePassed, int mandatoryCreditsTaken, int electiveCreditsTaken, int mandatoryCreditsPassed, int electiveCreditsPassed, int mandatoryCreditsValidated, int electiveCreditsValidated, int totalMandatoryCreditsTaken, int totalElectiveCreditsTaken, int totalMandatoryCreditsPassed, int totalElectiveCreditsPassed, int totalMandatoryCreditsValidated
});




}
/// @nodoc
class __$AcademicHistoryTermStatisticsCopyWithImpl<$Res>
    implements _$AcademicHistoryTermStatisticsCopyWith<$Res> {
  __$AcademicHistoryTermStatisticsCopyWithImpl(this._self, this._then);

  final _AcademicHistoryTermStatistics _self;
  final $Res Function(_AcademicHistoryTermStatistics) _then;

/// Create a copy of AcademicHistoryTermStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? termWeightedAverage = null,Object? termWeightedAveragePassed = null,Object? cumulativeWeightedAverage = null,Object? cumulativeWeightedAveragePassed = null,Object? mandatoryCreditsTaken = null,Object? electiveCreditsTaken = null,Object? mandatoryCreditsPassed = null,Object? electiveCreditsPassed = null,Object? mandatoryCreditsValidated = null,Object? electiveCreditsValidated = null,Object? totalMandatoryCreditsTaken = null,Object? totalElectiveCreditsTaken = null,Object? totalMandatoryCreditsPassed = null,Object? totalElectiveCreditsPassed = null,Object? totalMandatoryCreditsValidated = null,}) {
  return _then(_AcademicHistoryTermStatistics(
termWeightedAverage: null == termWeightedAverage ? _self.termWeightedAverage : termWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,termWeightedAveragePassed: null == termWeightedAveragePassed ? _self.termWeightedAveragePassed : termWeightedAveragePassed // ignore: cast_nullable_to_non_nullable
as double,cumulativeWeightedAverage: null == cumulativeWeightedAverage ? _self.cumulativeWeightedAverage : cumulativeWeightedAverage // ignore: cast_nullable_to_non_nullable
as double,cumulativeWeightedAveragePassed: null == cumulativeWeightedAveragePassed ? _self.cumulativeWeightedAveragePassed : cumulativeWeightedAveragePassed // ignore: cast_nullable_to_non_nullable
as double,mandatoryCreditsTaken: null == mandatoryCreditsTaken ? _self.mandatoryCreditsTaken : mandatoryCreditsTaken // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsTaken: null == electiveCreditsTaken ? _self.electiveCreditsTaken : electiveCreditsTaken // ignore: cast_nullable_to_non_nullable
as int,mandatoryCreditsPassed: null == mandatoryCreditsPassed ? _self.mandatoryCreditsPassed : mandatoryCreditsPassed // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsPassed: null == electiveCreditsPassed ? _self.electiveCreditsPassed : electiveCreditsPassed // ignore: cast_nullable_to_non_nullable
as int,mandatoryCreditsValidated: null == mandatoryCreditsValidated ? _self.mandatoryCreditsValidated : mandatoryCreditsValidated // ignore: cast_nullable_to_non_nullable
as int,electiveCreditsValidated: null == electiveCreditsValidated ? _self.electiveCreditsValidated : electiveCreditsValidated // ignore: cast_nullable_to_non_nullable
as int,totalMandatoryCreditsTaken: null == totalMandatoryCreditsTaken ? _self.totalMandatoryCreditsTaken : totalMandatoryCreditsTaken // ignore: cast_nullable_to_non_nullable
as int,totalElectiveCreditsTaken: null == totalElectiveCreditsTaken ? _self.totalElectiveCreditsTaken : totalElectiveCreditsTaken // ignore: cast_nullable_to_non_nullable
as int,totalMandatoryCreditsPassed: null == totalMandatoryCreditsPassed ? _self.totalMandatoryCreditsPassed : totalMandatoryCreditsPassed // ignore: cast_nullable_to_non_nullable
as int,totalElectiveCreditsPassed: null == totalElectiveCreditsPassed ? _self.totalElectiveCreditsPassed : totalElectiveCreditsPassed // ignore: cast_nullable_to_non_nullable
as int,totalMandatoryCreditsValidated: null == totalMandatoryCreditsValidated ? _self.totalMandatoryCreditsValidated : totalMandatoryCreditsValidated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
