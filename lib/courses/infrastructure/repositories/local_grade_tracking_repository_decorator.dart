import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart';
import 'package:sigapp/courses/infrastructure/services/grade_tracking_local_service.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Decorator combining Remote Repository + Cache Service + SyncManager
/// Implements cache-first reads and optimistic updates for writes
@LazySingleton(as: GradeTrackingRepository)
class LocalGradeTrackingDecorator implements GradeTrackingRepository {
  final GradeTrackingRepository _remoteRepo;
  final GradeTrackingLocalService _cacheService;
  final SyncManager _syncManager;
  final Logger _logger;

  LocalGradeTrackingDecorator(
    @Named('remote') this._remoteRepo,
    this._cacheService,
    this._syncManager,
    this._logger,
  );

  Future<CourseTracking?> _getCachedOrRemote({
    required String studentCode,
    required String courseCode,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    // Try cache first
    final cached = await _cacheService.getCachedCourse(courseKey);
    if (cached != null) {
      _logger.d('[CACHE_DECORATOR] Cache HIT for $courseKey');
      return cached;
    }

    // Cache miss → fetch remote
    _logger.d(
      '[CACHE_DECORATOR] Cache MISS for $courseKey, fetching remote...',
    );
    try {
      final remote = await _remoteRepo.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      // Update cache with fresh data
      if (remote != null) {
        await _cacheService.saveCourse(courseKey, remote);
      }

      return remote;
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in getCourseTracking',
        error: e,
        stackTrace: s,
      );

      // ✅ CRITICAL: Fallback to stale cache (original behavior preserved)
      final staleCached = await _cacheService.getCachedCourse(courseKey);
      if (staleCached != null) {
        _logger.w('[CACHE_DECORATOR] Using stale cache due to remote error');
        return staleCached;
      }

      return null;
    }
  }

