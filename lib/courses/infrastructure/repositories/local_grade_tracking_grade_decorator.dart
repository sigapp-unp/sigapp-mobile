import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/courses/infrastructure/services/grade_tracking_local_service.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Local decorator for Grade operations
/// Implements cache-first reads and optimistic updates for grade operations
@LazySingleton(as: GradeTrackingGradeRepository)
class LocalGradeTrackingGradeDecorator implements GradeTrackingGradeRepository {
  final GradeTrackingGradeRepository _remoteRepo;
  final GradeTrackingCourseRepository _courseRepo;
  final GradeTrackingLocalService _cacheService;
  final SyncManager _syncManager;
  final Logger _logger;

  LocalGradeTrackingGradeDecorator(
    @Named('remote') this._remoteRepo,
    @Named('remote') this._courseRepo,
    this._cacheService,
    this._syncManager,
    this._logger,
  );

  /// Unified helper for optimistic updates
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
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Get current state from cache or remote
      final current = await _courseRepo.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) throw Exception('Course tracking not found');

      // Apply optimistic update
      final updated = updateFunction(current);

      // Update cache
      await _cacheService.saveCourse(courseKey, updated);
      _logger.d('[GRADE_DECORATOR] Cache updated for $courseKey');

      // Enqueue sync operation
      try {
        final syncData = syncDataBuilder(updated);
        await _syncManager.enqueueSyncOperation(
          operationType: operationType,
          fieldType: 'grades',
          courseKey: courseKey,
          operationData: syncData,
        );

        final contextStr =
            logContext != null
                ? logContext.entries
                    .map((e) => '${e.key}=${e.value}')
                    .join(', ')
                : '';
        _logger.d(
          '[GRADE_DECORATOR] Sync enqueued: $operationType ($contextStr)',
        );
      } catch (syncError, syncStack) {
        _logger.e(
          '[GRADE_DECORATOR] Sync enqueue failed for $operationType, continuing with optimistic state',
          error: syncError,
          stackTrace: syncStack,
        );
      }

      return updated;
    } catch (e, s) {
      _logger.e(
        '[GRADE_DECORATOR] Error in $operationType',
        error: e,
        stackTrace: s,
      );
      // Fallback to remote operation
      final result = await remoteFallback();
      final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);
      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
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
          () => _remoteRepo.addGrade(
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
          () => _remoteRepo.deleteGrade(
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
          () => _remoteRepo.updateGrade(
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
          () => _remoteRepo.toggleGradeEnabled(
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
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Get current course to preserve other data
      final current = await _courseRepo.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) throw Exception('Course tracking not found');

      // Apply update with new grades for the specific category
      final updatedCategories =
          current.categories.map((cat) {
            if (cat.id == categoryId) {
              return cat.copyWith(grades: grades);
            }
            return cat;
          }).toList();

      final updated = current.copyWith(categories: updatedCategories);

      // Update cache
      await _cacheService.saveCourse(courseKey, updated);
      _logger.d(
        '[GRADE_DECORATOR] Grades field updated in cache for category $categoryId',
      );

      // Enqueue sync operation
      try {
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
      await _remoteRepo.updateGradesField(
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
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Get current course to preserve other data
      final current = await _courseRepo.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) throw Exception('Course tracking not found');

      // Apply updates with new grades for multiple categories
      final updatedCategories =
          current.categories.map((cat) {
            if (gradesByCategory.containsKey(cat.id)) {
              return cat.copyWith(grades: gradesByCategory[cat.id]!);
            }
            return cat;
          }).toList();

      final updated = current.copyWith(categories: updatedCategories);

      // Update cache
      await _cacheService.saveCourse(courseKey, updated);
      _logger.d(
        '[GRADE_DECORATOR] Multiple categories grades updated in cache',
      );

      // Enqueue sync operation
      try {
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
      await _remoteRepo.updateMultipleCategoriesGrades(
        studentCode: studentCode,
        courseCode: courseCode,
        gradesByCategory: gradesByCategory,
      );
    }
  }
}
