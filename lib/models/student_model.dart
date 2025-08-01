class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String joinDate;
  final List<String> subjects;

  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.joinDate,
    required this.subjects,
  });

  // Helper getters
  String get fullName => '$firstName $lastName';
}
