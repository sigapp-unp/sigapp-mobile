import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/usecases/get_enrolled_courses_usecase.dart';
import 'package:sigapp/courses/domain/entities/scheduled_term_identifier.dart';
import 'package:sigapp/student/domain/value_objects/semester_context.dart';
import 'package:sigapp/student/domain/entities/student_academic_report.dart';
import 'package:sigapp/student/domain/services/academic_info_service.dart';
import 'package:sigapp/student/domain/value_objects/enrolled_course.dart';

part 'enrolled_courses_page_cubit.freezed.dart';

@freezed
sealed class EnrolledCoursesState with _$EnrolledCoursesState {
  const factory EnrolledCoursesState.loading() = EnrolledCoursesLoadingState;
  const factory EnrolledCoursesState.success({
    required List<EnrolledCourse> value,
  }) = EnrolledCoursesSuccessState;
  const factory EnrolledCoursesState.error(Object error) =
      EnrolledCoursesErrorState;
}

@freezed
sealed class EnrolledCoursesPageState with _$EnrolledCoursesPageState {
  const factory EnrolledCoursesPageState.loading() = CoursesPageLoadingState;
  const factory EnrolledCoursesPageState.success({
    required AcademicReport academicReport,
    required SemesterContext semesterContext,
    required ScheduledTermIdentifier selectedSemester,
    required EnrolledCoursesState enrolledCourses,
  }) = CoursesPageSuccessState;
  const factory EnrolledCoursesPageState.error(Object error) =
      CoursesPageErrorState;
}

@injectable
class EnrolledCoursesPageCubit extends Cubit<EnrolledCoursesPageState> {
  final AcademicInfoService _sessionInfoService;
  final GetEnrolledCoursesUsecase _getEnrolledCoursesUsecase;
  final Logger _logger;

  EnrolledCoursesPageCubit(
    this._getEnrolledCoursesUsecase,
    this._sessionInfoService,
    this._logger,
  ) : super(EnrolledCoursesPageState.loading());

  Future<void> init() async {
    emit(EnrolledCoursesPageState.loading());
    try {
      final sessionInfo = await _sessionInfoService.getSessionInfo();
      final nextState =
          EnrolledCoursesPageState.success(
                academicReport: sessionInfo.academicReport,
                semesterContext: sessionInfo.semesterContext,
                selectedSemester: sessionInfo.semesterContext.defaultSemester,
                enrolledCourses: const EnrolledCoursesState.loading(),
              )
              as CoursesPageSuccessState;
      emit(nextState);
      _fetchEnrolledCourses(nextState);
    } catch (e, s) {
      _logger.e(
        '[UI] Error initializing enrolled courses page',
        error: e,
        stackTrace: s,
      );
      emit(EnrolledCoursesPageState.error(e));
    }
  }

  void retryFetchEnrolledCourses() {
    switch (state) {
      case CoursesPageSuccessState():
        final currentState = state as CoursesPageSuccessState;
        final nextState = CoursesPageSuccessState(
          academicReport: currentState.academicReport,
          semesterContext: currentState.semesterContext,
          selectedSemester: currentState.selectedSemester,
          enrolledCourses: EnrolledCoursesState.loading(),
        );
        emit(nextState);
        _fetchEnrolledCourses(nextState);
      default:
        break;
    }
  }

  void changeSemester(ScheduledTermIdentifier semester) {
    switch (state) {
      case CoursesPageSuccessState(
        academicReport: final academicReport,
        semesterContext: final semesterContext,
      ):
        final nextState = CoursesPageSuccessState(
          academicReport: academicReport,
          semesterContext: semesterContext,
          selectedSemester: semester,
          enrolledCourses: EnrolledCoursesState.loading(),
        );
        emit(nextState);
        _fetchEnrolledCourses(nextState);
      default:
        break;
    }
  }

  void _fetchEnrolledCourses(CoursesPageSuccessState state) {
    _getEnrolledCoursesUsecase
        .execute(state.selectedSemester.id)
        .then((courses) {
          emit(
            state.copyWith(
              enrolledCourses: EnrolledCoursesState.success(value: courses),
            ),
          );
        })
        .catchError((e) {
          emit(state.copyWith(enrolledCourses: EnrolledCoursesState.error(e)));
        });
  }
}