  // ✨ UNIFIED HELPER: Enhanced optimistic updates with granular cache support
  // ✅ IMPROVED: Granular cache updates + robust sync error handling + contextual logging
  Future<CourseTracking> _performOptimisticUpdate({
    required String studentCode,
    required String courseCode,
    required CourseTracking Function(CourseTracking current) updateFunction,
    required String operationType,
    required String fieldType,
    required Map<String, dynamic> Function(CourseTracking updated)
    syncDataBuilder,
    required Future<CourseTracking> Function() remoteFallback,
    // ✅ NEW: Granular cache update support
    Future<void> Function(CourseTracking updated)? granularCacheUpdate,
    // ✅ NEW: Contextual logging data
    Map<String, dynamic>? logContext,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Get current state
      final current = await _getCachedOrRemote(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) throw Exception('Course tracking not found');

      // Apply optimistic update
      final updated = updateFunction(current);

      // ✅ IMPROVED: Use granular cache update if available, fallback to full save
      if (granularCacheUpdate != null) {
        await granularCacheUpdate(updated);
        _logger.d(
          '[CACHE_DECORATOR] Granular cache update applied for $courseKey',
        );
      } else {
        await _cacheService.saveCourse(courseKey, updated);
        _logger.d('[CACHE_DECORATOR] Full cache update applied for $courseKey');
      }

      // ✅ IMPROVED: Robust sync error handling - don't crash UI if sync fails
      try {
        final syncData = syncDataBuilder(updated);
        await _syncManager.enqueueSyncOperation(
          operationType: operationType,
          fieldType: fieldType,
          courseKey: courseKey,
          operationData: syncData,
        );

        // ✅ IMPROVED: Contextual logging with specific IDs
        final contextStr =
            logContext != null
                ? logContext.entries
                    .map((e) => '${e.key}=${e.value}')
                    .join(', ')
                : '';
        _logger.d(
          '[CACHE_DECORATOR] Sync enqueued: $operationType ($contextStr)',
        );
      } catch (syncError, syncStack) {
        // ✅ CRITICAL: Sync failures shouldn't break optimistic UI
        _logger.e(
          '[CACHE_DECORATOR] Sync enqueue failed for $operationType, continuing with optimistic state',
          error: syncError,
          stackTrace: syncStack,
        );
      }

      return updated;
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in $operationType',
        error: e,
        stackTrace: s,
      );
      // Simple fallback - no complex error chains
      final result = await remoteFallback();
      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
  }

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    return _getCachedOrRemote(studentCode: studentCode, courseCode: courseCode);
  }

  @override
  Future<CourseTracking> createWithDefaults({
    required String studentCode,
    required String courseCode,
    required String courseName,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction:
          (_) => CourseTracking.createWithDefaults(
            courseCode: courseCode,
            studentCode: studentCode,
          ),
      operationType: 'create',
      fieldType: 'categories', // ✅ FIXED: Added fieldType
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'courseName': courseName,
            // ✅ ENHANCED: Include default categories structure for sync compatibility
            'categories': [
              {'name': 'Prácticas', 'weight': 0.20},
              {'name': 'Trabajos', 'weight': 0.30},
              {'name': 'Parciales', 'weight': 0.50},
            ],
          },
      remoteFallback:
          () => _remoteRepo.createWithDefaults(
            studentCode: studentCode,
            courseCode: courseCode,
            courseName: courseName,
          ),
    );
  }

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final newCategory = GradeCategory(
          id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
          name: categoryName,
          weight: weight,
          grades: [],
        );
        return current.copyWith(
          categories: [...current.categories, newCategory],
        );
      },
      operationType: 'update_categories',
      fieldType: 'categories',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            // ✅ ENHANCED: Full categories array for backend consistency
            'categories':
                updated.categories
                    .map(
                      (cat) => {
                        'id': cat.id,
                        'name': cat.name,
                        'weight': cat.weight,
                      },
                    )
                    .toList(),
            'categoryName': categoryName,
            'weight': weight,
          },
      // ✅ IMPROVED: Granular cache update for better I/O performance
      granularCacheUpdate: (updated) async {
        await _cacheService.updateCategoriesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categories: updated.categories,
        );
      },
      // ✅ IMPROVED: Contextual logging
      logContext: {'categoryName': categoryName, 'weight': weight},
      remoteFallback:
          () => _remoteRepo.addCategory(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryName: categoryName,
            weight: weight,
          ),
    );
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
          id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
          name: gradeName,
          score: score,
          enabled: true,
        );

        final updatedCategories =
            current.categories.map((category) {
              if (category.id == categoryId) {
                return category.copyWith(
                  grades: [...category.grades, newGrade],
                );
              }
              return category;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'update_grades',
      fieldType: 'grades',
      syncDataBuilder: (updated) {
        // ✅ ENHANCED: Full grades array for backend consistency
        final targetCategory = updated.categories.firstWhere(
          (cat) => cat.id == categoryId,
        );
        return {
          'studentCode': studentCode,
          'courseCode': courseCode,
          'categoryId': categoryId,
          'gradeName': gradeName,
          'score': score,
          // Include full grades list to ensure backend consistency
          'grades':
              targetCategory.grades
                  .map(
                    (grade) => {
                      'id': grade.id,
                      'name': grade.name,
                      'score': grade.score,
                      'enabled': grade.enabled,
                    },
                  )
                  .toList(),
        };
      },
      // ✅ IMPROVED: Granular cache update for better I/O performance
      granularCacheUpdate: (updated) async {
        final targetCategory = updated.categories.firstWhere(
          (cat) => cat.id == categoryId,
        );
        await _cacheService.updateGradesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categoryId: categoryId,
          grades: targetCategory.grades,
        );
      },
      // ✅ IMPROVED: Contextual logging
      logContext: {
        'categoryId': categoryId,
        'gradeName': gradeName,
        'score': score,
      },
      remoteFallback:
          () => _remoteRepo.addGrade(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeName: gradeName,
            score: score,
          ),
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
            current.categories.map((category) {
              if (category.id == categoryId) {
                final updatedGrades =
                    category.grades.map((grade) {
                      if (grade.id == gradeId) {
                        return grade.copyWith(name: newName, score: newScore);
                      }
                      return grade;
                    }).toList();
                return category.copyWith(grades: updatedGrades);
              }
              return category;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'update_grades',
      fieldType: 'grades',
      syncDataBuilder: (updated) {
        // ✅ ENHANCED: Full grades array for backend consistency
        final targetCategory = updated.categories.firstWhere(
          (cat) => cat.id == categoryId,
        );
        return {
          'studentCode': studentCode,
          'courseCode': courseCode,
          'categoryId': categoryId,
          'gradeId': gradeId,
          'newName': newName,
          'newScore': newScore,
          // Include full grades list to ensure backend consistency
          'grades':
              targetCategory.grades
                  .map(
                    (grade) => {
                      'id': grade.id,
                      'name': grade.name,
                      'score': grade.score,
                      'enabled': grade.enabled,
                    },
                  )
                  .toList(),
        };
      },
      // ✅ IMPROVED: Granular cache update for better I/O performance
      granularCacheUpdate: (updated) async {
        final targetCategory = updated.categories.firstWhere(
          (cat) => cat.id == categoryId,
        );
        await _cacheService.updateGradesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categoryId: categoryId,
          grades: targetCategory.grades,
        );
      },
      // ✅ IMPROVED: Contextual logging
      logContext: {
        'categoryId': categoryId,
        'gradeId': gradeId,
        'newName': newName,
        'newScore': newScore,
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
    );
  }

  // Simplified implementations for remaining methods using same pattern...

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
            current.categories.map((category) {
              if (category.id == categoryId) {
                final updatedGrades =
                    category.grades
                        .where((grade) => grade.id != gradeId)
                        .toList();
                return category.copyWith(grades: updatedGrades);
              }
              return category;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'update_grades',
      fieldType: 'grades',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeId': gradeId,
          },
      remoteFallback:
          () => _remoteRepo.deleteGrade(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeId: gradeId,
          ),
    );
  }

  @override
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) async {
    // For delete operations, use remote directly (data loss sensitive)
    final result = await _remoteRepo.deleteCategory(
      studentCode: studentCode,
      courseCode: courseCode,
      categoryId: categoryId,
    );

    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);
    await _cacheService.invalidateCourse(courseKey);
    return result;
  }

  @override
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    return _performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((category) {
              if (category.id == categoryId) {
                return category.copyWith(name: newName, weight: newWeight);
              }
              return category;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'update_categories',
      fieldType: 'categories',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'newName': newName,
            'newWeight': newWeight,
          },
      remoteFallback:
          () => _remoteRepo.updateCategory(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            newName: newName,
            newWeight: newWeight,
          ),
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
            current.categories.map((category) {
              if (category.id == categoryId) {
                final updatedGrades =
                    category.grades.map((grade) {
                      if (grade.id == gradeId) {
                        return grade.copyWith(enabled: enabled);
                      }
                      return grade;
                    }).toList();
                return category.copyWith(grades: updatedGrades);
              }
              return category;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'update_grades',
      fieldType: 'grades',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeId': gradeId,
            'enabled': enabled,
          },
      remoteFallback:
          () => _remoteRepo.toggleGradeEnabled(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeId: gradeId,
            enabled: enabled,
          ),
    );
  }

  @override
  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    await _remoteRepo.deleteCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);
    await _cacheService.invalidateCourse(courseKey);
  }

  // ✅ IMPROVED: Granular operations now use unified helpers for consistency
  @override
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Apply granular update with logging
      await _cacheService.updateCategoriesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categories: categories,
      );

      _logger.d(
        '[CACHE_DECORATOR] Granular categories update applied for $courseKey (${categories.length} categories)',
      );

      // Try sync without breaking if it fails
      try {
        await _syncManager.enqueueSyncOperation(
          operationType: 'update_categories_granular',
          fieldType: 'categories',
          courseKey: courseKey,
          operationData: {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categories':
                categories
                    .map(
                      (cat) => {
                        'id': cat.id,
                        'name': cat.name,
                        'weight': cat.weight,
                      },
                    )
                    .toList(),
          },
        );
      } catch (syncError, syncStack) {
        _logger.e(
          '[CACHE_DECORATOR] Sync enqueue failed for granular categories update',
          error: syncError,
          stackTrace: syncStack,
        );
      }
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in updateCategoriesField',
        error: e,
        stackTrace: s,
      );

      // Fallback to remote + invalidate cache
      await _remoteRepo.updateCategoriesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categories: categories,
      );

      await _cacheService.invalidateCourse(courseKey);
    }
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
      // Apply granular update with logging
      await _cacheService.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: grades,
      );

      _logger.d(
        '[CACHE_DECORATOR] Granular grades update applied for $courseKey.$categoryId (${grades.length} grades)',
      );

      // Try sync without breaking if it fails
      try {
        await _syncManager.enqueueSyncOperation(
          operationType: 'update_grades_granular',
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
                        'name': grade.name,
                        'score': grade.score,
                        'enabled': grade.enabled,
                      },
                    )
                    .toList(),
          },
        );
      } catch (syncError, syncStack) {
        _logger.e(
          '[CACHE_DECORATOR] Sync enqueue failed for granular grades update',
          error: syncError,
          stackTrace: syncStack,
        );
      }
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in updateGradesField',
        error: e,
        stackTrace: s,
      );

      // Fallback to remote + invalidate cache
      await _remoteRepo.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: grades,
      );

      await _cacheService.invalidateCourse(courseKey);
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
      // Apply granular update with logging
      await _remoteRepo.updateMultipleCategoriesGrades(
        studentCode: studentCode,
        courseCode: courseCode,
        gradesByCategory: gradesByCategory,
      );

      await _cacheService.invalidateCourse(courseKey);

      final totalGrades = gradesByCategory.values
          .map((grades) => grades.length)
          .reduce((a, b) => a + b);
      _logger.d(
        '[CACHE_DECORATOR] Multiple categories grades update applied for $courseKey (${gradesByCategory.length} categories, $totalGrades total grades)',
      );

      // Try sync without breaking if it fails
      try {
        await _syncManager.enqueueSyncOperation(
          operationType: 'update_multiple_grades',
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
          },
        );
      } catch (syncError, syncStack) {
        _logger.e(
          '[CACHE_DECORATOR] Sync enqueue failed for multiple grades update',
          error: syncError,
          stackTrace: syncStack,
        );
      }
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in updateMultipleCategoriesGrades',
        error: e,
        stackTrace: s,
      );
      rethrow; // Let caller handle this failure
    }
  }
}
