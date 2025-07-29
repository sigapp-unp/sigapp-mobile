import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'single_write_client.dart';
import 'course_remote_source.dart';

/// Remote data source for grade-level operations
/// Handles CRUD operations for individual grades using JSONB patches
class GradeRemoteSource {
  final CourseRemoteSource _course;
  final SingleWriteClient _patcher;
  final Logger _logger;

  GradeRemoteSource(this._course, this._logger, ApiGatewayClient client)
    : _patcher = SingleWriteClient(client, _logger);

  /// Add a new grade to a category
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    _logger.d(
      '[GRADE_REMOTE_SOURCE] Adding grade: $gradeName to category $categoryId',
    );

    final newGradeId = 'grade_${DateTime.now().millisecondsSinceEpoch}';
    return _patchAndFetch(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFn:
          (current) => current.copyWith(
            categories:
                current.categories.map((cat) {
                  return cat.id == categoryId
                      ? cat.copyWith(
                        grades: [
                          ...cat.grades,
                          Grade(id: newGradeId, name: gradeName, score: score),
                        ],
                      )
                      : cat;
                }).toList(),
          ),
      dataFn: (updated) => {'grades': _buildGradesList(updated)},
    );
  }

  /// Delete a grade from a category
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    _logger.d(
      '[GRADE_REMOTE_SOURCE] Deleting grade: $gradeId from category $categoryId',
    );

    return _patchAndFetch(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFn:
          (current) => current.copyWith(
            categories:
                current.categories.map((cat) {
                  return cat.id == categoryId
                      ? cat.copyWith(
                        grades:
                            cat.grades
                                .where((grade) => grade.id != gradeId)
                                .toList(),
                      )
                      : cat;
                }).toList(),
          ),
      dataFn: (updated) => {'grades': _buildGradesList(updated)},
    );
  }

  /// Update an existing grade
  Future<CourseTracking> updateGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  }) async {
    _logger.d(
      '[GRADE_REMOTE_SOURCE] Updating grade: $gradeId in category $categoryId',
    );

    return _patchAndFetch(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFn:
          (current) => current.copyWith(
            categories:
                current.categories.map((cat) {
                  return cat.id == categoryId
                      ? cat.copyWith(
                        grades:
                            cat.grades.map((grade) {
                              return grade.id == gradeId
                                  ? grade.copyWith(
                                    name: newName,
                                    score: newScore,
                                  )
                                  : grade;
                            }).toList(),
                      )
                      : cat;
                }).toList(),
          ),
      dataFn: (updated) => {'grades': _buildGradesList(updated)},
    );
  }

  /// Toggle grade enabled/disabled status
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    _logger.d(
      '[GRADE_REMOTE_SOURCE] Toggling grade enabled: $gradeId (enabled: $enabled)',
    );

    return _patchAndFetch(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFn:
          (current) => current.copyWith(
            categories:
                current.categories.map((cat) {
                  return cat.id == categoryId
                      ? cat.copyWith(
                        grades:
                            cat.grades.map((grade) {
                              return grade.id == gradeId
                                  ? grade.copyWith(enabled: enabled)
                                  : grade;
                            }).toList(),
                      )
                      : cat;
                }).toList(),
          ),
      dataFn: (updated) => {'grades': _buildGradesList(updated)},
    );
  }

  /// Update grades for a specific category (batch operation)
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    _logger.d(
      '[GRADE_REMOTE_SOURCE] Updating grades field for category: $categoryId',
    );

    final current = await _course.fetch(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.map((cat) {
          return cat.id == categoryId ? cat.copyWith(grades: grades) : cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _patcher.patchField(
      studentCode: studentCode,
      courseCode: courseCode,
      field: 'grades',
      value: _buildGradesList(updatedCourse),
    );
  }

  /// Update grades for multiple categories (batch operation)
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) async {
    _logger.d('[GRADE_REMOTE_SOURCE] Updating multiple categories grades');

    final current = await _course.fetch(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updatedCategories =
        current.categories.map((cat) {
          return cat.id != null && gradesByCategory.containsKey(cat.id!)
              ? cat.copyWith(grades: gradesByCategory[cat.id!]!)
              : cat;
        }).toList();

    final updatedCourse = current.copyWith(categories: updatedCategories);

    await _patcher.patchField(
      studentCode: studentCode,
      courseCode: courseCode,
      field: 'grades',
      value: _buildGradesList(updatedCourse),
    );
  }

  // 🛠️ PRIVATE HELPERS

  /// Generic patch-and-fetch helper for grade operations
  Future<CourseTracking> _patchAndFetch({
    required String studentCode,
    required String courseCode,
    required CourseTracking Function(CourseTracking) updateFn,
    required Map<String, dynamic> Function(CourseTracking) dataFn,
  }) async {
    final current = await _course.fetch(
      studentCode: studentCode,
      courseCode: courseCode,
    );

    if (current == null) throw Exception('Course tracking not found');

    final updated = updateFn(current);
    final data = dataFn(updated);

    if (data.length == 1) {
      // Single field patch
      final field = data.keys.first;
      await _patcher.patchField(
        studentCode: studentCode,
        courseCode: courseCode,
        field: field,
        value: data[field],
      );
    } else {
      // Multi-field patch
      await _patcher.patchFields(
        studentCode: studentCode,
        courseCode: courseCode,
        fields: data,
      );
    }

    // Return updated course
    final result = await _course.fetch(
      studentCode: studentCode,
      courseCode: courseCode,
    );
    return result!;
  }

  /// Build grades list for API payload (from all categories)
  List<Map<String, dynamic>> _buildGradesList(CourseTracking course) {
    final grades = <Map<String, dynamic>>[];
    for (final category in course.categories) {
      for (final grade in category.grades) {
        grades.add({
          'id': grade.id,
          'category_id': category.id,
          'name': grade.name,
          'score': grade.score,
          'enabled': grade.enabled,
        });
      }
    }
    return grades;
  }
}
