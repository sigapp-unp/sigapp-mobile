import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/auth/domain/services/toast_service.dart';
import 'package:sigapp/courses/application/usecases/get_all_hidden_courses_preferences_usecase.dart';
import 'package:sigapp/courses/application/usecases/set_course_visibility_preferences_usecase.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule.dart';
import 'package:sigapp/courses/infrastructure/utils/debounce_manager.dart';

part 'course_visibility_cubit.freezed.dart';

@freezed
abstract class CourseVisibilityState with _$CourseVisibilityState {
  const factory CourseVisibilityState({
    @Default(true) bool isLoading,
    @Default({}) Map<String, bool> hiddenEvents,
  }) = _CourseVisibilityState;
}

@injectable
class CourseVisibilityCubit extends Cubit<CourseVisibilityState>
    with DebounceMixin {
  final GetAllHiddenCoursesPreferencesUseCase _getAllHiddenCoursesUseCase;
  final SetCourseVisibilityPreferencesUseCase _setCourseVisibilityUseCase;
  final ToastService _toastService;
  final Logger _logger;

  String? _semesterId; // Track the current semester

  CourseVisibilityCubit(
    this._getAllHiddenCoursesUseCase,
    this._setCourseVisibilityUseCase,
    this._toastService,
    this._logger,
  ) : super(const CourseVisibilityState()) {
    // Initialize debounce functionality
    initDebounce(toastService: _toastService, logger: _logger);
  }

  /// Set the semester ID for this cubit instance
  void setSemesterId(String semesterId) {
    _semesterId = semesterId;
  }

  Future<void> loadHiddenEvents(List<WeeklyScheduleWidgetItem> events) async {
    if (events.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    if (_semesterId == null) {
      _logger.e('[CUBIT] semesterId not set! Call setSemesterId() first');
      emit(state.copyWith(isLoading: false));
      return;
    }

    final hiddenStatusMap = <String, bool>{};

    // Use the use case to get all hidden event IDs for this semester
    final hiddenEventIds = await _getAllHiddenCoursesUseCase.execute(
      semesterId: _semesterId!,
    );

    for (var event in events) {
      final eventId = event.data.id;
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
    // 1. Update UI immediately
    event.isHidden = isHidden;
    final updatedHiddenEvents = Map<String, bool>.from(state.hiddenEvents);
    updatedHiddenEvents[event.data.id] = isHidden;

    emit(state.copyWith(hiddenEvents: updatedHiddenEvents));

    _logger.d(
      '[CUBIT] toggleEventVisibility -> semester:$_semesterId event:${event.data.id} isHidden:$isHidden',
    );

    // 2. Schedule debounced persistence
    debouncedSave(
      key: 'visibility_${event.data.id}',
      operation: () => _setCourseVisibilityUseCase.execute(
        eventId: event.data.id,
        isVisible: !isHidden,
        semesterId: _semesterId!,
      ),
      errorMessage:
          'Error guardando visibilidad del curso. El cambio se mantiene localmente.',
    );
  }

  @override
  Future<void> close() {
    disposeDebounce();
    return super.close();
  }
}
