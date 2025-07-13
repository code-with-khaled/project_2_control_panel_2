class Course {
  final String id;
  final String name;
  final String categorization;
  final String state;
  final String teacher;
  final int enrollments;

  const Course({
    required this.id,
    required this.name,
    required this.categorization,
    required this.state,
    required this.teacher,
    required this.enrollments,
  });
}
