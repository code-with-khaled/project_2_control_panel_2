class Curriculum {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final int students;
  final List<String> subjects;
  final String status;

  const Curriculum({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.students,
    required this.subjects,
    required this.status,
  });
}
