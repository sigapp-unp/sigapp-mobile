class CourseTracking {
  final String? id;
  final String studentCode;
  final String courseCode;
  final List<GradeCategory> categories;

  CourseTracking({
    this.id,
    required this.courseCode,
    required this.studentCode,
    required this.categories,
  });

  bool get isWeightValid {
    if (categories.isEmpty) return false;
    final totalWeight = categories.map((c) => c.weight).reduce((a, b) => a + b);
    return totalWeight == 100.0;
  }

  double get weightDifference {
    if (categories.isEmpty) return 100.0;
    final totalWeight = categories.map((c) => c.weight).reduce((a, b) => a + b);
    return 100.0 - totalWeight;
  }

  double get finalGrade {
    if (categories.isEmpty) return 0.0;
    final totalContribution = categories
        .map((c) => c.weightedContribution)
        .reduce((a, b) => a + b);
    return totalContribution;
  }

  /// Creates a course with default categories and grades
  /// This structure includes:
  /// - Assessments (with 4 evaluations)
  /// - Midterm Exam (with 1 grade)
  /// - Final Exam (with 1 grade)
  /// - Final Project (with 1 grade)
  static CourseTracking createWithDefaults({
    required String courseCode,
    required String studentCode,
  }) {
    const evaluacionesWeight = 40.0;
    const examenParcialWeight = 20.0;
    const examenFinalWeight = 20.0;
    const trabajoFinalWeight = 20.0;

    List<GradeCategory> defaultCategories = [];

    // Evaluaciones con 4 notas
    List<Grade> evaluacionesGrades = [];
    for (int i = 1; i <= 4; i++) {
      evaluacionesGrades.add(Grade(name: "Evaluación $i", score: 0.0));
    }
    defaultCategories.add(
      GradeCategory(
        name: "Evaluaciones",
        weight: evaluacionesWeight,
        grades: evaluacionesGrades,
      ),
    );

    // Examen parcial
    defaultCategories.add(
      GradeCategory(
        name: "Examen Parcial",
        weight: examenParcialWeight,
        grades: [Grade(name: "Nota", score: 0.0)],
      ),
    );

    // Examen final
    defaultCategories.add(
      GradeCategory(
        name: "Examen Final",
        weight: examenFinalWeight,
        grades: [Grade(name: "Nota", score: 0.0)],
      ),
    );

    // Trabajo final
    defaultCategories.add(
      GradeCategory(
        name: "Trabajo Final",
        weight: trabajoFinalWeight,
        grades: [Grade(name: "Nota", score: 0.0)],
      ),
    );

    return CourseTracking(
      courseCode: courseCode,
      studentCode: studentCode,
      categories: defaultCategories,
    );
  }

  CourseTracking copyWith({
    String? id,
    String? studentCode,
    String? courseCode,
    List<GradeCategory>? categories,
  }) {
    return CourseTracking(
      id: id ?? this.id,
      studentCode: studentCode ?? this.studentCode,
      courseCode: courseCode ?? this.courseCode,
      categories: categories ?? this.categories,
    );
  }
}

class GradeCategory {
  final String? id;
  final String name;
  final double weight;
  final List<Grade> grades;

  GradeCategory({
    this.id,
    required this.name,
    required this.weight,
    required this.grades,
  });

  double get averagePercentage {
    final enabledGrades = grades.where((g) => g.enabled).toList();
    if (enabledGrades.isEmpty) return 0.0;
    final total = enabledGrades.map((g) => g.score).reduce((a, b) => a + b);
    return total / enabledGrades.length;
  }

  double get weightedContribution {
    return (averagePercentage * (weight / 100));
  }

  GradeCategory copyWith({
    String? id,
    String? name,
    double? weight,
    List<Grade>? grades,
  }) {
    return GradeCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      grades: grades ?? this.grades,
    );
  }
}

class Grade {
  final String? id;
  final String name;
  final double score;
  final bool enabled;

  Grade({
    this.id,
    required this.name,
    required this.score,
    this.enabled = true,
  });

  Grade copyWith({String? id, String? name, double? score, bool? enabled}) {
    return Grade(
      id: id ?? this.id,
      name: name ?? this.name,
      score: score ?? this.score,
      enabled: enabled ?? this.enabled,
    );
  }
}
