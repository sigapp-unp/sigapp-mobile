import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/usecases/get_course_view_mode_preferences_usecase.dart';
import 'package:sigapp/courses/application/usecases/set_course_view_mode_preferences_usecase.dart';
import 'package:sigapp/courses/application/usecases/get_highlight_critical_path_preferences_usecase.dart';
import 'package:sigapp/courses/application/usecases/set_highlight_critical_path_preferences_usecase.dart';
import 'package:sigapp/courses/domain/enums/course_view_mode.dart';
import 'package:sigapp/courses/domain/entities/program_curriculum_course_term.dart';

part 'course_chain_preferences_cubit.freezed.dart';

@freezed
abstract class CourseChainPreferencesState with _$CourseChainPreferencesState {
  const factory CourseChainPreferencesState({
    @Default(true) bool isLoading,
    @Default(CourseViewMode.tree) CourseViewMode viewMode,
    @Default(false) bool highlightCriticalPath,
    @Default({}) Set<String> criticalPathIds,
  }) = _CourseChainPreferencesState;
}

@injectable
class CourseChainPreferencesCubit extends Cubit<CourseChainPreferencesState> {
  final GetCourseViewModeUseCase _getViewModeUseCase;
  final SetCourseViewModePreferencesUseCase _setViewModeUseCase;
  final GetHighlightCriticalPathUseCase _getHighlightUseCase;
  final SetHighlightCriticalPathPreferencesUseCase _setHighlightUseCase;
  final Logger _logger;

  CourseChainPreferencesCubit(
    this._getViewModeUseCase,
    this._setViewModeUseCase,
    this._getHighlightUseCase,
    this._setHighlightUseCase,
    this._logger,
  ) : super(const CourseChainPreferencesState());

  /// Loads user preferences for course chain display
  Future<void> loadPreferences({CourseTreeNode? currentTree}) async {
    try {
      emit(state.copyWith(isLoading: true));

      final viewMode = await _getViewModeUseCase();
      final highlightCriticalPath = await _getHighlightUseCase();

      Set<String> criticalPathIds = {};
      if (highlightCriticalPath && currentTree != null) {
        final path = _findCriticalPath(currentTree);
        criticalPathIds = path.map((n) => n.course.info.courseCode).toSet();
      }

      emit(
        state.copyWith(
          isLoading: false,
          viewMode: viewMode,
          highlightCriticalPath: highlightCriticalPath,
          criticalPathIds: criticalPathIds,
        ),
      );

      _logger.d('[CUBIT] Course chain preferences loaded successfully');
    } catch (e, s) {
      _logger.e(
        '[CUBIT] Error loading course chain preferences',
        error: e,
        stackTrace: s,
      );
      emit(
        state.copyWith(
          isLoading: false,
          // Keep default values on error
        ),
      );
    }
  }

  /// Sets the view mode preference
  Future<void> setViewMode(CourseViewMode newMode) async {
    try {
      emit(state.copyWith(viewMode: newMode));
      await _setViewModeUseCase(newMode);

      _logger.d('[CUBIT] View mode updated to: ${newMode.value}');
    } catch (e, s) {
      _logger.e(
        '[CUBIT] Error setting view mode preference',
        error: e,
        stackTrace: s,
      );
      // Revert state on error
      emit(state.copyWith(viewMode: state.viewMode));
      rethrow;
    }
  }

  /// Toggles critical path highlighting
  Future<void> toggleCriticalPath({
    required CourseTreeNode? currentTree,
    required bool Function(CourseTreeNode?) isCriticalPathUseful,
  }) async {
    try {
      final newHighlightValue = !state.highlightCriticalPath;

      if (newHighlightValue) {
        // Activating critical path
        if (currentTree == null || !isCriticalPathUseful(currentTree)) {
          _logger.d(
            '[CUBIT] Critical path not activated - not useful for current tree',
          );
          return;
        }

        final path = _findCriticalPath(currentTree);
        final criticalPathIds =
            path.map((n) => n.course.info.courseCode).toSet();

        emit(
          state.copyWith(
            highlightCriticalPath: true,
            criticalPathIds: criticalPathIds,
          ),
        );
      } else {
        // Deactivating critical path
        emit(state.copyWith(highlightCriticalPath: false, criticalPathIds: {}));
      }

      await _setHighlightUseCase(newHighlightValue);
      _logger.d(
        '[CUBIT] Critical path highlight toggled to: $newHighlightValue',
      );
    } catch (e, s) {
      _logger.e(
        '[CUBIT] Error toggling critical path preference',
        error: e,
        stackTrace: s,
      );
      // Revert state on error
      emit(state.copyWith(highlightCriticalPath: !state.highlightCriticalPath));
      rethrow;
    }
  }

  /// Updates critical path IDs when tree changes (e.g., after filtering)
  void updateCriticalPath({
    required CourseTreeNode? currentTree,
    required bool Function(CourseTreeNode?) isCriticalPathUseful,
  }) {
    if (!state.highlightCriticalPath) return;

    if (currentTree == null || !isCriticalPathUseful(currentTree)) {
      // Disable critical path if no longer useful
      emit(state.copyWith(highlightCriticalPath: false, criticalPathIds: {}));
      // Fire and forget - don't await in synchronous method
      _setHighlightUseCase(false).catchError((e, s) {
        _logger.e(
          '[CUBIT] Error updating critical path preference',
          error: e,
          stackTrace: s,
        );
      });
    } else {
      // Recalculate critical path with current tree
      final path = _findCriticalPath(currentTree);
      final criticalPathIds = path.map((n) => n.course.info.courseCode).toSet();

      emit(state.copyWith(criticalPathIds: criticalPathIds));
    }
  }

  /// Finds the critical path (longest path) in the tree
  List<CourseTreeNode> _findCriticalPath(CourseTreeNode? node) {
    if (node == null) return [];
    if (node.children.isEmpty) return [node];

    List<CourseTreeNode> longest = [];
    for (final child in node.children) {
      final path = _findCriticalPath(child);
      if (path.length > longest.length) longest = path;
    }
    return [node, ...longest];
  }
}
