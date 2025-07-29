import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/sync/infrastructure/repositories/sync_queue_repository.dart';
import 'dart:convert';
import 'dart:async';

@LazySingleton()
class GradeSimulatorSyncManager {
  final SyncQueueRepository _syncQueueRepository;
  final Logger _logger;
  final GradeTrackingCourseRepository _courseRepository;
  final GradeTrackingCategoryRepository _categoryRepository;
  final GradeTrackingGradeRepository _gradeRepository;

  // Core state (only what's needed)
  bool _isOfflineMode = false;
  Timer? _batchTimer;
  final List<Map<String, dynamic>> _pendingOperations = [];
  static const Duration _batchDebounceTime = Duration(seconds: 8);
  static const int _maxRetryAttempts = 2;
  static const Duration _retryDelay = Duration(milliseconds: 500);

  GradeSimulatorSyncManager(
    this._syncQueueRepository,
    this._logger,
    @Named('remote') this._courseRepository,
    @Named('remote') this._categoryRepository,
    @Named('remote') this._gradeRepository,
  );

  /// Parse courseKey consistently (studentCode_courseCode)
  (String studentCode, String courseCode) _parseCourseKey(String courseKey) {
    final parts = courseKey.split('_');
    if (parts.length != 2) {
      throw ArgumentError('Invalid courseKey format: $courseKey');
    }
    return (parts[0], parts[1]);
  }

