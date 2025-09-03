class CourseFeedback {
  final int? id;
  final String body;
  final DateTime date;
  final int rating;
  final CourseFeedbackStudent student;

  CourseFeedback({
    this.id,
    required this.body,
    required this.date,
    required this.rating,
    required this.student,
  });

  factory CourseFeedback.fromJson(Map<String, dynamic> json) => CourseFeedback(
    id: json['id'],
    body: json['body'],
    date: DateTime.parse(json['feedbacked_at']),
    rating: json['rating'],
    student: CourseFeedbackStudent.fromJson(json['student']),
  );
}

class CourseFeedbackStudent {
  final int id;
  final String firstName;
  final String lastName;

  CourseFeedbackStudent({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory CourseFeedbackStudent.fromJson(Map<String, dynamic> json) =>
      CourseFeedbackStudent(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );

  get fullName => '$firstName $lastName';
}
