import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/grade_simulator/infrastructure/repositories/proxy/base_repository_proxy.dart';

/// Optimized local decorator for Grade operations
/// Leverages local cache repository and mapper for maximum performance
///
/// Key improvements:
/// - Extends BaseGradeTrackingRepositoryDecorator for unified patterns
/// - Uses optimistic updates for better UX (CHANGED from remote-first)
/// - Simplified error handling with consistent logging
/// - Smart cache strategies with fallback mechanisms
@LazySingleton(as: GradeTrackingGradeRepository)
class GradeSimulatorGradeRepositoryProxy
    extends BaseGradeSimulatorRepositoryProxy
    implements GradeTrackingGradeRepository {
  @override
  String get decoratorType => 'GRADE';

  GradeSimulatorGradeRepositoryProxy(
    super.remoteRepository,
    super.localRepository,
    super.syncManager,
    super.logger,
  );

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    return performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final newGrade = Grade(
          id: 'grade_${DateTime.now().millisecondsSinceEpoch}',
          name: gradeName,
          score: score,
          enabled: true,
        );

        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                return cat.copyWith(grades: [...cat.grades, newGrade]);
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'addGrade',
      fieldType: 'grades',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeName': gradeName,
            'score': score,
            'grades': serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => remoteRepository.addGrade(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeName: gradeName,
            score: score,
          ),
      logContext: {
        'categoryId': categoryId,
        'gradeName': gradeName,
        'score': score,
      },
    );
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
    return performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                final updatedGrades =
                    cat.grades.map((grade) {
                      if (grade.id == gradeId) {
                        return grade.copyWith(name: newName, score: newScore);
                      }
                      return grade;
                    }).toList();
                return cat.copyWith(grades: updatedGrades);
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'updateGrade',
      fieldType: 'grades',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeId': gradeId,
            'newName': newName,
            'newScore': newScore,
            'grades': serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => remoteRepository.updateGrade(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeId: gradeId,
            newName: newName,
            newScore: newScore,
          ),
      logContext: {
        'categoryId': categoryId,
        'gradeId': gradeId,
        'newName': newName,
        'newScore': newScore,
      },
    );
  }

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    return performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                final updatedGrades =
                    cat.grades.where((grade) => grade.id != gradeId).toList();
                return cat.copyWith(grades: updatedGrades);
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'deleteGrade',
      fieldType: 'grades',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeId': gradeId,
            'grades': serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => remoteRepository.deleteGrade(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeId: gradeId,
          ),
      logContext: {'categoryId': categoryId, 'gradeId': gradeId},
    );
  }

  @override
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    return performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                final updatedGrades =
                    cat.grades.map((grade) {
                      if (grade.id == gradeId) {
                        return grade.copyWith(enabled: enabled);
                      }
                      return grade;
                    }).toList();
                return cat.copyWith(grades: updatedGrades);
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'toggleGradeEnabled',
      fieldType: 'grades',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
            'categoryId': categoryId,
            'gradeId': gradeId,
            'enabled': enabled,
            'grades': serializeGradesForSync(updated.categories),
          },
      remoteFallback:
          () => remoteRepository.toggleGradeEnabled(
            studentCode: studentCode,
            courseCode: courseCode,
            categoryId: categoryId,
            gradeId: gradeId,
            enabled: enabled,
          ),
      logContext: {
        'categoryId': categoryId,
        'gradeId': gradeId,
        'enabled': enabled,
      },
    );
  }

  @override
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) async {
    await performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (cat.id == categoryId) {
                return cat.copyWith(grades: grades);
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'updateGradesField',
      fieldType: 'grades',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
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
      remoteFallback: () async {
        await remoteRepository.updateGradesField(
          studentCode: studentCode,
          courseCode: courseCode,
          categoryId: categoryId,
          grades: grades,
        );
        // Return updated course from local cache after successful remote update
        final cached = await localRepository.getCourse(
          studentCode: studentCode,
          courseCode: courseCode,
        );
        if (cached == null) {
          throw Exception('Course not found after remote update');
        }
        return cached;
      },
      logContext: {'categoryId': categoryId, 'gradesCount': grades.length},
    );
  }

  @override
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) async {
    await performOptimisticUpdate(
      studentCode: studentCode,
      courseCode: courseCode,
      updateFunction: (current) {
        final updatedCategories =
            current.categories.map((cat) {
              if (gradesByCategory.containsKey(cat.id)) {
                return cat.copyWith(grades: gradesByCategory[cat.id]!);
              }
              return cat;
            }).toList();

        return current.copyWith(categories: updatedCategories);
      },
      operationType: 'updateMultipleCategoriesGrades',
      fieldType: 'grades',
      syncDataBuilder:
          (updated) => {
            'studentCode': studentCode,
            'courseCode': courseCode,
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
      remoteFallback: () async {
        await remoteRepository.updateMultipleCategoriesGrades(
          studentCode: studentCode,
          courseCode: courseCode,
          gradesByCategory: gradesByCategory,
        );
        // Return updated course from local cache after successful remote update
        final cached = await localRepository.getCourse(
          studentCode: studentCode,
          courseCode: courseCode,
        );
        if (cached == null) {
          throw Exception('Course not found after remote update');
        }
        return cached;
      },
      logContext: {'categoriesCount': gradesByCategory.length},
    );
  }
}
