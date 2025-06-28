import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/usecases/get_course_grade_usecase.dart';
import 'package:sigapp/courses/application/usecases/get_syllabus_file_usecase.dart';
import 'package:sigapp/courses/domain/value-objects/course_grade.dart';
import 'package:sigapp/student/domain/value_objects/enrolled_course.dart';

part 'course_detail_cubit.freezed.dart';

@freezed
sealed class CourseDetailState with _$CourseDetailState {
  const factory CourseDetailState.empty() = CourseDetailEmptyState;
  const factory CourseDetailState.ready({
    required EnrolledCourse course,
    required String regevaScheduledCourseId,
    required CourseDetailSyllabusState syllabus,
    required CourseDetailGradesState grades,
  }) = CourseDetailReadyState;
}

@freezed
sealed class CourseDetailSyllabusState with _$CourseDetailSyllabusState {
  const factory CourseDetailSyllabusState.initial() =
      CourseDetailSyllabusStateInitial;
  const factory CourseDetailSyllabusState.loading() =
      CourseDetailSyllabusStateLoading;
  const factory CourseDetailSyllabusState.loaded(File syllabusFile) =
      CourseDetailSyllabusStateLoaded;
  const factory CourseDetailSyllabusState.notFound() =
      CourseDetailSyllabusStateNotFound;
  // TODO: must be `dynamic error`
  const factory CourseDetailSyllabusState.error(String message) =
      CourseDetailSyllabusStateError;
}

@freezed
sealed class CourseDetailGradesState with _$CourseDetailGradesState {
  const factory CourseDetailGradesState.initial() =
      CourseDetailGradesStateInitial;
  const factory CourseDetailGradesState.loading() =
      CourseDetailGradesStateLoading;
  const factory CourseDetailGradesState.loaded(CourseGradeInfo value) =
      CourseDetailGradesStateLoaded;
  // TODO: must be `dynamic error`
  const factory CourseDetailGradesState.error(String message) =
      CourseDetailGradesStateError;
}

@injectable
class CourseDetailCubit extends Cubit<CourseDetailState> {
  final GetSyllabusFileUsecase _getSyllabusFileUsecase;
  final GetCourseGradeUsecase _getCourseGradeUsecase;
  final Logger _logger;

  CourseDetailCubit(
    this._getSyllabusFileUsecase,
    this._getCourseGradeUsecase,
    this._logger,
  ) : super(const CourseDetailState.empty());

  Future<void> init({
    required EnrolledCourse course,
    required String regevaScheduledCourseId,
  }) async {
    emit(
      CourseDetailState.ready(
        course: course,
        regevaScheduledCourseId: regevaScheduledCourseId,
        syllabus: CourseDetailSyllabusState.initial(),
        grades: CourseDetailGradesState.initial(),
      ),
    );
    await fetchSyllabus();
    await fetchGrades();
  }

  Future<void> fetchSyllabus({bool? forceDownload}) async {
    if (state is! CourseDetailReadyState) return;

    emit(
      (state as CourseDetailReadyState).copyWith(
        syllabus: CourseDetailSyllabusState.loading(),
      ),
    );

    final regevaScheduledCourseId =
        (state as CourseDetailReadyState).regevaScheduledCourseId;
    try {
      final file = await _getSyllabusFileUsecase.execute(
        regevaScheduledCourseId,
        forceDownload: forceDownload,
      );
      if (file == null) {
        emit(
          (state as CourseDetailReadyState).copyWith(
            syllabus: CourseDetailSyllabusState.notFound(),
          ),
        );
      } else {
        emit(
          (state as CourseDetailReadyState).copyWith(
            syllabus: CourseDetailSyllabusState.loaded(file),
          ),
        );
      }
    } catch (e, s) {
      _logger.e('[UI] Error fetching syllabus: $e', error: e, stackTrace: s);
      emit(
        (state as CourseDetailReadyState).copyWith(
          syllabus: CourseDetailSyllabusState.error(
            'Error al descargar syllabus',
          ),
        ),
      );
    }
  }

  Future<void> fetchGrades({bool? forceDownload}) async {
    if (state is! CourseDetailReadyState) return;

    emit(
      (state as CourseDetailReadyState).copyWith(
        grades: CourseDetailGradesState.loading(),
      ),
    );

    final regevaScheduledCourseId =
        (state as CourseDetailReadyState).regevaScheduledCourseId;
    try {
      final courseGradeInfo = await _getCourseGradeUsecase.execute(
        regevaScheduledCourseId,
        forceDownload,
      );
      emit(
        (state as CourseDetailReadyState).copyWith(
          grades: CourseDetailGradesState.loaded(courseGradeInfo),
        ),
      );
    } catch (e, s) {
      _logger.e('[UI] Error fetching grades: $e', error: e, stackTrace: s);
      emit(
        (state as CourseDetailReadyState).copyWith(
          grades: CourseDetailGradesState.error('Error al descargar notas'),
        ),
      );
    }
  }
}
