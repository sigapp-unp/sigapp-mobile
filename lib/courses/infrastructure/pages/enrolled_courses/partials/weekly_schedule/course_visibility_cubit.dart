import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule.dart';
import 'package:sigapp/courses/infrastructure/services/course_visibility_preferences.dart';

part 'course_visibility_cubit.freezed.dart';

@freezed
abstract class CourseVisibilityState with _$CourseVisibilityState {
  const factory CourseVisibilityState({
    @Default(true) bool isLoading,
    @Default({}) Map<String, bool> hiddenEvents,
  }) = _CourseVisibilityState;
}

class CourseVisibilityCubit extends Cubit<CourseVisibilityState> {
  CourseVisibilityCubit() : super(const CourseVisibilityState());

  Future<void> loadHiddenEvents(List<WeeklyScheduleWidgetItem> events) async {
    if (events.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final hiddenStatusMap = <String, bool>{};

    // Optimización: cargar todos los IDs de eventos ocultos de una vez
    final hiddenEventIds =
        await CourseVisibilityPreferences.getAllHiddenEventIds();

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
    // Actualizar en SharedPreferences
    await CourseVisibilityPreferences.setEventHidden(event.eventId, isHidden);

    // Actualizar el estado local
    event.isHidden = isHidden;

    // Actualizar el estado del Cubit
    final updatedHiddenEvents = Map<String, bool>.from(state.hiddenEvents);
    updatedHiddenEvents[event.eventId] = isHidden;

    emit(state.copyWith(hiddenEvents: updatedHiddenEvents));
  }
}
