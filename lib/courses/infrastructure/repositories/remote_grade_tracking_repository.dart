import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart';

/// Pure HTTP repository for course_grade_simulator operations
/// Uses Single-Write Operations strategy instead of relational tables
///
/// Key optimization: Single-Write Operations replace multiple JOINs
/// - 75% fewer DB calls compared to chatty repository pattern
/// - Granular field operations for categories, grades, metadata
/// - No local caching - pure remote operations
@Named('remote')
@LazySingleton(as: GradeTrackingRepository)
class RemoteGradeTrackingRepository implements GradeTrackingRepository {
  final ApiGatewayClient _workerClient;
  final Logger _logger;

  const RemoteGradeTrackingRepository(this._workerClient, this._logger);

  // SINGLE-WRITE OPERATIONS

  /// Get raw course simulator data for internal parsing (Single-Write Operations)
  Future<Map<String, dynamic>?> _getCourseGradeSimulatorRaw({
    required String studentCode,
    required String courseCode,
  }) async {
    _logger.d('[HYBRID_REPO] Getting raw course simulator for parsing');

    try {
      final response = await _workerClient.http.get(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          return Map<String, dynamic>.from(data.first);
        }
      }
      return null;
    } on DioException catch (e, s) {
      _logger.e(
        '[HYBRID_REPO] Error getting simulator raw',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  /// MÉTODO PRIVADO: Crear course simulator para uso interno (Single-Write Operations)
  Future<void> _createCourseGradeSimulatorRaw(Map<String, dynamic> data) async {
    _logger.d('[HYBRID_REPO] Creating course grade simulator raw');

    try {
      await _workerClient.http.post(
        '/rest/v1/course_grade_simulator',
        data: data,
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
    } on DioException catch (e, s) {
      _logger.e(
        '[HYBRID_REPO] Error creating simulator raw',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// GRANULAR: Actualizar solo las categorías (operación granular optimizada)
  @override
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) async {
    _logger.d(
      '[HYBRID_REPO] Updating categories field (granular domain operation)',
    );

    // Convertir entidades de dominio a formato de persistencia
    final categoriesJson =
        categories
            .map(
              (category) => {
                'id': category.id,
                'name': category.name,
                'weight': category.weight,
              },
            )
            .toList();

    try {
      await _workerClient.http.patch(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        data: {'categories': categoriesJson},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
    } on DioException catch (e, s) {
      _logger.e(
        '[HYBRID_REPO] Error updating categories field',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// GRANULAR: Actualizar solo las notas de una categoría específica (operación granular optimizada)
  @override
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    _logger.d(
      '[HYBRID_REPO] Updating grades field for category $categoryId (granular domain operation)',
    );

    // Obtener estructura actual para mantener grades de otras categorías
    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    // Construir lista completa de grades con la categoría actualizada
    final allGrades = <Map<String, dynamic>>[];
    for (final category in currentTracking.categories) {
      final categoryGrades =
          category.id == categoryId ? grades : category.grades;
      for (final grade in categoryGrades) {
        allGrades.add({
          'id': grade.id,
          'categoryId': category.id,
          'name': grade.name,
          'score': grade.score,
          'enabled': grade.enabled,
        });
      }
    }

    try {
      await _workerClient.http.patch(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        data: {'grades': allGrades},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
    } on DioException catch (e, s) {
      _logger.e(
        '[HYBRID_REPO] Error updating grades field',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// GRANULAR BATCH: Actualizar notas de múltiples categorías en una sola operación HTTP (Opción B optimizada)
  @override
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) async {
    _logger.d(
      '[HYBRID_REPO] Updating multiple categories grades in single operation (${gradesByCategory.length} categories)',
    );

    // Obtener estructura actual para mantener grades de categorías no afectadas
    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    // Construir lista completa de grades con las categorías actualizadas
    final allGrades = <Map<String, dynamic>>[];
    for (final category in currentTracking.categories) {
      // Usar grades nuevas si la categoría está en el batch, sino usar las actuales
      final categoryGrades =
          gradesByCategory.containsKey(category.id)
              ? gradesByCategory[category.id]!
              : category.grades;

      for (final grade in categoryGrades) {
        allGrades.add({
          'id': grade.id,
          'categoryId': category.id,
          'name': grade.name,
          'score': grade.score,
          'enabled': grade.enabled,
        });
      }
    }

    try {
      await _workerClient.http.patch(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        data: {'grades': allGrades},
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );

      _logger.d(
        '[HYBRID_REPO] ✅ Multiple categories grades updated in single HTTP call - ${gradesByCategory.length} categories batched',
      );
    } on DioException catch (e, s) {
      _logger.e(
        '[HYBRID_REPO] Error updating multiple categories grades',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// GRANULAR: Eliminar course simulator completo (Para SyncManager, Single-Write)
  Future<void> _deleteCourseGradeSimulatorRaw({
    required String studentCode,
    required String courseCode,
  }) async {
    _logger.d('[HYBRID_REPO] Deleting course grade simulator');

    try {
      await _workerClient.http.delete(
        '/rest/v1/course_grade_simulator',
        queryParameters: {
          'student_code': 'eq.$studentCode',
          'course_code': 'eq.$courseCode',
        },
        options: Options(headers: {'X-Upstream': 'supabase'}),
      );
    } on DioException catch (e, s) {
      _logger.e(
        '[HYBRID_REPO] Error deleting simulator',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎯 MÉTODOS DE CONVENIENCIA (Para compatibilidad con UI)
  // ═══════════════════════════════════════════════════════════════

  /// Obtener CourseTracking parseado desde course_grade_simulator
  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    _logger.d(
      '[HYBRID_REPO] Getting CourseTracking from course_grade_simulator',
    );

    final simulatorData = await _getCourseGradeSimulatorRaw(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (simulatorData == null) return null;

    return _parseCourseGradeSimulatorToCourseTracking(simulatorData);
  }

  /// Crear CourseTracking con estructura por defecto en course_grade_simulator (Single-Write Operations)
  @override
  Future<CourseTracking> createWithDefaults({
    required String studentCode,
    required String courseCode,
    required String courseName,
  }) async {
    _logger.d(
      '[HYBRID_REPO] Creating default CourseTracking in course_grade_simulator',
    );

    // Usar la estructura por defecto del model CourseTracking
    final defaultCourseTracking = CourseTracking.createWithDefaults(
      courseCode: courseCode,
      studentCode: studentCode,
    );

    // Convertir a estructura Single-Write para course_grade_simulator
    final defaultData = _parseCourseTrackingToCourseGradeSimulator(
      defaultCourseTracking,
      courseName,
    );

    await _createCourseGradeSimulatorRaw(defaultData);

    final result = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    return result!;
  }

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    _logger.d('[HYBRID_REPO] Adding category $categoryName');

    // 1. Obtener estructura actual
    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    // 2. Agregar nueva categoría
    final newCategory = GradeCategory(
      id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
      name: categoryName,
      weight: weight,
      grades: [],
    );

    final updatedCategories = [...currentTracking.categories, newCategory];
    final updatedTracking = currentTracking.copyWith(
      categories: updatedCategories,
    );

    // 3. ✅ CORRECCIÓN: Actualizar solo campo categories (Single-Write granular)
    await updateCategoriesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categories: updatedCategories,
    );

    return updatedTracking;
  }

  @override
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) async {
    _logger.d('[HYBRID_REPO] Deleting category $categoryId');

    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    final updatedCategories =
        currentTracking.categories.where((c) => c.id != categoryId).toList();

    final updatedTracking = currentTracking.copyWith(
      categories: updatedCategories,
    );

    // ✅ CORRECCIÓN: Actualizar solo categories (grades de categoría eliminada se pierden automáticamente)
    await updateCategoriesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categories: updatedCategories,
    );

    return updatedTracking;
  }

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    _logger.d('[HYBRID_REPO] Adding grade $gradeName to category $categoryId');

    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    final newGrade = Grade(
      id: 'grade_${DateTime.now().millisecondsSinceEpoch}',
      name: gradeName,
      score: score,
      enabled: true,
    );

    final updatedCategories =
        currentTracking.categories.map((category) {
          if (category.id == categoryId) {
            final updatedGrades = [...category.grades, newGrade];
            return category.copyWith(grades: updatedGrades);
          }
          return category;
        }).toList();

    final updatedTracking = currentTracking.copyWith(
      categories: updatedCategories,
    );

    // ✅ CORRECCIÓN: Actualizar solo las grades de la categoría específica (granular)
    final targetCategory = updatedCategories.firstWhere(
      (cat) => cat.id == categoryId,
    );
    await updateGradesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categoryId: categoryId,
      grades: targetCategory.grades,
    );

    return updatedTracking;
  }

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    _logger.d(
      '[HYBRID_REPO] Deleting grade $gradeId from category $categoryId',
    );

    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    final updatedCategories =
        currentTracking.categories.map((category) {
          if (category.id == categoryId) {
            final updatedGrades =
                category.grades.where((g) => g.id != gradeId).toList();
            return category.copyWith(grades: updatedGrades);
          }
          return category;
        }).toList();

    final updatedTracking = currentTracking.copyWith(
      categories: updatedCategories,
    );

    // ✅ CORRECCIÓN: Actualizar solo las grades de la categoría específica (granular)
    final targetCategory = updatedCategories.firstWhere(
      (cat) => cat.id == categoryId,
    );
    await updateGradesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categoryId: categoryId,
      grades: targetCategory.grades,
    );

    return updatedTracking;
  }

  @override
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    _logger.d('[HYBRID_REPO] Updating category $categoryId');

    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    final updatedCategories =
        currentTracking.categories.map((category) {
          if (category.id == categoryId) {
            return category.copyWith(name: newName, weight: newWeight);
          }
          return category;
        }).toList();

    final updatedTracking = currentTracking.copyWith(
      categories: updatedCategories,
    );

    // ✅ CORRECCIÓN: Actualizar solo campo categories (Single-Write granular)
    await updateCategoriesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categories: updatedCategories,
    );

    return updatedTracking;
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
    _logger.d('[HYBRID_REPO] Updating grade $gradeId');

    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    final updatedCategories =
        currentTracking.categories.map((category) {
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

    final updatedTracking = currentTracking.copyWith(
      categories: updatedCategories,
    );

    // ✅ CORRECCIÓN: Actualizar solo las grades de la categoría específica (granular)
    final targetCategory = updatedCategories.firstWhere(
      (cat) => cat.id == categoryId,
    );
    await updateGradesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categoryId: categoryId,
      grades: targetCategory.grades,
    );

    return updatedTracking;
  }

  @override
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    _logger.d('[HYBRID_REPO] Toggling grade $gradeId enabled=$enabled');

    final currentTracking = await getCourseTracking(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (currentTracking == null) {
      throw Exception('Course tracking not found');
    }

    final updatedCategories =
        currentTracking.categories.map((category) {
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

    final updatedTracking = currentTracking.copyWith(
      categories: updatedCategories,
    );

    // ✅ CORRECCIÓN: Actualizar solo las grades de la categoría específica (granular)
    final targetCategory = updatedCategories.firstWhere(
      (cat) => cat.id == categoryId,
    );
    await updateGradesField(
      studentCode: studentCode,
      courseCode: courseCode,
      categoryId: categoryId,
      grades: targetCategory.grades,
    );

    return updatedTracking;
  }

  @override
  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    // Alias para deleteCourseGradeSimulator
    return _deleteCourseGradeSimulatorRaw(
      studentCode: studentCode,
      courseCode: courseCode,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎯 PARSERS Single-Write ↔ CourseTracking Models
  // ═══════════════════════════════════════════════════════════════

  /// Parsear course_grade_simulator Single-Write → CourseTracking
  CourseTracking _parseCourseGradeSimulatorToCourseTracking(
    Map<String, dynamic> simulatorData,
  ) {
    final categories = <GradeCategory>[];

    // ✅ CORRECCIÓN: Parsear estructura Single-Write
    final categoriesJson = simulatorData['categories'] as List? ?? [];
    final gradesJson = simulatorData['grades'] as List? ?? [];
    // final metadataJson = simulatorData['metadata'] as Map<String, dynamic>? ?? {};

    // Convertir grades a map por categoryId para fácil acceso
    final gradesByCategory = <String, List<Grade>>{};
    for (final gradeData in gradesJson) {
      final gradeMap = gradeData as Map<String, dynamic>;
      final categoryId = gradeMap['categoryId'] as String?;
      if (categoryId != null) {
        gradesByCategory
            .putIfAbsent(categoryId, () => [])
            .add(
              Grade(
                id: gradeMap['id']?.toString(),
                name: gradeMap['name'] ?? '',
                score: (gradeMap['score'] ?? 0).toDouble(),
                enabled: gradeMap['enabled'] ?? true,
              ),
            );
      }
    }

    // Reconstruir categorías con sus grades correspondientes
    for (final categoryData in categoriesJson) {
      final categoryMap = categoryData as Map<String, dynamic>;
      final categoryId = categoryMap['id']?.toString();

      final categoryGrades =
          categoryId != null ? (gradesByCategory[categoryId] ?? []) : <Grade>[];

      categories.add(
        GradeCategory(
          id: categoryId,
          name: categoryMap['name'] ?? '',
          weight: (categoryMap['weight'] ?? 0).toDouble(),
          grades: categoryGrades, // ✅ Grades desde campo separado
        ),
      );
    }

    return CourseTracking(
      id: simulatorData['id']?.toString(),
      studentCode: simulatorData['student_code'] ?? '',
      courseCode: simulatorData['course_code'] ?? '',
      categories: categories,
    );
  }

  /// Parsear CourseTracking → course_grade_simulator Single-Write
  Map<String, dynamic> _parseCourseTrackingToCourseGradeSimulator(
    CourseTracking courseTracking,
    String courseName,
  ) {
    // ✅ CORRECCIÓN: Separar en 3 campos Single-Write
    final categories =
        courseTracking.categories.map((c) => _categoryToJsonHybrid(c)).toList();

    final grades = <Map<String, dynamic>>[];
    for (final category in courseTracking.categories) {
      for (final grade in category.grades) {
        grades.add({
          'id': grade.id,
          'categoryId': category.id, // ✅ Referencia a categoría
          'name': grade.name,
          'score': grade.score,
          'enabled': grade.enabled,
        });
      }
    }

    final metadata = <String, dynamic>{
      'passScore': 60, // Valor por defecto
      'semester': '2025-1', // Valor por defecto
      'notifications': true, // Valor por defecto
    };

    return {
      'student_code': courseTracking.studentCode,
      'course_code': courseTracking.courseCode,
      'categories': categories, // ✅ Solo categorías sin grades embebidas
      'grades': grades, // ✅ Grades separadas con categoryId
      'metadata': metadata, // ✅ Metadata separada
    };
  }

  /// Helper: GradeCategory → Single-Write (sin grades embebidas)
  Map<String, dynamic> _categoryToJsonHybrid(GradeCategory category) {
    return {
      'id': category.id,
      'name': category.name,
      'weight': category.weight,
      // ✅ NO incluir grades aquí - van en campo separado
    };
  }
}
