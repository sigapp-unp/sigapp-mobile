import 'package:sigapp/courses/domain/entities/course_type.dart';

class ProgramCurriculumCourseInfo {
  final String courseCode;
  final int credits;
  final String courseName;
  final CourseType courseType;
  final int practiceHours;
  final int theoryHours;
  final int termNumber;
  final List<String> requirementCourseCodes;

  ProgramCurriculumCourseInfo({
    required this.courseCode,
    required this.credits,
    required this.courseName,
    required this.courseType,
    required this.practiceHours,
    required this.theoryHours,
    required this.termNumber,
    required this.requirementCourseCodes,
  });

  String get termRomanNumeral {
    return _termNumberToRomanNumeral(termNumber);
  }
}

class ProgramCurriculumCourse {
  final ProgramCurriculumCourseInfo info;
  final List<ProgramCurriculumCourse> prerequisites;
  double? lastGrade;
  bool? isEnrolled;

  ProgramCurriculumCourse({required this.info, required this.prerequisites});

  bool? get isApproved {
    if (lastGrade == null) return null;
    return lastGrade! >= 11;
  }

  bool? get hasPrerequisitesApproved {
    return prerequisites.isEmpty
        ? null
        : prerequisites.every((req) => req.isApproved == true);
  }

  CourseTreeNode? getPrerequisiteCoursesTree({
    required List<ProgramCurriculumTerm> programCurriculum,
  }) {
    final visited = <String>{};
    final allCourses =
        programCurriculum.expand((term) => term.courses).toList();

    CourseTreeNode buildTree(ProgramCurriculumCourse course) {
      visited.add(course.info.courseCode);

      final children = <CourseTreeNode>[];

      for (final prerequisiteCode in course.info.requirementCourseCodes) {
        ProgramCurriculumCourse? prerequisiteCourse;
        final filteredCourses = allCourses.where(
          (element) => element.info.courseCode == prerequisiteCode,
        );
        if (filteredCourses.isNotEmpty) {
          prerequisiteCourse = filteredCourses.first;
        } else {
          continue;
        }

        // Avoid infinite recursion
        if (!visited.contains(prerequisiteCode)) {
          final childNode = buildTree(prerequisiteCourse);
          children.add(childNode);
        }
      }

      return CourseTreeNode(course: course, children: children);
    }

    final root = buildTree(this);
    if (root.children.isEmpty) return null;
    return root;
  }

  CourseTreeNode? getDependentCoursesTree({
    required List<ProgramCurriculumTerm> programCurriculum,
  }) {
    final visited = <String>{};
    final allCourses =
        programCurriculum.expand((term) => term.courses).toList();

    CourseTreeNode buildTree(ProgramCurriculumCourse course) {
      visited.add(course.info.courseCode);

      final children = <CourseTreeNode>[];

      // Buscar cursos que dependen de este curso
      final dependents = allCourses.where(
        (c) => c.info.requirementCourseCodes.contains(course.info.courseCode),
      );

      for (final dependentCourse in dependents) {
        if (!visited.contains(dependentCourse.info.courseCode)) {
          final childNode = buildTree(dependentCourse);
          children.add(childNode);
        }
      }

      return CourseTreeNode(course: course, children: children);
    }

    final root = buildTree(this);
    if (root.children.isEmpty) return null;
    return root;
  }
}

class CourseTreeNode {
  final ProgramCurriculumCourse course;
  final List<CourseTreeNode> children;

  CourseTreeNode({required this.course, required this.children});

  int get depth {
    if (children.isEmpty) return 1;
    return 1 + children.map((e) => e.depth).reduce((a, b) => a > b ? a : b);
  }
}

class ProgramCurriculumTerm {
  final int termNumber;
  final List<ProgramCurriculumCourse> courses;

  ProgramCurriculumTerm({required this.termNumber, required this.courses});

  String get termRomanNumeral {
    return _termNumberToRomanNumeral(termNumber);
  }
}

String _termNumberToRomanNumeral(int termNumber) {
  final labelsMap = <int, String>{
    1: 'I',
    2: 'II',
    3: 'III',
    4: 'IV',
    5: 'V',
    6: 'VI',
    7: 'VII',
    8: 'VIII',
    9: 'IX',
    10: 'X',
    11: 'XI',
    12: 'XII',
  };
  final label = labelsMap[termNumber];
  if (label != null) return label;
  return termNumber.toString();
}
