import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/usecases/get_scheduled_courses_usecase.dart';
import 'package:sigapp/courses/domain/entities/scheduled_course.dart';

part 'scheduled_courses_cubit.freezed.dart';

@freezed
sealed class ScheduledCoursesPageState with _$ScheduledCoursesPageState {
  const factory ScheduledCoursesPageState.loading() = CoursesPageLoadingState;
  const factory ScheduledCoursesPageState.success({
    required List<ScheduledCourse> scheduledCourses,
    required List<ScheduledCourse> filteredCourses,
    required String searchQuery,
  }) = ScheduledCoursesPageSuccessState;
  const factory ScheduledCoursesPageState.error(Object error) =
      CoursesPageErrorState;
}

@injectable
class ScheduledCoursesPageCubit extends Cubit<ScheduledCoursesPageState> {
  final GetScheduledCoursesUsecase _getScheduledCoursesUsecase;
  final Logger _logger;

  ScheduledCoursesPageCubit(this._getScheduledCoursesUsecase, this._logger)
    : super(ScheduledCoursesPageState.loading());

  Future<void> setup() async {
    emit(ScheduledCoursesPageState.loading());
    try {
      final items = await _getScheduledCoursesUsecase.execute();
      emit(
        ScheduledCoursesPageState.success(
          scheduledCourses: items,
          filteredCourses: items,
          searchQuery: '',
        ),
      );
    } catch (e, s) {
      _logger.e(
        '[UI] Error loading scheduled courses',
        error: e,
        stackTrace: s,
      );
      emit(ScheduledCoursesPageState.error(e));
    }
  }

  void searchCourses(String query) {
    final currentState = state;

    if (currentState is ScheduledCoursesPageSuccessState) {
      final normalizedQuery = query.toLowerCase();

      if (normalizedQuery.isEmpty) {
        // Si la búsqueda está vacía, mostrar todos los cursos
        emit(
          ScheduledCoursesPageState.success(
            scheduledCourses: currentState.scheduledCourses,
            filteredCourses: currentState.scheduledCourses,
            searchQuery: normalizedQuery,
          ),
        );
      } else {
        // Filtrar los cursos basados en el texto de búsqueda
        final filteredCourses =
            currentState.scheduledCourses.where((course) {
              // Buscar en todos los campos de texto del curso
              return _courseContainsQuery(course, normalizedQuery);
            }).toList();

        emit(
          ScheduledCoursesPageState.success(
            scheduledCourses: currentState.scheduledCourses,
            filteredCourses: filteredCourses,
            searchQuery: normalizedQuery,
          ),
        );
      }
    }
  }

  bool _courseContainsQuery(ScheduledCourse course, String query) {
    // Convertir cada campo a string y verificar si contiene el texto de búsqueda
    return course.courseDescription.toLowerCase().contains(query) ||
        course.courseCode.toLowerCase().contains(query) ||
        course.courseKey.toLowerCase().contains(query) ||
        course.classroomDescription.toLowerCase().contains(query) ||
        course.classroomCode.toLowerCase().contains(query) ||
        course.theoryTeacher.toLowerCase().contains(query) ||
        course.practiceTeacher.toLowerCase().contains(query) ||
        course.groupCode.toLowerCase().contains(query) ||
        course.section.toLowerCase().contains(query) ||
        course.period.toLowerCase().contains(query) ||
        course.regevaCourseId.toLowerCase().contains(query) ||
        course.enrollmentCapacity.toString().contains(query) ||
        course.availableSlots.toString().contains(query) ||
        course.enrolledStudents.toString().contains(query);
  }
}
