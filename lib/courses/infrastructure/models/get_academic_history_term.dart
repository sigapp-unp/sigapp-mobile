import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'get_academic_history_term.freezed.dart';
part 'get_academic_history_term.g.dart';

@freezed
abstract class GetAcademicHistoryTermModel with _$GetAcademicHistoryTermModel {
  const factory GetAcademicHistoryTermModel({
    required String termLabel,
    required GetAcademicHistoryTermStatisticsModel? statistics,
    required List<GetAcademicHistoryCourseModel> courses,
  }) = _GetAcademicHistoryTermModel;

  factory GetAcademicHistoryTermModel.fromJson(Map<String, Object?> json) =>
      _$GetAcademicHistoryTermModelFromJson(json);
}

@freezed
abstract class GetAcademicHistoryTermStatisticsModel
    with _$GetAcademicHistoryTermStatisticsModel {
  const factory GetAcademicHistoryTermStatisticsModel({
    required double PPS,
    required double PPSAprob,
    required double PPA,
    required double PPAApr,
    required double CreOblLlev,
    required double CreElLlev,
    required double CreOblApr,
    required double CreEleApr,
    required double CreOblConv,
    required double CredEleConv,
    required double TotalCredOblLlev,
    required double TotalCredElLlev,
    required double TotalCredOblAprob,
    required double TotalCredElAprob,
    required double TotalCredOblConv,
  }) = _GetAcademicHistoryTermStatisticsModel;

  factory GetAcademicHistoryTermStatisticsModel.fromJson(
    Map<String, Object?> json,
  ) => _$GetAcademicHistoryTermStatisticsModelFromJson(json);
}

@freezed
abstract class GetAcademicHistoryCourseModel
    with _$GetAcademicHistoryCourseModel {
  const factory GetAcademicHistoryCourseModel({
    required String courseCode,
    required String courseName,
    required String courseType,
    required int credits,
    required double grade,
  }) = _GetAcademicHistoryCourseModel;

  factory GetAcademicHistoryCourseModel.fromJson(Map<String, Object?> json) =>
      _$GetAcademicHistoryCourseModelFromJson(json);
}
