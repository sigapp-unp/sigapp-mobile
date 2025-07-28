import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/database/sqlite_client_manager.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';

/// Local service using hybrid data structure for optimal sync performance
/// Provides granular field operations to reduce remote sync operations
///
/// Key features:
/// - Granular updates fields (categories, grades, metadata)
/// - SQLite-based caching for instant UI responsiveness
@singleton
class GradeTrackingLocalService {
  final SQLiteClientManager _database;
  final Logger _logger;

  GradeTrackingLocalService(this._database, this._logger);

  // CORE OPERATIONS

  /// Build unique course key for caching
  String buildCourseKey(String studentCode, String courseCode) {
    return '${studentCode}_$courseCode';
  }

  /// Obtiene el course tracking desde cache
  Future<CourseTracking?> getCachedCourse(String courseKey) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        where: 'course_key = ?',
        whereArgs: [courseKey],
      );

      if (result.isEmpty) return null;

      final row = result.first;
      return _reconstructCourseTracking(row, courseKey);
    } catch (e) {
      _logger.e('[LOCAL_SERVICE] ❌ Error getting cached course: $e');
      return null;
    }
  }

  /// Guarda course tracking completo en cache
  Future<void> saveCourse(String courseKey, CourseTracking tracking) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final deconstructed = _deconstructCourseTracking(tracking);

      await _database.db.rawInsert(
        '''
        INSERT OR REPLACE INTO course_grade_simulator (
          course_key,
          categories_json,
          grades_json,
          metadata_json,
          last_modified_categories,
          last_modified_grades,
          last_modified_metadata
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
        [
          courseKey,
          jsonEncode(deconstructed['categories']),
          jsonEncode(deconstructed['grades']),
          jsonEncode(deconstructed['metadata']),
          now,
          now,
          now,
        ],
      );

      _logger.d('[LOCAL_SERVICE] ✅ Saved complete course: $courseKey');
    } catch (e) {
      _logger.e('[LOCAL_SERVICE] ❌ Error saving course: $e');
      rethrow;
    }
  }

  /// Invalida/elimina course tracking del cache
  Future<void> invalidateCourse(String courseKey) async {
    try {
      await _database.db.delete(
        'course_grade_simulator',
        where: 'course_key = ?',
        whereArgs: [courseKey],
      );
      _logger.d('[LOCAL_SERVICE] ✅ Invalidated course cache: $courseKey');
    } catch (e) {
      _logger.e('[LOCAL_SERVICE] ❌ Error invalidating course: $e');
      rethrow;
    }
  }

  /// Verifica si el curso existe en cache
  Future<bool> courseExistsInCache(String courseKey) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        columns: ['course_key'],
        where: 'course_key = ?',
        whereArgs: [courseKey],
      );
      return result.isNotEmpty;
    } catch (e) {
      _logger.e('[LOCAL_SERVICE] Error checking cache existence: $e');
      return false;
    }
  }

  // 🎯 OPERACIONES GRANULARES (NUEVA FUNCIONALIDAD)

  /// Actualizar solo categorías (granular - reduce sync operations)
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) async {
    try {
      final courseKey = buildCourseKey(studentCode, courseCode);
      final now = DateTime.now().millisecondsSinceEpoch;

      final categoriesData =
          categories
              .map(
                (category) => {
                  'id': category.id,
                  'name': category.name,
                  'weight': category.weight,
                },
              )
              .toList();

      await _database.db.update(
        'course_grade_simulator',
        {
          'categories_json': jsonEncode(categoriesData),
          'last_modified_categories': now,
        },
        where: 'course_key = ?',
        whereArgs: [courseKey],
      );

      // ✅ ELIMINADO: Ya no usa _enqueueSyncOperation interno
      // El LocalGradeTrackingDecorator ahora llama directamente al SyncManager
      // para usar el sistema de batching optimizado con persistencia

      _logger.d(
        '[LOCAL_SERVICE] ✅ Updated categories field: $courseCode (ready for SyncManager batching)',
      );
    } catch (e) {
      _logger.e('[LOCAL_SERVICE] ❌ Error updating categories field: $e');
      rethrow;
    }
  }

  /// Actualizar solo notas de una categoría (granular - reduce sync operations)
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    try {
      final courseKey = buildCourseKey(studentCode, courseCode);
      final now = DateTime.now().millisecondsSinceEpoch;

      // Obtener grades actuales
      final currentGrades = await _getCachedGrades(courseKey) ?? {};

      // Actualizar solo la categoría específica
      currentGrades[categoryId] =
          grades
              .map(
                (grade) => {
                  'id': grade.id,
                  'name': grade.name,
                  'score': grade.score,
                  'enabled': grade.enabled,
                },
              )
              .toList();

      await _database.db.update(
        'course_grade_simulator',
        {'grades_json': jsonEncode(currentGrades), 'last_modified_grades': now},
        where: 'course_key = ?',
        whereArgs: [courseKey],
      );

      // ✅ CORRECCIÓN: Generar estructura híbrida para sync
      // Convertir Map<categoryId, List<Grade>> a List<Grade> con categoryId
      final allGradesForSync = <Map<String, dynamic>>[];
      currentGrades.forEach((catId, gradeList) {
        for (final gradeData in gradeList as List) {
          allGradesForSync.add({
            'id': gradeData['id'],
            'categoryId': catId, // ✅ Referencia híbrida
            'name': gradeData['name'],
            'score': gradeData['score'],
            'enabled': gradeData['enabled'],
          });
        }
      });

      // ✅ ELIMINADO: Ya no usa _enqueueSyncOperation interno
      // El LocalGradeTrackingDecorator ahora llama directamente al SyncManager
      // para usar el sistema de batching optimizado con persistencia

      _logger.d(
        '[LOCAL_SERVICE] ✅ Updated grades field for category $categoryId (ready for SyncManager batching)',
      );
    } catch (e) {
      _logger.e('[LOCAL_SERVICE] ❌ Error updating grades field: $e');
      rethrow;
    }
  }

  // 🔧 MÉTODOS HELPER INTERNOS

  /// Deconstruye CourseTracking en 3 campos separados
  Map<String, dynamic> _deconstructCourseTracking(CourseTracking tracking) {
    // Separar categorías (sin grades)
    final categories =
        tracking.categories
            .map(
              (category) => {
                'id': category.id,
                'name': category.name,
                'weight': category.weight,
              },
            )
            .toList();

    // Separar grades agrupadas por categoría
    final grades = <String, List<Map<String, dynamic>>>{};
    for (final category in tracking.categories) {
      if (category.id != null) {
        grades[category.id!] =
            category.grades
                .map(
                  (grade) => {
                    'id': grade.id,
                    'name': grade.name,
                    'score': grade.score,
                    'enabled': grade.enabled,
                  },
                )
                .toList();
      }
    }

    return {'categories': categories, 'grades': grades};
  }

  /// Reconstruye CourseTracking desde 3 campos separados
  CourseTracking _reconstructCourseTracking(
    Map<String, dynamic> row,
    String courseKey,
  ) {
    final categoriesJson = row['categories_json'] as String?;
    final gradesJson = row['grades_json'] as String?;

    final categoriesData =
        categoriesJson != null
            ? jsonDecode(categoriesJson) as List
            : <dynamic>[];
    final gradesData =
        gradesJson != null
            ? jsonDecode(gradesJson) as Map<String, dynamic>
            : <String, dynamic>{};

    // Reconstruir categorías con sus grades
    final categories =
        categoriesData.map((categoryJson) {
          final categoryId = categoryJson['id'] as String?;
          final categoryGrades =
              categoryId != null && gradesData.containsKey(categoryId)
                  ? (gradesData[categoryId] as List)
                      .map(
                        (gradeJson) => Grade(
                          id: gradeJson['id'],
                          name: gradeJson['name'],
                          score: (gradeJson['score'] as num).toDouble(),
                          enabled: gradeJson['enabled'] ?? true,
                        ),
                      )
                      .toList()
                  : <Grade>[];

          return GradeCategory(
            id: categoryId,
            name: categoryJson['name'],
            weight: (categoryJson['weight'] as num).toDouble(),
            grades: categoryGrades,
          );
        }).toList();

    return CourseTracking(
      id: row['id'] ?? courseKey,
      studentCode: courseKey.split('_')[0],
      courseCode: courseKey.split('_')[1],
      categories: categories,
    );
  }

  /// Obtener grades actuales del cache
  Future<Map<String, dynamic>?> _getCachedGrades(String courseKey) async {
    try {
      final result = await _database.db.query(
        'course_grade_simulator',
        columns: ['grades_json'],
        where: 'course_key = ?',
        whereArgs: [courseKey],
      );

      if (result.isEmpty) return null;

      final gradesJson = result.first['grades_json'] as String?;
      if (gradesJson == null) return {};

      return jsonDecode(gradesJson) as Map<String, dynamic>;
    } catch (e) {
      _logger.e('[LOCAL_SERVICE] Error getting cached grades: $e');
      return null;
    }
  }

  // ✅ ELIMINADO: _enqueueSyncOperation method
  // Ahora usa SyncManager unificado con batching optimizado + persistencia SQLite fallback
}
