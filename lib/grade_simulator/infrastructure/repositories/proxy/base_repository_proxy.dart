import 'dart:async';
import 'package:logger/logger.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/infrastructure/repositories/local/local_repository.dart';
import 'package:sigapp/grade_simulator/infrastructure/repositories/remote/remote_repository.dart';
import 'package:sigapp/sync/infrastructure/services/sync_manager.dart';

/// Base class for all GradeTracking repository decorators
/// Provides common functionality for optimistic updates, caching, and sync operations
///
/// Key features:
/// - Unified optimistic update pattern
/// - Consistent error handling with smart fallbacks
/// - Standardized caching operations
/// - Centralized sync enqueueing
/// - Structured logging with context
abstract class BaseGradeSimulatorRepositoryProxy {
  final RemoteGradeSimulatorRepository remoteRepository;
  final LocalGradeSimulatorRepository localRepository;
  final GradeSimulatorSyncManager syncManager;
  final Logger logger;

  /// Subclass identifier for logging (e.g., 'COURSE', 'CATEGORY', 'GRADE')
  String get decoratorType;

  BaseGradeSimulatorRepositoryProxy(
    this.remoteRepository,
    this.localRepository,
    this.syncManager,
    this.logger,
  );

  // 🚀 UNIFIED CACHE OPERATIONS

