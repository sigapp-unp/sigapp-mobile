import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/infrastructure/models/models.dart';

class CourseMapper {
  static CourseTracking toDomain(
    CourseModel model, {
    required String courseCode,
  }) {
    // Convertir las categorías (Map infra) a entidades de dominio (List)
    // Ordenar categories por clave numérica cuando corresponda
    final categoryEntries = model.categories.entries.toList();
    categoryEntries.sort((a, b) {
      final ai = int.tryParse(a.key) ?? 0;
      final bi = int.tryParse(b.key) ?? 0;
      return ai.compareTo(bi);
    });
    // categoryEntries already holds the ordered categories

    // Para grades, también ordenar por key y mapear
    final gradeEntries = model.grades.entries.toList();
    gradeEntries.sort((a, b) {
      final ai = int.tryParse(a.key) ?? 0;
      final bi = int.tryParse(b.key) ?? 0;
      return ai.compareTo(bi);
    });
    // gradeEntries already holds the ordered grades

    // Construir categorías de dominio conservando los ids (keys) de infra
    final categories =
        categoryEntries.map((categoryEntry) {
          final categoryKey = categoryEntry.key;
          final categoryModel = categoryEntry.value;

          // Encontrar grades correspondentes y mantener sus keys como ids
          final categoryGrades =
              gradeEntries
                  .where(
                    (ge) => ge.value.categoryIndex == int.tryParse(categoryKey),
                  )
                  .map(
                    (ge) => Grade(
                      id: ge.key,
                      name: ge.value.name,
                      score: ge.value.score,
                      enabled: ge.value.enabled,
                    ),
                  )
                  .toList();

          return GradeCategory(
            id: categoryKey,
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
    // Convert domain lists into infra maps keyed by index string
    final categories = <String, CategoryModel>{};
    final grades = <String, GradeModel>{};

    int gradeIndex = 0;
    for (
      int categoryIndex = 0;
      categoryIndex < domain.categories.length;
      categoryIndex++
    ) {
      final category = domain.categories[categoryIndex];
      categories['$categoryIndex'] = CategoryModel(
        name: category.name,
        weight: category.weight,
      );

      for (final grade in category.grades) {
        grades['$gradeIndex'] = GradeModel(
          categoryIndex: categoryIndex,
          name: grade.name,
          score: grade.score,
          enabled: grade.enabled,
        );
        gradeIndex++;
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
