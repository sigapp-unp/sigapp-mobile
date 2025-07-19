import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/usecases/create_grade_tracking_usecase.dart';
import 'package:sigapp/courses/application/usecases/delete_grade_tracking_usecase.dart';
import 'package:sigapp/courses/application/usecases/get_grade_tracking_usecase.dart';
import 'package:sigapp/courses/application/usecases/manage_grade_tracking_categories_usecase.dart';
import 'package:sigapp/courses/application/usecases/manage_grade_tracking_grades_usecase.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';

part 'grade_tracker_section_cubit.freezed.dart';

@freezed
sealed class GradeTrackerSectionState with _$GradeTrackerSectionState {
  const factory GradeTrackerSectionState.empty() =
      GradeTrackerSectionEmptyState;

  const factory GradeTrackerSectionState.loading() =
      GradeTrackerSectionLoadingState;

  const factory GradeTrackerSectionState.ready({
    required CourseTracking courseTracking,
    @Default({}) Set<String> processingGradeIds,
    @Default({}) Set<String> processingCategoryIds,
  }) = GradeTrackerSectionReadyState;
  const factory GradeTrackerSectionState.error(Object error) =
      GradeTrackerSectionErrorState;
}

@injectable
class GradeTrackerSectionCubit extends Cubit<GradeTrackerSectionState> {
  final GetGradeTrackingUseCase _getGradeTrackingUseCase;
  final CreateGradeTrackingUseCase _createGradeTrackingUseCase;
  final DeleteGradeTrackingUseCase _deleteGradeTrackingUseCase;
  final ManageGradeTrackingCategoriesUseCase
  _manageGradeTrackingCategoriesUseCase;
  final ManageGradeTrackingGradesUseCase _manageGradeTrackingGradesUseCase;
  final Logger _logger;
  String? _courseCode;

  GradeTrackerSectionCubit(
    this._getGradeTrackingUseCase,
    this._createGradeTrackingUseCase,
    this._deleteGradeTrackingUseCase,
    this._manageGradeTrackingCategoriesUseCase,
    this._manageGradeTrackingGradesUseCase,
    this._logger,
  ) : super(const GradeTrackerSectionState.empty());