  /// Enqueue operation with deduplication by courseKey
  Future<void> enqueueSyncOperation({
    required String operationType,
    required String fieldType,
    required String courseKey,
    required Map<String, dynamic> operationData,
  }) async {
    final newOperation = {
      'operation_type': operationType,
      'field_type': fieldType,
      'course_key': courseKey,
      'operation_data': operationData,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    // Deduplication: replace existing operation for same courseKey
    final existingIndex = _pendingOperations.indexWhere(
      (op) => op['course_key'] == courseKey,
    );

    if (existingIndex != -1) {
      _pendingOperations[existingIndex] = newOperation;
      _logger.d('[SYNC] Replaced operation for $courseKey');
    } else {
      _pendingOperations.add(newOperation);
      _logger.d('[SYNC] Queued $operationType for $courseKey');
    }

    // Crash protection: persist to SQLite
    await _syncQueueRepository.persistOperation(
      operationType: operationType,
      fieldType: fieldType,
      entityKey: courseKey,
      operationData: operationData,
    );

    // Restart debounce timer
    _batchTimer?.cancel();
    if (!_isOfflineMode) {
      _batchTimer = Timer(_batchDebounceTime, _processPendingOperations);
    }
  }

  /// Process all pending operations in batch
  Future<void> _processPendingOperations() async {
    if (_pendingOperations.isEmpty) return;

    _logger.i('[SYNC] Processing ${_pendingOperations.length} operations');

    try {
      // Group by course for efficiency
      final groupedByCourse = <String, List<Map<String, dynamic>>>{};
      for (final op in _pendingOperations) {
        final courseKey = op['course_key'] as String;
        groupedByCourse.putIfAbsent(courseKey, () => []).add(op);
      }

      // Process each course (using last operation = Last-Write-Wins)
      for (final entry in groupedByCourse.entries) {
        await _processCourseOperations(entry.key, entry.value.last);
      }

      // Clear processed operations
      _pendingOperations.clear();
      await _syncQueueRepository.cleanupCompletedOperations();

      // Simple tracking for debugging
      _operationsProcessed++;

      _logger.i('[SYNC] Batch completed successfully');
    } catch (e) {
      _failedOperations++;
      _logger.e('[SYNC] Batch failed: $e');
      _handleOfflineMode();
    }
  }

  /// Process single course operation with simple retry
  Future<void> _processCourseOperations(
    String courseKey,
    Map<String, dynamic> operation,
  ) async {
    final (studentCode, courseCode) = _parseCourseKey(courseKey);
    final operationType = operation['operation_type'] as String;
    final operationData = operation['operation_data'] as Map<String, dynamic>;

    // Simple retry logic
    for (var attempt = 1; attempt <= _maxRetryAttempts; attempt++) {
      try {
        await _executeRemoteOperation(
          operationType,
          studentCode,
          courseCode,
          operationData,
        );
        return; // Success
      } catch (e) {
        if (attempt == _maxRetryAttempts) {
          _logger.e('[SYNC] Final retry failed for $courseKey: $e');
          rethrow;
        }
        _logger.w('[SYNC] Retry $attempt failed for $courseKey: $e');
        await Future.delayed(_retryDelay);
      }
    }
  }

  /// Execute remote operation (same logic, no changes needed)
  Future<void> _executeRemoteOperation(
    String operationType,
    String studentCode,
    String courseCode,
    Map<String, dynamic> operationData,
  ) async {
    switch (operationType) {
      case 'create':
        final categories =
            (operationData['categories'] as List?)
                ?.map(
                  (cat) => GradeCategory(
                    id: cat['id'],
                    name: cat['name'],
                    weight: cat['weight'].toDouble(),
                    grades: _deserializeGradesForCategory(
                      cat['id'],
                      operationData['grades'] as List? ?? [],
                    ),
                  ),
                )
                .toList() ??
            [];

        final tracking = CourseTracking(
          studentCode: studentCode,
          courseCode: courseCode,
          categories: categories,
        );
        await _courseRepository.create(tracking);
        break;

      case 'addGrade':
      case 'updateGrade':
      case 'deleteGrade':
      case 'toggleGradeEnabled':
      case 'update_grades':
      case 'updateGradesField':
        final categoryId = operationData['categoryId'] as String;
        final grades =
            (operationData['grades'] as List)
                .map(
                  (grade) => Grade(
                    id: grade['id'],
                    name: grade['name'],
                    score: grade['score'].toDouble(),
                    enabled: grade['enabled'] ?? true,
                  ),
                )
                .toList();
        await _gradeRepository.updateGradesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categoryId: categoryId,
          grades: grades,
        );
        break;

      case 'addCategory':
      case 'deleteCategory':
      case 'updateCategory':
      case 'update_categories':
      case 'updateCategoriesField':
        final categories =
            (operationData['categories'] as List)
                .map(
                  (cat) => GradeCategory(
                    id: cat['id'],
                    name: cat['name'],
                    weight: cat['weight'].toDouble(),
                    grades: _deserializeGradesForCategory(
                      cat['id'],
                      operationData['grades'] as List? ?? [],
                    ),
                  ),
                )
                .toList();
        await _categoryRepository.updateCategoriesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categories: categories,
        );
        break;

      case 'update_multiple_grades':
        final gradesByCategory = (operationData['gradesByCategory']
                as Map<String, dynamic>)
            .map((categoryId, gradesList) {
              final grades =
                  (gradesList as List)
                      .map(
                        (grade) => Grade(
                          id: grade['id'],
                          name: grade['name'],
                          score: grade['score'].toDouble(),
                          enabled: grade['enabled'] ?? true,
                        ),
                      )
                      .toList();
              return MapEntry(categoryId, grades);
            });
        await _gradeRepository.updateMultipleCategoriesGrades(
          studentCode: studentCode,
          courseCode: courseCode,
          gradesByCategory: gradesByCategory,
        );
        break;

      default:
        _logger.w('[SYNC] Unknown operation: $operationType');
    }
  }

  /// Simple offline mode handling
  void _handleOfflineMode() {
    if (!_isOfflineMode) {
      _isOfflineMode = true;
      _batchTimer?.cancel();
      _logger.w('[SYNC] Entering offline mode');
    }
  }

  /// Check connectivity and resume sync (required for Escenario 5.4)
  Future<void> checkConnectivityRecovery() async {
    if (!_isOfflineMode) return;

    try {
      // Simple connectivity test
      await _courseRepository.getCourseTracking(
        studentCode: 'test',
        courseCode: 'ping',
      );

      _isOfflineMode = false;
      _logger.i('[SYNC] Connectivity restored');
      await processPendingOperations();
    } catch (e) {
      _logger.d('[SYNC] Still offline: ${e.runtimeType}');
    }
  }

  /// Process pending operations (public method)
  Future<void> processPendingOperations() async {
    try {
      await _processPendingOperations();
      await _processStoredOperations();
    } catch (e) {
      _logger.e('[SYNC] Error processing operations: $e');
    }
  }

  /// Process operations from SQLite (crash recovery)
  Future<void> _processStoredOperations() async {
    final operations = await _syncQueueRepository.getPendingOperations();
    if (operations.isEmpty) return;

    _logger.d('[SYNC] Processing ${operations.length} stored operations');

    for (final op in operations) {
      try {
        final operationData = jsonDecode(op.operationData);
        final (studentCode, courseCode) = _parseCourseKey(op.entityKey);

        await _executeRemoteOperation(
          op.operationType,
          studentCode,
          courseCode,
          operationData,
        );

        await _syncQueueRepository.markAsSynced(op.id);
      } catch (e) {
        await _syncQueueRepository.markAsFailed(op.id);
        _logger.e('[SYNC] Stored operation failed: $e');
      }
    }
  }

  /// Helper for grade deserialization
  List<Grade> _deserializeGradesForCategory(
    String categoryId,
    List<dynamic> gradesData,
  ) {
    return gradesData
        .where((grade) => grade['categoryId'] == categoryId)
        .map(
          (grade) => Grade(
            id: grade['id'],
            name: grade['name'],
            score: grade['score'].toDouble(),
            enabled: grade['enabled'] ?? true,
          ),
        )
        .toList();
  }

  // Minimal interface for external queries
  bool get isOfflineMode => _isOfflineMode;
  int get pendingOperationsCount => _pendingOperations.length;

  /// Simple stats for debugging (replaces complex dashboard)
  Map<String, dynamic> get basicStats => {
    'is_offline': _isOfflineMode,
    'pending_operations': _pendingOperations.length,
    'total_operations_processed': _operationsProcessed,
    'failed_operations': _failedOperations,
    'success_rate': _calculateSuccessRate(),
  };

  /// Compatibility getter for existing UI widgets
  Map<String, dynamic> get syncStats => basicStats;

  // Private tracking (minimal for debugging)
  int _operationsProcessed = 0;
  int _failedOperations = 0;

  String _calculateSuccessRate() {
    final total = _operationsProcessed + _failedOperations;
    if (total == 0) return '100%';
    return '${((_operationsProcessed / total) * 100).toStringAsFixed(0)}%';
  }
}
