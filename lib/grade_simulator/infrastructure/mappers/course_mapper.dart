import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/infrastructure/models/models.dart';

class CourseMapper {
  static CourseTracking toDomain(
    CourseModel model, {
    required String courseCode,
  }) {
    // Convertir las categorías del modelo a entidades de dominio
    final categories =
        model.categories.asMap().entries.map((categoryEntry) {
          final categoryIndex = categoryEntry.key;
          final categoryModel = categoryEntry.value;

          // Obtener grades de esta categoría por índice
          final categoryGrades =
              model.grades
                  .where((grade) => grade.categoryIndex == categoryIndex)
                  .map(
                    (gradeModel) => Grade(
                      id: null, // Los grades ya no necesitan ID
                      name: gradeModel.name,
                      score: gradeModel.score,
                      enabled: gradeModel.enabled,
                    ),
                  )
                  .toList();

          return GradeCategory(
            id: null, // Las categorías ya no necesitan ID
            name: categoryModel.name,
            weight: categoryModel.weight,
            grades: categoryGrades,
          );
        }).toList();

    return CourseTracking(courseCode: courseCode, categories: categories);
  }

  static CourseModel toInfrastructure(
    CourseTracking domain,
    String Function() idGenerator,
  ) {
    final categories = <CategoryModel>[];
    final grades = <GradeModel>[];

    for (
      int categoryIndex = 0;
      categoryIndex < domain.categories.length;
      categoryIndex++
    ) {
      final category = domain.categories[categoryIndex];

      // Agregar la categoría
      categories.add(
        CategoryModel(name: category.name, weight: category.weight),
      );

      // Agregar los grades de esta categoría
      for (final grade in category.grades) {
        grades.add(
          GradeModel(
            categoryIndex: categoryIndex,
            name: grade.name,
            score: grade.score,
            enabled: grade.enabled,
          ),
        );
      }
    }

    return CourseModel(
      categories: categories,
      grades: grades,
      lastModified: null,
    );
  }

  static List<CourseTracking> listToDomain(
    List<CourseModel> models, {
    required String Function(int index) courseCodeProvider,
  }) {
    return models
        .asMap()
        .entries
        .map(
          (entry) =>
              toDomain(entry.value, courseCode: courseCodeProvider(entry.key)),
        )
        .toList();
  }

  static List<CourseModel> listToInfrastructure(
    List<CourseTracking> domains,
    String Function() idGenerator,
  ) {
    return domains
        .map((domain) => toInfrastructure(domain, idGenerator))
        .toList();
  }
}
