import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/usecases/get_program_curriculum_progress_usecase.dart';
import 'package:sigapp/courses/domain/value-objects/program_curriculum_progress.dart';
import 'package:sigapp/student/domain/entities/student_academic_report.dart';
import 'package:sigapp/student/application/usecases/get_academic_info_usecase.dart';

part 'career_page_cubit.freezed.dart';

@freezed
sealed class CareerPageState with _$CareerPageState {
  const factory CareerPageState.loading() = CareerPageLoadingState;
  const factory CareerPageState.success({
    required ProgramCurriculumProgress programCurriculumProgress,
    required AcademicReport academicReport,
  }) = CareerPageSuccessState;
  const factory CareerPageState.error(Object error) = CareerPageErrorState;
}

@injectable
class CareerPageCubit extends Cubit<CareerPageState> {
  final GetProgramCurriculumProgressUsecase
  _getProgramCurriculumProgressUsecase;
  final GetAcademicInfoUseCase _getAcademicInfoUseCase;
  final Logger _logger;

  CareerPageCubit(
    this._getProgramCurriculumProgressUsecase,
    this._getAcademicInfoUseCase,
    this._logger,
  ) : super(CareerPageState.loading());

  Future<void> fetch() async {
    emit(CareerPageState.loading());
    try {
      final academicReport = await _getAcademicInfoUseCase.execute().then(
        (v) => v.academicReport,
      );
      final programCurriculumProgress =
          await _getProgramCurriculumProgressUsecase.execute();
      emit(
        CareerPageState.success(
          academicReport: academicReport,
          programCurriculumProgress: programCurriculumProgress,
        ),
      );
    } catch (e, s) {
      _logger.e(
        '[UI] Error fetching career page data: $e',
        error: e,
        stackTrace: s,
      );
      emit(CareerPageState.error(e));
    }
  }
}
