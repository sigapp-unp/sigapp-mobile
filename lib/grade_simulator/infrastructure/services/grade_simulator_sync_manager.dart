import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/sync/infrastructure/repositories/sync_queue_repository.dart';
import 'dart:async';

import 'package:sigapp/sync/infrastructure/services/sync_manager.dart';

@LazySingleton()
class GradeSimulatorSyncManager implements ISyncManager, DomainSyncAdapter {
  late final SyncEngine _engine;
  final SyncQueueRepository _queue;
  final Logger _logger;
  final GradeTrackingCourseRepository _courses;
  final GradeTrackingCategoryRepository _cats;
  final GradeTrackingGradeRepository _grades;

  GradeSimulatorSyncManager(
    this._queue,
    this._logger,
    @Named('remote') this._courses,
    @Named('remote') this._cats,
    @Named('remote') this._grades,
  ) {
    _engine = SyncEngine(
      queueRepo: _queue,
      logger: _logger,
      adapter: this,
      entityType: 'course_grade_simulator',
    );
    // Si quieres procesar la cola al inicio, descomenta:
    // _engine.bootstrap();
    _engine.bootstrap();
  }

  // ISyncManager delega en engine
  @override
  bool get isOfflineMode => _engine.isOfflineMode;

  @override
  int get pendingOperationsCount => _engine.pendingOperationsCount;

  @override
  Map<String, dynamic> get syncStats => _engine.syncStats;

  @override
  Future<void> enqueueSyncOperation({
    required String operationType,
    required String fieldType,
    required String entityKey,
    required Map<String, dynamic> operationData,
  }) => _engine.enqueueSyncOperation(
    operationType: operationType,
    fieldType: fieldType,
    entityKey: entityKey,
    operationData: operationData,
  );

  @override
  Future<void> processPendingOperations() => _engine.processPendingOperations();

  @override
  Future<void> checkConnectivityRecovery() =>
      _engine.checkConnectivityRecovery();

  @override
  void dispose() => _engine.dispose();

  // DomainSyncAdapter impl
  @override
  (String, String) parseKey(String entityKey) {
    final parts = entityKey.split('_');
    if (parts.length != 2) {
      throw ArgumentError('Invalid entityKey format: $entityKey');
    }
    return (parts[0], parts[1]);
  }

  @override
  Future<void> executeOperation(
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
        await _courses.create(tracking);
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
        await _grades.updateGradesField(
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
        await _cats.updateCategoriesField(
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
        await _grades.updateMultipleCategoriesGrades(
          studentCode: studentCode,
          courseCode: courseCode,
          gradesByCategory: gradesByCategory,
        );
        break;

      default:
        _logger.w('[SYNC] Unknown operation: $operationType');
    }
  }

  @override
  Future<void> testConnectivity() =>
      _courses.getCourseTracking(studentCode: 'ping', courseCode: 'test');

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
}
