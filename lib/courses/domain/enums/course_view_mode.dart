enum CourseViewMode {
  tree('tree'),
  list('list');

  const CourseViewMode(this.value);

  final String value;

  static CourseViewMode fromString(String value) {
    switch (value) {
      case 'tree':
        return CourseViewMode.tree;
      case 'list':
        return CourseViewMode.list;
      default:
        return CourseViewMode.tree; // default fallback
    }
  }

  @override
  String toString() => value;
}
