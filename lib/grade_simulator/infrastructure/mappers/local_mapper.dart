import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:sigapp/core/infrastructure/database/local_database.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';

/// Mapper responsible for transforming CourseTracking entities
/// between different representations (JSON, database format, etc.)
///
/// Features:
/// - Centralized data transformation logic
/// - Separation between categories and grades for optimal storage
/// - Type-safe conversions with student and course codes
/// - Clear separation of concerns from business logic
@injectable
class LocalGradeSimulatorMapper {
  /// Transforms CourseTracking into separate components for database storage
  ///
  /// Returns a map with:
  /// - categories: List of category data without grades
  /// - grades: Map of grades grouped by category ID
  /// - metadata: Additional metadata for future extensibility
  Map<String, dynamic> deconstructCourseTracking(CourseTracking tracking) {
    // Extract categories without grades
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

    // Extract grades grouped by category ID
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

    return {
      'categories': categories,
      'grades': grades,
      'metadata': <String, dynamic>{}, // Reserved for future use
    };
  }

  /// Reconstructs CourseTracking from database row data
  ///
  /// Parameters:
  /// - row: Database row containing JSON fields
  /// - studentCode: Student identifier
  /// - courseCode: Course identifier
  ///
  /// Returns fully reconstructed CourseTracking entity
  CourseTracking reconstructCourseTracking(
    Map<String, dynamic> row,
    String studentCode,
    String courseCode,
  ) {
    final categoriesJson = row['categories'] as String?;
    final gradesJson = row['grades'] as String?;

    // Parse JSON data with safe defaults
    final categoriesData = _parseJsonList(categoriesJson);
    final gradesData = _parseJsonMap(gradesJson);

    // Reconstruct categories with their associated grades
    final categories = _reconstructCategories(categoriesData, gradesData);

    return CourseTracking(
      id: row['id'] ?? '${studentCode}_$courseCode',
      studentCode: studentCode,
      courseCode: courseCode,
      categories: categories,
    );
  }

  /// Converts deconstructed data to JSON strings for database storage
  Map<String, String> toJsonStrings(Map<String, dynamic> deconstructed) {
    return {
      'categories': jsonEncode(deconstructed['categories']),
      'grades': jsonEncode(deconstructed['grades']),
      'metadata': jsonEncode(deconstructed['metadata']),
    };
  }

  /// Extracts only categories data for partial updates
  String categoriesToJson(CourseTracking tracking) {
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
    return jsonEncode(categories);
  }

  /// Extracts only grades data for partial updates
  String gradesToJson(CourseTracking tracking) {
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
    return jsonEncode(grades);
  }

  /// Helper method to reconstruct CourseTracking from database row
  CourseTracking? reconstructCourseFromDatabaseRow(
    CourseGradeSimulatorData? row,
    String studentCode,
    String courseCode,
  ) {
    if (row == null) return null;

    final rowMap = {
      'id': row.id,
      'categories': row.categories,
      'grades': row.grades,
      'metadata': row.metadata,
    };

    return reconstructCourseTracking(rowMap, studentCode, courseCode);
  }

  // Private helper methods

  List<dynamic> _parseJsonList(String? json) {
    if (json == null || json.isEmpty) return <dynamic>[];
    try {
      return jsonDecode(json) as List<dynamic>;
    } catch (e) {
      return <dynamic>[];
    }
  }

  Map<String, dynamic> _parseJsonMap(String? json) {
    if (json == null || json.isEmpty) return <String, dynamic>{};
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return <String, dynamic>{};
    }
  }

  List<GradeCategory> _reconstructCategories(
    List<dynamic> categoriesData,
    Map<String, dynamic> gradesData,
  ) {
    return categoriesData.map((categoryJson) {
      final categoryId = categoryJson['id'] as String?;
      final categoryGrades = _reconstructGradesForCategory(
        categoryId,
        gradesData,
      );

      return GradeCategory(
        id: categoryId,
        name: categoryJson['name'],
        weight: (categoryJson['weight'] as num).toDouble(),
        grades: categoryGrades,
      );
    }).toList();
  }

  List<Grade> _reconstructGradesForCategory(
    String? categoryId,
    Map<String, dynamic> gradesData,
  ) {
    if (categoryId == null || !gradesData.containsKey(categoryId)) {
      return <Grade>[];
    }

    final gradesList = gradesData[categoryId] as List<dynamic>;
    return gradesList.map((gradeJson) {
      return Grade(
        id: gradeJson['id'],
        name: gradeJson['name'],
        score: (gradeJson['score'] as num).toDouble(),
        enabled: gradeJson['enabled'] ?? true,
      );
    }).toList();
  }
}