  /// Get course with intelligent cache-first strategy
  Future<CourseTracking?> getCachedOrRemote({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      // Try local cache first
      final cached = await localRepository.getCourse(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (cached != null) {
        logger.d('[$decoratorType] ✅ Cache HIT: ${studentCode}_$courseCode');
        return cached;
      }

      logger.d('[$decoratorType] ❌ Cache MISS: ${studentCode}_$courseCode');

      // Try remote fetch for Course decorator only
      if (decoratorType == 'COURSE') {
        return await _fetchRemoteAndCache(
          studentCode: studentCode,
          courseCode: courseCode,
        );
      }

      return null; // Category and Grade decorators let calling methods handle remote fetch
    } catch (error, stackTrace) {
      logger.e(
        '[$decoratorType] ❌ Error in cache-first strategy',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Fetch from remote and save to cache (for Course decorator)
  Future<CourseTracking?> _fetchRemoteAndCache({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      final remote = await remoteRepository.getCourseTracking(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (remote != null) {
        await saveCourseToLocal(
          studentCode: studentCode,
          courseCode: courseCode,
          tracking: remote,
        );
        logger.d(
          '[$decoratorType] ✅ Remote data cached: ${studentCode}_$courseCode',
        );
      }

      return remote;
    } catch (e, stackTrace) {
      logger.e(
        '[$decoratorType] ❌ Error fetching remote data',
        error: e,
        stackTrace: stackTrace,
      );

      // Smart fallback to stale cache
      try {
        final staleCache = await localRepository.getCourse(
          studentCode: studentCode,
          courseCode: courseCode,
        );

        if (staleCache != null) {
          logger.w(
            '[$decoratorType] ⚠️ Using stale cache as fallback: ${studentCode}_$courseCode',
          );
          return staleCache;
        }
      } catch (cacheError) {
        logger.e(
          '[$decoratorType] ❌ Stale cache fallback failed',
          error: cacheError,
        );
      }

      return null;
    }
  }

  /// Save course to local cache using mapper
  Future<void> saveCourseToLocal({
    required String studentCode,
    required String courseCode,
    required CourseTracking tracking,
  }) async {
    try {
      await localRepository.saveCourseFromComponents(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: tracking,
      );

      logger.d('[$decoratorType] ✅ Saved to cache: ${studentCode}_$courseCode');
    } catch (error, stackTrace) {
      logger.e(
        '[$decoratorType] ❌ Error saving to cache',
        error: error,
        stackTrace: stackTrace,
      );
      // Don't rethrow - cache errors shouldn't block operations
    }
  }

  // 🚀 UNIFIED OPTIMISTIC UPDATE PATTERN

  /// Enhanced optimistic update with local cache integration
  /// This is the core pattern used by Category and Course decorators
  Future<CourseTracking> performOptimisticUpdate({
    required String studentCode,
    required String courseCode,
    required CourseTracking Function(CourseTracking current) updateFunction,
    required String operationType,
    required String fieldType,
    required Map<String, dynamic> Function(CourseTracking updated)
    syncDataBuilder,
    required Future<CourseTracking> Function() remoteFallback,
    Map<String, dynamic>? logContext,
  }) async {
    try {
      // Get current tracking from cache
      CourseTracking? current = await getCachedOrRemote(
        studentCode: studentCode,
        courseCode: courseCode,
      );

      if (current == null) {
        logger.w(
          '[$decoratorType] ⚠️ No current tracking found, using remote fallback',
        );
        return await remoteFallback();
      }

      // Apply optimistic update
      final updated = updateFunction(current);

      // Save updated tracking to local cache
      await saveCourseToLocal(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: updated,
      );

      // Handle sync enqueueing
      await enqueueSyncOperation(
        operationType: operationType,
        fieldType: fieldType,
        studentCode: studentCode,
        courseCode: courseCode,
        syncDataBuilder: () => syncDataBuilder(updated),
        logContext: logContext,
      );

      return updated;
    } catch (e, stackTrace) {
      logger.e(
        '[$decoratorType] ❌ Optimistic update failed, using remote fallback',
        error: e,
        stackTrace: stackTrace,
      );
      return await remoteFallback();
    }
  }

  // 🚀 UNIFIED REMOTE-FIRST PATTERN (for Grade operations)

  /// Remote-first operation with cache update and sync enqueueing
  /// This pattern ensures data consistency for critical operations
  Future<CourseTracking> performRemoteFirstOperation({
    required String studentCode,
    required String courseCode,
    required String operationType,
    required String fieldType,
    required Future<CourseTracking> Function() remoteOperation,
    required Map<String, dynamic> operationData,
    Map<String, dynamic>? logContext,
  }) async {
    try {
      logger.d(
        '[$decoratorType] Starting $operationType: ${studentCode}_$courseCode',
      );

      // Execute remote operation first
      final result = await remoteOperation();

      // Update cache with result
      await saveCourseToLocal(
        studentCode: studentCode,
        courseCode: courseCode,
        tracking: result,
      );

      // Enqueue sync operation
      await enqueueSyncOperation(
        operationType: operationType,
        fieldType: fieldType,
        studentCode: studentCode,
        courseCode: courseCode,
        syncDataBuilder: () => operationData,
        logContext: logContext,
      );

      logger.d('[$decoratorType] ✅ $operationType completed successfully');
      return result;
    } catch (error, stackTrace) {
      logger.e(
        '[$decoratorType] ❌ Error in $operationType',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // 🚀 UNIFIED SYNC ENQUEUEING

  /// Centralized sync operation enqueueing with consistent error handling
  Future<void> enqueueSyncOperation({
    required String operationType,
    required String fieldType,
    required String studentCode,
    required String courseCode,
    required Map<String, dynamic> Function() syncDataBuilder,
    Map<String, dynamic>? logContext,
  }) async {
    try {
      final syncData = syncDataBuilder();
      await syncManager.enqueueSyncOperation(
        operationType: operationType,
        fieldType: fieldType,
        courseKey: '${studentCode}_$courseCode',
        operationData: syncData,
      );

      final contextLog =
          logContext?.entries.map((e) => '${e.key}=${e.value}').join(', ') ??
          '';

      logger.d(
        '[$decoratorType] ✅ $operationType sync enqueued: ${studentCode}_$courseCode'
        '${contextLog.isNotEmpty ? ' ($contextLog)' : ''}',
      );
    } catch (syncError, syncStack) {
      logger.w(
        '[$decoratorType] ⚠️ Sync enqueue failed for $operationType, continuing optimistically',
        error: syncError,
        stackTrace: syncStack,
      );
    }
  }

  // 🚀 UTILITY METHODS

  /// Helper to serialize grades for sync operations
  List<Map<String, dynamic>> serializeGradesForSync(
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

  /// Helper to serialize categories for sync operations
  List<Map<String, dynamic>> serializeCategoriesForSync(
    List<GradeCategory> categories,
  ) {
    return categories
        .map((cat) => {'id': cat.id, 'name': cat.name, 'weight': cat.weight})
        .toList();
  }
}
