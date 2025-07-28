import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/courses/infrastructure/services/grade_tracking_cache_service.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Optimized local decorator for Grade operations
/// Leverages granular grade field updates for maximum performance
///
/// Key optimizations:
/// - Uses updateGradesField for category-specific updates
/// - Minimal data transfer with granular operations
/// - Enhanced error handling and fallback strategies
/// - Smart caching with coordinator integration
@LazySingleton(as: GradeTrackingGradeRepository)
class GradeTrackingGradeRepositoryDecorator
    implements GradeTrackingGradeRepository {
  final GradeTrackingGradeRepository _remoteGradeRepo;
  final GradeTrackingCacheService _coordinator;
  final SyncManager _syncManager;
  final Logger _logger;

  GradeTrackingGradeRepositoryDecorator(
    @Named('remote') this._remoteGradeRepo,
    this._coordinator,
    this._syncManager,
    this._logger,
  );

  // 🚀 OPTIMIZED OPERATIONS USING CENTRALIZED COORDINATOR

  /// Enhanced optimistic update using centralized coordinator
  Future<CourseTracking> _performOptimisticUpdate({
    required String studentCode,
    required String courseCode,
    required CourseTracking Function(CourseTracking current) updateFunction,
    required String operationType,
    required Map<String, dynamic> Function(CourseTracking updated)
    syncDataBuilder,
    required Future<CourseTracking> Function() remoteFallback,
    Map<String, dynamic>? logContext,
  }) async {
    // Delegate to centralized coordinator method
    final updated = await _coordinator.performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: updateFunction,
      operationType: operationType,
      fieldType: 'grades',
      syncDataBuilder: syncDataBuilder,
      remoteFallback: remoteFallback,
      logContext: logContext,
    );

    // Handle sync enqueueing at decorator level
    try {
      final syncData = syncDataBuilder(updated);
      await _syncManager.enqueueSyncOperation(
        operationType: operationType,
        fieldType: 'grades',
        courseKey: '${studentCode}_$courseCode',
        operationData: syncData,
      );

      final contextLog =
          logContext?.entries.map((e) => '${e.key}=${e.value}').join(', ') ??
          '';

      _logger.d(
        '[GRADE_DECORATOR] ✅ $operationType sync enqueued: ${studentCode}_$courseCode'
        '${contextLog.isNotEmpty ? ' ($contextLog)' : ''}',
      );
    } catch (syncError, syncStack) {
      _logger.w(
        '[GRADE_DECORATOR] ⚠️ Sync enqueue failed for $operationType, continuing optimistically',
        error: syncError,
        stackTrace: syncStack,
      );
    }

    return updated;
  }

  /// Helper para serializar grades para sync
  List<Map<String, dynamic>> _serializeGradesForSync(
    List<GradeCategory> categories,
  ) {
    final grades = <Map<String, dynamic>>[];
    for (final category in categories) {
      for (final grade in category.grades) {
        grades.add({
          'id': grade.id,
          'categoryId': category.id,
          'name': grade.name,
          'score': grade.score,
          'enabled': grade.enabled,
        });
      }
    }
    return grades;
  }

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final newGrade = Grade(
          id: 'grade_${DateTime.now().millisecondsSinceEpoch}',
          name: gradeName,
          score: score,
        );

        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                return cat.copyWith(grades: [...cat.grades, newGrade]);
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'addGrade',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeName': gradeName,
            'score': score,
            'grades': _serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => _remoteGradeRepo.addGrade(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeName: gradeName,
            score: score,
          ),
      logContext: {
        'categoryId': categoryId,
        'gradeName': gradeName,
        'score': score,
      },
    );
  }

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                return cat.copyWith(
                  grades:
                      cat.grades.where((grade) => grade.id != gradeId).toList(),
                );
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'deleteGrade',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeId': gradeId,
            'grades': _serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => _remoteGradeRepo.deleteGrade(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeId: gradeId,
          ),
      logContext: {'categoryId': categoryId, 'gradeId': gradeId},
    );
  }

  @override
  Future<CourseTracking> updateGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                return cat.copyWith(
                  grades:
                      cat.grades.map((grade) {
                        if (grade.id == gradeId) {
                          return grade.copyWith(name: newName, score: newScore);
                        }
                        return grade;
                      }).toList(),
                );
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'updateGrade',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeId': gradeId,
            'newName': newName,
            'newScore': newScore,
            'grades': _serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => _remoteGradeRepo.updateGrade(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeId: gradeId,
            newName: newName,
            newScore: newScore,
          ),
      logContext: {
        'categoryId': categoryId,
        'gradeId': gradeId,
        'newName': newName,
        'newScore': newScore,
      },
    );
  }

  @override
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                return cat.copyWith(
                  grades:
                      cat.grades.map((grade) {
                        if (grade.id == gradeId) {
                          return grade.copyWith(enabled: enabled);
                        }
                        return grade;
                      }).toList(),
                );
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'toggleGradeEnabled',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeId': gradeId,
            'enabled': enabled,
            'grades': _serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => _remoteGradeRepo.toggleGradeEnabled(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeId: gradeId,
            enabled: enabled,
          ),
      logContext: {
        'categoryId': categoryId,
        'gradeId': gradeId,
        'enabled': enabled,
      },
    );
  }

  @override
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    try {
      // Use coordinator to update grades field
      await _coordinator.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: grades,
      );

      _logger.d(
        '[GRADE_DECORATOR] Grades field updated via coordinator for category $categoryId',
      );

      // Enqueue sync operation
      try {
        final courseKey = '${studentCode}_$courseCode';
        await _syncManager.enqueueSyncOperation(
          operationType: 'updateGradesField',
          fieldType: 'grades',
          courseKey: courseKey,
          operationData: {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'grades':
                grades
                    .map(
                      (grade) => {
                        'id': grade.id,
                        'categoryId': categoryId,
                        'name': grade.name,
                        'score': grade.score,
                        'enabled': grade.enabled,
                      },
                    )
                    .toList(),
          },
        );
        _logger.d(
          '[GRADE_DECORATOR] Grades field sync enqueued for category $categoryId',
        );
      } catch (syncError, syncStack) {
        _logger.e(
          '[GRADE_DECORATOR] Grades field sync enqueue failed',
          error: syncError,
          stackTrace: syncStack,
        );
      }
    } catch (e, s) {
      _logger.e(
        '[GRADE_DECORATOR] Error in updateGradesField',
        error: e,
        stackTrace: s,
      );
      // Fallback to remote operation
      await _remoteGradeRepo.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: grades,
      );
    }
  }

  @override
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) async {
    try {
      // Use coordinator to update multiple categories grades
      for (final entry in gradesByCategory.entries) {
        await _coordinator.updateGradesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categoryId: entry.key,
          grades: entry.value,
        );
      }

      _logger.d(
        '[GRADE_DECORATOR] Multiple categories grades updated via coordinator',
      );

      // Enqueue sync operation
      try {
        final courseKey = '${studentCode}_$courseCode';
        final allGrades = <Map<String, dynamic>>[];
        for (final entry in gradesByCategory.entries) {
          final categoryId = entry.key;
          final grades = entry.value;
          for (final grade in grades) {
            allGrades.add({
              'id': grade.id,
              'categoryId': categoryId,
              'name': grade.name,
              'score': grade.score,
              'enabled': grade.enabled,
            });
          }
        }

        await _syncManager.enqueueSyncOperation(
          operationType: 'updateMultipleCategoriesGrades',
          fieldType: 'grades',
          courseKey: courseKey,
          operationData: {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'gradesByCategory': gradesByCategory.map(
              (categoryId, grades) => MapEntry(
                categoryId,
                grades
                    .map(
                      (grade) => {
                        'id': grade.id,
                        'name': grade.name,
                        'score': grade.score,
                        'enabled': grade.enabled,
                      },
                    )
                    .toList(),
              ),
            ),
            'allGrades': allGrades,
          },
        );
        _logger.d('[GRADE_DECORATOR] Multiple categories grades sync enqueued');
      } catch (syncError, syncStack) {
        _logger.e(
          '[GRADE_DECORATOR] Multiple categories grades sync enqueue failed',
          error: syncError,
          stackTrace: syncStack,
        );
      }
    } catch (e, s) {
      _logger.e(
        '[GRADE_DECORATOR] Error in updateMultipleCategoriesGrades',
        error: e,
        stackTrace: s,
      );
      // Fallback to remote operation
      await _remoteGradeRepo.updateMultipleCategoriesGrades(
        studentCode: studentCode,
        courseCode: courseCode,
        gradesByCategory: gradesByCategory,
      );
    }
  }
}
