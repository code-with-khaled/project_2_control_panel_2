class Mark {
  final int id;
  final String title;
  final String type;
  final DateTime date;
  final double maxScore;
  final List<StudentGrades> studentsGrades;

  Mark({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.maxScore,
    required this.studentsGrades,
  });

  factory Mark.fromJson(Map<String, dynamic> json) => Mark(
    id: json['id'],
    title: json['title'],
    type: json['type'],
    date: DateTime.parse(json['date']),
    maxScore: double.parse(json['max_score']),
    studentsGrades: (json['grades'] as List)
        .map((gradeJson) => StudentGrades.fromJson(gradeJson))
        .toList(),
  );
}

class StudentGrades {
  final int id;
  final AStudent student;
  final double score;
  final String? notes;

  StudentGrades({
    required this.id,
    required this.student,
    required this.score,
    this.notes,
  });

  factory StudentGrades.fromJson(Map<String, dynamic> json) => StudentGrades(
    id: json['id'],
    student: AStudent.fromJson(json['student']),
    score: json['score'],
    notes: json['notes'],
  );
}

class AStudent {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;

  AStudent({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  factory AStudent.fromJson(Map<String, dynamic> json) => AStudent(
    id: json['id'],
    firstName: json['first_name'],
    middleName: json['middle_name'],
    lastName: json['last_name'],
  );

  String get fullName => '$firstName $middleName $lastName';
}