  Future<void> init({required String courseId}) async {
    _courseCode = courseId;

    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      emit(const GradeTrackerSectionState.loading());

      // Intentamos obtener el seguimiento existente
      CourseTracking? tracking;

      if (_courseCode != null) {
        tracking = await _getGradeTrackingUseCase(courseCode: _courseCode!);
      }

      if (tracking != null) {
        emit(GradeTrackerSectionState.ready(courseTracking: tracking));
      } else {
        // Si no existe, mantenemos el estado vacío
        emit(const GradeTrackerSectionState.empty());
      }
    } catch (e, s) {
      _logger.e(
        '[UI] Error loading grade tracking data',
        error: e,
        stackTrace: s,
      );
      emit(
        GradeTrackerSectionState.error(
          "Error al cargar el seguimiento de notas: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> retry() async {
    await _loadData();
  }

  Future<void> createCourseTracking({required String courseName}) async {
    try {
      emit(const GradeTrackerSectionState.loading());

      // Usamos el courseId guardado durante la inicialización como identificador
      // para asegurarnos de que siempre recuperemos el mismo curso
      if (_courseCode == null) {
        emit(
          GradeTrackerSectionState.error(
            "Error: No se pudo identificar el curso",
          ),
        );
        return;
      }

      final tracking = await _createGradeTrackingUseCase(
        courseCode: _courseCode!,
        courseName: courseName,
      );

      emit(GradeTrackerSectionState.ready(courseTracking: tracking));
    } catch (e, s) {
      _logger.e('[UI] Error creating course tracking', error: e, stackTrace: s);
      emit(GradeTrackerSectionState.error(e));
    }
  }

  // Métodos para gestionar categorías
  Future<void> addCategory({
    required String name,
    required double weight,
  }) async {
    final currentState = state;
    if (currentState is GradeTrackerSectionReadyState) {
      try {
        final courseId = currentState.courseTracking.courseCode;
        final updatedTracking = await _manageGradeTrackingCategoriesUseCase
            .addCategory(
              courseCode: courseId,
              categoryName: name,
              weight: weight,
            );
        emit(GradeTrackerSectionState.ready(courseTracking: updatedTracking));
      } catch (e, s) {
        _logger.e('[UI] Error adding category', error: e, stackTrace: s);
        emit(GradeTrackerSectionState.error(e));
      }
    }
  }

  Future<void> updateCategory({
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    final currentState = state;
    if (currentState is GradeTrackerSectionReadyState) {
      try {
        final courseId = currentState.courseTracking.courseCode;
        final updatedTracking = await _manageGradeTrackingCategoriesUseCase
            .updateCategory(
              courseCode: courseId,
              categoryId: categoryId,
              newName: newName,
              newWeight: newWeight,
            );
        emit(GradeTrackerSectionState.ready(courseTracking: updatedTracking));
      } catch (e, s) {
        _logger.e('[UI] Error updating category', error: e, stackTrace: s);
        emit(GradeTrackerSectionState.error(e));
      }
    }
  }

  Future<void> deleteCategory({required String categoryId}) async {
    final currentState = state;
    if (currentState is GradeTrackerSectionReadyState) {
      try {
        final courseId = currentState.courseTracking.courseCode;
        final updatedTracking = await _manageGradeTrackingCategoriesUseCase
            .removeCategory(courseCode: courseId, categoryId: categoryId);
        emit(GradeTrackerSectionState.ready(courseTracking: updatedTracking));
      } catch (e, s) {
        _logger.e('[UI] Error deleting category', error: e, stackTrace: s);
        emit(GradeTrackerSectionState.error(e));
      }
    }
  }

  // Métodos para gestionar notas
  Future<void> addGrade({
    required String categoryId,
    required String name,
    required double score,
  }) async {
    final currentState = state;
    if (currentState is GradeTrackerSectionReadyState) {
      try {
        final courseId = currentState.courseTracking.courseCode;
        final updatedTracking = await _manageGradeTrackingGradesUseCase
            .addGrade(
              courseCode: courseId,
              categoryId: categoryId,
              gradeName: name,
              score: score,
            );
        emit(GradeTrackerSectionState.ready(courseTracking: updatedTracking));
      } catch (e, s) {
        _logger.e('[UI] Error adding grade', error: e, stackTrace: s);
        emit(GradeTrackerSectionState.error(e));
      }
    }
  }

  Future<void> updateGrade({
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  }) async {
    final currentState = state;
    if (currentState is GradeTrackerSectionReadyState) {
      try {
        // ✅ GRANULAR: Marcar solo esta nota como procesando
        emit(
          currentState.copyWith(
            processingGradeIds: {...currentState.processingGradeIds, gradeId},
          ),
        );

        final courseId = currentState.courseTracking.courseCode;
        final updatedTracking = await _manageGradeTrackingGradesUseCase
            .updateGrade(
              courseCode: courseId,
              categoryId: categoryId,
              gradeId: gradeId,
              newName: newName,
              newScore: newScore,
            );

        // ✅ GRANULAR: Quitar de procesando y actualizar datos
        emit(
          currentState.copyWith(
            courseTracking: updatedTracking,
            processingGradeIds: currentState.processingGradeIds.difference({
              gradeId,
            }),
          ),
        );
      } catch (e, s) {
        _logger.e('[UI] Error updating grade', error: e, stackTrace: s);

        // ✅ GRANULAR: Quitar de procesando en caso de error
        emit(
          currentState.copyWith(
            processingGradeIds: currentState.processingGradeIds.difference({
              gradeId,
            }),
          ),
        );

        emit(GradeTrackerSectionState.error(e));
      }
    }
  }

  Future<void> toggleGradeEnabled({
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    final currentState = state;
    if (currentState is GradeTrackerSectionReadyState) {
      try {
        // ✅ GRANULAR: Marcar solo esta nota como procesando
        emit(
          currentState.copyWith(
            processingGradeIds: {...currentState.processingGradeIds, gradeId},
          ),
        );

        final courseId = currentState.courseTracking.courseCode;
        final updatedTracking = await _manageGradeTrackingGradesUseCase
            .toggleGradeEnabled(
              courseCode: courseId,
              categoryId: categoryId,
              gradeId: gradeId,
              enabled: enabled,
            );

        // ✅ GRANULAR: Quitar de procesando y actualizar datos
        emit(
          currentState.copyWith(
            courseTracking: updatedTracking,
            processingGradeIds: currentState.processingGradeIds.difference({
              gradeId,
            }),
          ),
        );
      } catch (e, s) {
        _logger.e('[UI] Error toggling grade enabled', error: e, stackTrace: s);

        // ✅ GRANULAR: Quitar de procesando en caso de error
        emit(
          currentState.copyWith(
            processingGradeIds: currentState.processingGradeIds.difference({
              gradeId,
            }),
          ),
        );

        emit(GradeTrackerSectionState.error(e));
      }
    }
  }

  Future<void> deleteGrade({
    required String categoryId,
    required String gradeId,
  }) async {
    final currentState = state;
    if (currentState is GradeTrackerSectionReadyState) {
      try {
        // ✅ GRANULAR: Marcar solo esta nota como procesando
        emit(
          currentState.copyWith(
            processingGradeIds: {...currentState.processingGradeIds, gradeId},
          ),
        );

        final courseId = currentState.courseTracking.courseCode;
        final updatedTracking = await _manageGradeTrackingGradesUseCase
            .removeGrade(
              courseCode: courseId,
              categoryId: categoryId,
              gradeId: gradeId,
            );

        // ✅ GRANULAR: Actualizar datos (la nota ya no existe, no necesitamos quitarla de processing)
        emit(
          currentState.copyWith(
            courseTracking: updatedTracking,
            processingGradeIds: currentState.processingGradeIds.difference({
              gradeId,
            }),
          ),
        );
      } catch (e, s) {
        _logger.e('[UI] Error deleting grade', error: e, stackTrace: s);

        // ✅ GRANULAR: Quitar de procesando en caso de error
        emit(
          currentState.copyWith(
            processingGradeIds: currentState.processingGradeIds.difference({
              gradeId,
            }),
          ),
        );

        emit(GradeTrackerSectionState.error(e));
      }
    }
  }

  Future<void> deleteCourseTracking() async {
    final currentState = state;
    if (currentState is GradeTrackerSectionReadyState) {
      try {
        emit(const GradeTrackerSectionState.loading());

        await _deleteGradeTrackingUseCase(courseCode: _courseCode!);

        // Después de eliminar, volvemos al estado empty
        emit(const GradeTrackerSectionState.empty());
      } catch (e, s) {
        _logger.e(
          '[UI] Error deleting course tracking',
          error: e,
          stackTrace: s,
        );
        emit(GradeTrackerSectionState.error(e));
      }
    }
  }
}
