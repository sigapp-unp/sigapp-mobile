import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/courses/infrastructure/repositories/local_grade_tracking_repository.dart';
import 'package:sigapp/courses/infrastructure/repositories/remote_grade_tracking_repository.dart';
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart';

/// Optimized local decorator for Grade operations
/// Leverages local cache repository and mapper for maximum performance
///
/// Key improvements:
/// - Direct integration with LocalGradeTrackingRepository
/// - Uses LocalGradeTrackingMapper for data transformations
/// - Simplified error handling with consistent logging
/// - Smart cache strategies with fallback mechanisms
@LazySingleton(as: GradeTrackingGradeRepository)
class GradeTrackingGradeRepositoryDecorator
    implements GradeTrackingGradeRepository {
  final RemoteGradeTrackingRepository _remoteRepository;
  final LocalGradeTrackingRepository _localRepository;
  final SyncManager _syncManager;
  final Logger _logger;

  GradeTrackingGradeRepositoryDecorator(
    this._remoteRepository,
    this._localRepository,
    this._syncManager,
    this._logger,
  );

  // 🚀 OPTIMIZED CACHE-FIRST OPERATIONS

  /// Save to cache with sync queue
  Future<void> _saveToCache({
    required String studentCode,
    required String courseCode,
    required CourseTracking tracking,
  }) async {
    try {
      await _localRepository.saveCourseFromComponents(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: tracking,
      );

      _logger.d(
        '[GRADE_DECORATOR] ✅ Saved to cache: ${studentCode}_$courseCode',
      );
    } catch (error, stackTrace) {
      _logger.e(
        '[GRADE_DECORATOR] ❌ Error saving to cache',
        error: error,
        stackTrace: stackTrace,
      );
      // Don't rethrow - cache errors shouldn't block operations
    }
  }

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    try {
      _logger.d(
        '[GRADE_DECORATOR] Adding grade: $gradeName to ${studentCode}_$courseCode',
      );

      // Try remote operation first for data consistency
      final result = await _remoteRepository.addGrade(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        gradeName: gradeName,
        score: score,
      );

      // Update cache
      await _saveToCache(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: result,
      );

      // Enqueue sync operation
      await _syncManager.enqueueSyncOperation(
        operationType: 'addGrade',
        fieldType: 'grades',
        courseKey: '${studentCode}_$courseCode',
        operationData: {
          'categoryId': categoryId,
          'gradeName': gradeName,
          'score': score,
        },
      );

      _logger.d('[GRADE_DECORATOR] ✅ Grade added successfully');
      return result;
    } catch (error, stackTrace) {
      _logger.e(
        '[GRADE_DECORATOR] ❌ Error adding grade',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
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
    try {
      _logger.d(
        '[GRADE_DECORATOR] Updating grade: $gradeId in ${studentCode}_$courseCode',
      );

      // Try remote operation first
      final result = await _remoteRepository.updateGrade(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        gradeId: gradeId,
        newName: newName,
        newScore: newScore,
      );

      // Update cache
      await _saveToCache(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: result,
      );

      // Enqueue sync operation
      await _syncManager.enqueueSyncOperation(
        operationType: 'updateGrade',
        fieldType: 'grades',
        courseKey: '${studentCode}_$courseCode',
        operationData: {
          'categoryId': categoryId,
          'gradeId': gradeId,
          'newName': newName,
          'newScore': newScore,
        },
      );

      _logger.d('[GRADE_DECORATOR] ✅ Grade updated successfully');
      return result;
    } catch (error, stackTrace) {
      _logger.e(
        '[GRADE_DECORATOR] ❌ Error updating grade',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    try {
      _logger.d(
        '[GRADE_DECORATOR] Deleting grade: $gradeId from ${studentCode}_$courseCode',
      );

      // Try remote operation first
      final result = await _remoteRepository.deleteGrade(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        gradeId: gradeId,
      );

      // Update cache
      await _saveToCache(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: result,
      );

      // Enqueue sync operation
      await _syncManager.enqueueSyncOperation(
        operationType: 'deleteGrade',
        fieldType: 'grades',
        courseKey: '${studentCode}_$courseCode',
        operationData: {'categoryId': categoryId, 'gradeId': gradeId},
      );

      _logger.d('[GRADE_DECORATOR] ✅ Grade deleted successfully');
      return result;
    } catch (error, stackTrace) {
      _logger.e(
        '[GRADE_DECORATOR] ❌ Error deleting grade',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
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
    try {
      _logger.d(
        '[GRADE_DECORATOR] Toggling grade enabled: $gradeId (enabled: $enabled)',
      );

      // Try remote operation first
      final result = await _remoteRepository.toggleGradeEnabled(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        gradeId: gradeId,
        enabled: enabled,
      );

      // Update cache
      await _saveToCache(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: result,
      );

      // Enqueue sync operation
      await _syncManager.enqueueSyncOperation(
        operationType: 'toggleGradeEnabled',
        fieldType: 'grades',
        courseKey: '${studentCode}_$courseCode',
        operationData: {
          'categoryId': categoryId,
          'gradeId': gradeId,
          'enabled': enabled,
        },
      );

      _logger.d(
        '[GRADE_DECORATOR] ✅ Grade enabled status toggled successfully',
      );
      return result;
    } catch (error, stackTrace) {
      _logger.e(
        '[GRADE_DECORATOR] ❌ Error toggling grade enabled status',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    try {
      _logger.d(
        '[GRADE_DECORATOR] Updating grades field for category: $categoryId',
      );

      // Remote operation
      await _remoteRepository.updateGradesField(
        studentCode: studentCode,
        courseCode: courseCode,
        categoryId: categoryId,
        grades: grades,
      );

      // Enqueue sync operation
      await _syncManager.enqueueSyncOperation(
        operationType: 'updateGradesField',
        fieldType: 'grades',
        courseKey: '${studentCode}_$courseCode',
        operationData: {
          'categoryId': categoryId,
          'grades':
              grades
                  .map(
                    (g) => {
                      'id': g.id,
                      'name': g.name,
                      'score': g.score,
                      'enabled': g.enabled,
                    },
                  )
                  .toList(),
        },
      );

      _logger.d('[GRADE_DECORATOR] ✅ Grades field updated successfully');
    } catch (error, stackTrace) {
      _logger.e(
        '[GRADE_DECORATOR] ❌ Error updating grades field',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) async {
    try {
      _logger.d('[GRADE_DECORATOR] Updating multiple categories grades');

      // Remote operation
      await _remoteRepository.updateMultipleCategoriesGrades(
        studentCode: studentCode,
        courseCode: courseCode,
        gradesByCategory: gradesByCategory,
      );

      // Enqueue sync operation
      await _syncManager.enqueueSyncOperation(
        operationType: 'updateMultipleCategoriesGrades',
        fieldType: 'grades',
        courseKey: '${studentCode}_$courseCode',
        operationData: {
          'gradesByCategory': gradesByCategory.map(
            (categoryId, grades) => MapEntry(
              categoryId,
              grades
                  .map(
                    (g) => {
                      'id': g.id,
                      'name': g.name,
                      'score': g.score,
                      'enabled': g.enabled,
                    },
                  )
                  .toList(),
            ),
          ),
        },
      );

      _logger.d(
        '[GRADE_DECORATOR] ✅ Multiple categories grades updated successfully',
      );
    } catch (error, stackTrace) {
      _logger.e(
        '[GRADE_DECORATOR] ❌ Error updating multiple categories grades',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
