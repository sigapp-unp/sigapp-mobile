import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/usecases/get_all_hidden_courses_preferences_usecase.dart';
import 'package:sigapp/courses/application/usecases/set_course_visibility_preferences_usecase.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule.dart';

part 'course_visibility_cubit.freezed.dart';

@freezed
abstract class CourseVisibilityState with _$CourseVisibilityState {
  const factory CourseVisibilityState({
    @Default(true) bool isLoading,
    @Default({}) Map<String, bool> hiddenEvents,
  }) = _CourseVisibilityState;
}

@injectable
class CourseVisibilityCubit extends Cubit<CourseVisibilityState> {
  final GetAllHiddenCoursesPreferencesUseCase _getAllHiddenCoursesUseCase;
  final SetCourseVisibilityPreferencesUseCase _setCourseVisibilityUseCase;

  CourseVisibilityCubit(
    this._getAllHiddenCoursesUseCase,
    this._setCourseVisibilityUseCase,
  ) : super(const CourseVisibilityState());

  Future<void> loadHiddenEvents(List<WeeklyScheduleWidgetItem> events) async {
    if (events.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final hiddenStatusMap = <String, bool>{};

    // Use the use case to get all hidden event IDs
    final hiddenEventIds = await _getAllHiddenCoursesUseCase();

    for (var event in events) {
      final eventId = event.eventId;
      final isHidden = hiddenEventIds.any((id) => id == eventId);
      hiddenStatusMap[eventId] = isHidden;
      event.isHidden = isHidden; // Actualizar el estado del evento
    }

    emit(state.copyWith(hiddenEvents: hiddenStatusMap, isLoading: false));
  }

  Future<void> toggleEventVisibility(
    WeeklyScheduleWidgetItem event,
    bool isHidden,
  ) async {
    // Use the use case to update visibility (note: isVisible = !isHidden)
    await _setCourseVisibilityUseCase(event.eventId, !isHidden);

    // Actualizar el estado local
    event.isHidden = isHidden;

    // Actualizar el estado del Cubit
    final updatedHiddenEvents = Map<String, bool>.from(state.hiddenEvents);
    updatedHiddenEvents[event.eventId] = isHidden;

    emit(state.copyWith(hiddenEvents: updatedHiddenEvents));
  }
}
