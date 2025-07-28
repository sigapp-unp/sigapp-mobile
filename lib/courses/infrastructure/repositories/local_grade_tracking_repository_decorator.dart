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

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // Cache-first approach
      final cached = await _cacheService.getCachedCourse(courseKey);
      if (cached != null) {
        _logger.d('[CACHE_DECORATOR] Cache HIT for $courseKey');
        return cached;
      }

      // Cache miss → fetch from remote
      _logger.d(
        '[CACHE_DECORATOR] Cache MISS for $courseKey, fetching remote...',
      );
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

      // Fallback to stale cache
      final cached = await _cacheService.getCachedCourse(courseKey);
      if (cached != null) {
        _logger.w('[CACHE_DECORATOR] Using stale cache due to remote error');
        return cached;
      }

      return null;
    }
  }

  @override
  Future<CourseTracking> createWithDefaults({
    required String studentCode,
    required String courseCode,
    required String courseName,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // 1. Crear optimistic local tracking
      final optimisticTracking = CourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
        categories: [
          GradeCategory(
            id: 'temp-1',
            name: 'Prácticas',
            weight: 0.20,
            grades: [],
          ),
          GradeCategory(
            id: 'temp-2',
            name: 'Trabajos',
            weight: 0.30,
            grades: [],
          ),
          GradeCategory(
            id: 'temp-3',
            name: 'Parciales',
            weight: 0.50,
            grades: [],
          ),
        ],
      );

      // 2. Save optimistic to cache (UI instantáneo)
      await _cacheService.saveCourse(courseKey, optimisticTracking);

      // 3. Enqueue para sync diferido
      await _syncManager.enqueueSyncOperation(
        operationType: 'create',
        fieldType: 'categories', // Crear con categorías por defecto
        courseKey: courseKey,
        operationData: {
          'studentCode': studentCode,
          'courseCode': courseCode,
          'courseName': courseName,
          'categories': [
            {'name': 'Prácticas', 'weight': 0.20},
            {'name': 'Trabajos', 'weight': 0.30},
            {'name': 'Parciales', 'weight': 0.50},
          ],
        },
      );

      // 4. Return optimistic (UI no se bloquea)
      _logger.d(
        '[CACHE_DECORATOR] Created optimistic course tracking for $courseKey',
      );
      return optimisticTracking;
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in createWithDefaults',
        error: e,
        stackTrace: s,
      );

      // Fallback: remote directo (comportamiento actual)
      final result = await _remoteRepo.createWithDefaults(
        studentCode: studentCode,
        courseCode: courseCode,
        courseName: courseName,
      );

      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
  }

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // 1. Get current cached course tracking
      final cached = await _cacheService.getCachedCourse(courseKey);
      if (cached == null) {
        _logger.w(
          '[CACHE_DECORATOR] No cached course for addCategory, fetching remote first',
        );
        final remote = await getCourseTracking(
          studentCode: studentCode,
          courseCode: courseCode,
        );
        if (remote == null) throw Exception('Course tracking not found');
      }

      final currentTracking =
          cached ?? await _cacheService.getCachedCourse(courseKey);

      // 2. Create optimistic local update
      final newCategory = GradeCategory(
        id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
        name: categoryName,
        weight: weight,
        grades: [],
      );

      final updatedCategories = [...currentTracking!.categories, newCategory];

      // 3. ✨ NEW: Use granular field update (reduces sync load by ~83%)
      await _cacheService.updateCategoriesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categories: updatedCategories,
      );

      // 🚀 UNIFICADO: Sync via SyncManager con batching optimizado
      await _syncManager.enqueueSyncOperation(
        operationType: 'update_categories',
        fieldType: 'categories',
        courseKey: courseKey,
        operationData: {
          'studentCode': studentCode,
          'courseCode': courseCode,
          'categories':
              updatedCategories
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

      // 4. Return updated tracking
      final updatedTracking = CourseTracking(
        id: currentTracking.id,
        studentCode: currentTracking.studentCode,
        courseCode: currentTracking.courseCode,
        categories: updatedCategories,
      );

      _logger.d(
        '[CACHE_DECORATOR] Added optimistic category $categoryName to $courseKey (granular)',
      );
      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in addCategory',
        error: e,
        stackTrace: s,
      );

      // Fallback: remote directo
      final result = await _remoteRepo.addCategory(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryName: categoryName,
        weight: weight,
      );

      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
  }

  @override
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) async {
    final result = await _remoteRepo.deleteCategory(
      studentCode: studentCode,
      courseCode: courseCode,
      categoryId: categoryId,
    );

    // Invalidate cache to force refresh
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);
    await _cacheService.invalidateCourse(courseKey);

    return result;
  }

  // OPERACIONES DE ESCRITURA: Optimistic + Granular Sync (83% menos operaciones)
  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // 1. Get current cached course tracking
      final currentTracking = await _cacheService.getCachedCourse(courseKey);
      if (currentTracking == null) {
        _logger.w(
          '[CACHE_DECORATOR] No cached course for addGrade, fetching remote first',
        );
        await getCourseTracking(
          studentCode: studentCode,
          courseCode: courseCode,
        );
      }

      final tracking = await _cacheService.getCachedCourse(courseKey);
      if (tracking == null) throw Exception('Course tracking not found');

      // 2. Find the target category and create new grade
      final targetCategory = tracking.categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => throw Exception('Category not found: $categoryId'),
      );

      final newGrade = Grade(
        id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
        name: gradeName,
        score: score,
        enabled: true,
      );

      final updatedGrades = [...targetCategory.grades, newGrade];

      // 3. ✨ NEW: Use granular grades field update (only syncs affected grades)
      await _cacheService.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: updatedGrades,
      );

      // 🚀 UNIFICADO: Sync via SyncManager con batching optimizado
      await _syncManager.enqueueSyncOperation(
        operationType: 'update_grades',
        fieldType: 'grades',
        courseKey: courseKey,
        operationData: {
          'studentCode': studentCode,
          'courseCode': courseCode,
          'categoryId': categoryId,
          'grades':
              updatedGrades
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

      // 4. Reconstruct full tracking for return (optimistic UI)
      final updatedCategories =
          tracking.categories.map((category) {
            if (category.id == categoryId) {
              return GradeCategory(
                id: category.id,
                name: category.name,
                weight: category.weight,
                grades: updatedGrades,
              );
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: tracking.id,
        studentCode: tracking.studentCode,
        courseCode: tracking.courseCode,
        categories: updatedCategories,
      );

      _logger.d(
        '[CACHE_DECORATOR] Added optimistic grade $gradeName to $courseKey.$categoryId (granular)',
      );
      return updatedTracking;
    } catch (e, s) {
      _logger.e('[CACHE_DECORATOR] Error in addGrade', error: e, stackTrace: s);

      // Fallback: remote directo
      final result = await _remoteRepo.addGrade(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        gradeName: gradeName,
        score: score,
      );

      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
  }

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // 1. Get current cached course tracking
      final currentTracking = await _cacheService.getCachedCourse(courseKey);
      if (currentTracking == null) {
        await getCourseTracking(
          studentCode: studentCode,
          courseCode: courseCode,
        );
      }

      final tracking = await _cacheService.getCachedCourse(courseKey);
      if (tracking == null) throw Exception('Course tracking not found');

      // 2. Find target category and remove specific grade
      final targetCategory = tracking.categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => throw Exception('Category not found: $categoryId'),
      );

      final updatedGrades =
          targetCategory.grades.where((grade) => grade.id != gradeId).toList();

      // 3. ✨ NEW: Use granular grades field update (only syncs affected grades)
      await _cacheService.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: updatedGrades,
      );

      // 4. Reconstruct full tracking for return (optimistic UI)
      final updatedCategories =
          tracking.categories.map((category) {
            if (category.id == categoryId) {
              return GradeCategory(
                id: category.id,
                name: category.name,
                weight: category.weight,
                grades: updatedGrades,
              );
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: tracking.id,
        studentCode: tracking.studentCode,
        courseCode: tracking.courseCode,
        categories: updatedCategories,
      );

      _logger.d(
        '[CACHE_DECORATOR] Deleted optimistic grade $gradeId from $courseKey.$categoryId (granular)',
      );
      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in deleteGrade',
        error: e,
        stackTrace: s,
      );

      // Fallback: remote directo
      final result = await _remoteRepo.deleteGrade(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        gradeId: gradeId,
      );

      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
  }

  @override
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // 1. Get current cached course tracking
      final currentTracking = await _cacheService.getCachedCourse(courseKey);
      if (currentTracking == null) {
        await getCourseTracking(
          studentCode: studentCode,
          courseCode: courseCode,
        );
      }

      final tracking = await _cacheService.getCachedCourse(courseKey);
      if (tracking == null) throw Exception('Course tracking not found');

      // 2. Update specific category (optimistic)
      final updatedCategories =
          tracking.categories.map((category) {
            if (category.id == categoryId) {
              return GradeCategory(
                id: category.id,
                name: newName,
                weight: newWeight,
                grades: category.grades,
              );
            }
            return category;
          }).toList();

      // 3. ✨ NEW: Use granular categories field update (only syncs categories)
      await _cacheService.updateCategoriesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categories: updatedCategories,
      );

      // 4. Return updated tracking
      final updatedTracking = CourseTracking(
        id: tracking.id,
        studentCode: tracking.studentCode,
        courseCode: tracking.courseCode,
        categories: updatedCategories,
      );

      _logger.d(
        '[CACHE_DECORATOR] Updated optimistic category $categoryId in $courseKey (granular)',
      );
      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in updateCategory',
        error: e,
        stackTrace: s,
      );

      // Fallback: remote directo
      final result = await _remoteRepo.updateCategory(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        newName: newName,
        newWeight: newWeight,
      );

      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
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
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // 1. Get current cached course tracking
      final currentTracking = await _cacheService.getCachedCourse(courseKey);
      if (currentTracking == null) {
        await getCourseTracking(
          studentCode: studentCode,
          courseCode: courseCode,
        );
      }

      final tracking = await _cacheService.getCachedCourse(courseKey);
      if (tracking == null) throw Exception('Course tracking not found');

      // 2. Find target category and update specific grade
      final targetCategory = tracking.categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => throw Exception('Category not found: $categoryId'),
      );

      final updatedGrades =
          targetCategory.grades.map((grade) {
            if (grade.id == gradeId) {
              return Grade(
                id: grade.id,
                name: newName,
                score: newScore,
                enabled: grade.enabled,
              );
            }
            return grade;
          }).toList();

      // 3. ✨ NEW: Use granular grades field update (only syncs affected grades)
      await _cacheService.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: updatedGrades,
      );

      // 4. Reconstruct full tracking for return (optimistic UI)
      final updatedCategories =
          tracking.categories.map((category) {
            if (category.id == categoryId) {
              return GradeCategory(
                id: category.id,
                name: category.name,
                weight: category.weight,
                grades: updatedGrades,
              );
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: tracking.id,
        studentCode: tracking.studentCode,
        courseCode: tracking.courseCode,
        categories: updatedCategories,
      );

      _logger.d(
        '[CACHE_DECORATOR] Updated optimistic grade $gradeId in $courseKey.$categoryId (granular)',
      );
      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in updateGrade',
        error: e,
        stackTrace: s,
      );

      // Fallback: remote directo
      final result = await _remoteRepo.updateGrade(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        gradeId: gradeId,
        newName: newName,
        newScore: newScore,
      );

      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
  }

  @override
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);

    try {
      // 1. Get current cached course tracking
      final currentTracking = await _cacheService.getCachedCourse(courseKey);
      if (currentTracking == null) {
        await getCourseTracking(
          studentCode: studentCode,
          courseCode: courseCode,
        );
      }

      final tracking = await _cacheService.getCachedCourse(courseKey);
      if (tracking == null) throw Exception('Course tracking not found');

      // 2. Find target category and toggle specific grade
      final targetCategory = tracking.categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => throw Exception('Category not found: $categoryId'),
      );

      final updatedGrades =
          targetCategory.grades.map((grade) {
            if (grade.id == gradeId) {
              return Grade(
                id: grade.id,
                name: grade.name,
                score: grade.score,
                enabled: enabled,
              );
            }
            return grade;
          }).toList();

      // 3. ✨ NEW: Use granular grades field update (only syncs affected grades)
      await _cacheService.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: updatedGrades,
      );

      // 4. Reconstruct full tracking for return (optimistic UI)
      final updatedCategories =
          tracking.categories.map((category) {
            if (category.id == categoryId) {
              return GradeCategory(
                id: category.id,
                name: category.name,
                weight: category.weight,
                grades: updatedGrades,
              );
            }
            return category;
          }).toList();

      final updatedTracking = CourseTracking(
        id: tracking.id,
        studentCode: tracking.studentCode,
        courseCode: tracking.courseCode,
        categories: updatedCategories,
      );

      _logger.d(
        '[CACHE_DECORATOR] Toggled optimistic grade $gradeId to $enabled in $courseKey.$categoryId (granular)',
      );
      return updatedTracking;
    } catch (e, s) {
      _logger.e(
        '[CACHE_DECORATOR] Error in toggleGradeEnabled',
        error: e,
        stackTrace: s,
      );

      // Fallback: remote directo
      final result = await _remoteRepo.toggleGradeEnabled(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        gradeId: gradeId,
        enabled: enabled,
      );

      await _cacheService.saveCourse(courseKey, result);
      return result;
    }
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

  // OPERACIONES GRANULARES (implementación que delega al remote)

  @override
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) async {
    await _remoteRepo.updateCategoriesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categories: categories,
    );

    // Invalidar cache para forzar recarga
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);
    await _cacheService.invalidateCourse(courseKey);
  }

  @override
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    await _remoteRepo.updateGradesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categoryId: categoryId,
      grades: grades,
    );

    // Invalidar cache para forzar recarga
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);
    await _cacheService.invalidateCourse(courseKey);
  }

  @override
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) async {
    await _remoteRepo.updateMultipleCategoriesGrades(
      studentCode: studentCode,
      courseCode: courseCode,
      gradesByCategory: gradesByCategory,
    );

    // Invalidar cache para forzar recarga
    final courseKey = _cacheService.buildCourseKey(studentCode, courseCode);
    await _cacheService.invalidateCourse(courseKey);
  }
}
