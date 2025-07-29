import 'package:logger/logger.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'single_write_client.dart';
import 'course_remote_source.dart';

/// Remote data source for category-level operations
/// Handles CRUD operations for grade categories using JSONB patches
class CategoryRemoteSource {
  final CourseRemoteSource _course;
  final SingleWriteClient _patcher;
  final Logger _logger;

  const CategoryRemoteSource(this._course, this._patcher, this._logger);

  /// Add a new category to a course
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    _logger.d(
      '[CATEGORY_REMOTE_SOURCE] Adding category: $categoryName to ${studentCode}_$courseCode',
    );

    final newCategoryId = 'cat_${DateTime.now().millisecondsSinceEpoch}';
    return _patchAndFetch(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFn:
          (current) => current.copyWith(
            categories: [
              ...current.categories,
              GradeCategory(
                id: newCategoryId,
                name: categoryName,
                weight: weight,
                grades: [],
              ),
            ],
          ),
      dataFn:
          (updated) => {'categories': _buildCategoriesList(updated.categories)},
    );
  }

  /// Delete a category from a course
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) async {
    _logger.d(
      '[CATEGORY_REMOTE_SOURCE] Deleting category: $categoryId from ${studentCode}_$courseCode',
    );

    return _patchAndFetch(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFn:
          (current) => current.copyWith(
            categories:
                current.categories
                    .where((cat) => cat.id != categoryId)
                    .toList(),
          ),
      dataFn:
          (updated) => {
            'categories': _buildCategoriesList(updated.categories),
            'grades': _buildGradesList(updated),
          },
    );
  }

  /// Update an existing category
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    _logger.d(
      '[CATEGORY_REMOTE_SOURCE] Updating category: $categoryId in ${studentCode}_$courseCode',
    );

    return _patchAndFetch(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFn:
          (current) => current.copyWith(
            categories:
                current.categories.map((cat) {
                  return cat.id == categoryId
                      ? cat.copyWith(name: newName, weight: newWeight)
                      : cat;
                }).toList(),
          ),
      dataFn:
          (updated) => {'categories': _buildCategoriesList(updated.categories)},
    );
  }

  /// Update the entire categories field (for batch operations)
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) async {
    _logger.d(
      '[CATEGORY_REMOTE_SOURCE] Updating categories field for ${studentCode}_$courseCode',
    );

    await _patcher.patchField(
      studentCode: studentCode,
      courseCode: courseCode,
      field: 'categories',
      value: _buildCategoriesList(categories),
    );
  }

  // 🛠️ PRIVATE HELPERS

  /// Generic patch-and-fetch helper for category operations
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

  /// Build categories list for API payload
  List<Map<String, dynamic>> _buildCategoriesList(
    List<GradeCategory> categories,
  ) {
    return categories
        .map(
          (category) => {
            'id': category.id,
            'name': category.name,
            'weight': category.weight,
          },
        )
        .toList();
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
