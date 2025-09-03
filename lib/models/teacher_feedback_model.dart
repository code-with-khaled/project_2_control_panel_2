class TeacherFeedback {
  final int? id;
  final String body;
  final DateTime date;
  final int rating;
  final TeacherFeedbackStudent student;

  TeacherFeedback({
    this.id,
    required this.body,
    required this.date,
    required this.rating,
    required this.student,
  });

  factory TeacherFeedback.fromJson(Map<String, dynamic> json) =>
      TeacherFeedback(
        id: json['id'],
        body: json['body'],
        date: DateTime.parse(json['feedbacked_at']),
        rating: json['rating'],
        student: TeacherFeedbackStudent.fromJson(json['student']),
      );
}

class TeacherFeedbackStudent {
  final int id;
  final String firstName;
  final String lastName;

  TeacherFeedbackStudent({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory TeacherFeedbackStudent.fromJson(Map<String, dynamic> json) =>
      TeacherFeedbackStudent(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );

  get fullName => '$firstName $lastName';
}
