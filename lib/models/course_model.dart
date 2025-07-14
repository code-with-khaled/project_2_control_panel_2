class Course {
  final String id;
  final String name;
  final String categorization;
  final String description;
  final String state;
  final String teacher;
  final int enrollments;
  final int price;

  const Course({
    required this.id,
    required this.name,
    required this.categorization,
    required this.description,
    required this.state,
    required this.teacher,
    required this.enrollments,
    required this.price,
  });
}
