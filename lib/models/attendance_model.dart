class Attendance {
  final int id;
  final AttendanceStudent student;
  final String status;
  final Reason? reason;
  final String? notes;

  Attendance({
    required this.id,
    required this.student,
    required this.status,
    this.reason,
    this.notes,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json['id'],
    student: AttendanceStudent.fromJson(json['student']),
    status: json['status'],
    notes: json['notes'],
  );
}

class AttendanceStudent {
  final int id;
  final String firstName;
  final String middletName;
  final String lastName;

  AttendanceStudent({
    required this.id,
    required this.firstName,
    required this.middletName,
    required this.lastName,
  });

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) =>
      AttendanceStudent(
        id: json['id'],
        firstName: json['first_name'],
        middletName: json['middle_name'],
        lastName: json['last_name'],
      );

  get fullName => '$firstName $middletName $lastName';
}

class Reason {
  final String reason;
  final String? type;
  final String? document;

  Reason({required this.reason, this.type, this.document});

  factory Reason.fromJson(Map<String, dynamic> json) =>
      Reason(reason: json['reason']);
}
