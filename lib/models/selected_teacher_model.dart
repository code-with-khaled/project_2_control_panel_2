class SelectedTeacher {
  final int id;
  final String firstName;
  final String lastName;

  SelectedTeacher({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory SelectedTeacher.fromJson(Map<String, dynamic> json) =>
      SelectedTeacher(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );

  get fullName => '$firstName $lastName';
}
