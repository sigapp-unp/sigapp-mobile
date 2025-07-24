import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/shared/application/usecases/get_academic_info_usecase.dart';
import 'package:sigapp/student/domain/value_objects/academic_info_data.dart';

part 'student_cubit.freezed.dart';

@freezed
sealed class StudentPageViewState with _$StudentPageViewState {
  const factory StudentPageViewState.loading() = LoadingState;
  const factory StudentPageViewState.success(AcademicInfoData data) =
      SuccessState;
  const factory StudentPageViewState.error(Object error) = ErrorState;
}

@injectable
class StudentPageViewCubit extends Cubit<StudentPageViewState> {
  final GetAcademicInfoUseCase _getAcademicInfoUseCase;
  final Logger _logger;

  StudentPageViewCubit(this._getAcademicInfoUseCase, this._logger)
    : super(const StudentPageViewState.loading());

  Future<void> setup() async {
    emit(const StudentPageViewState.loading());
    try {
      final academicInfo = await _getAcademicInfoUseCase.execute();
      emit(StudentPageViewState.success(academicInfo));
    } catch (e, s) {
      _logger.e('[UI] Error setting up Student Page', error: e, stackTrace: s);
      emit(StudentPageViewState.error(e));
    }
  }
}
