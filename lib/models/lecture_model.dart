class Lecture {
  final int id;
  final String name;
  final String date;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? reason;

  Lecture({
    required this.id,
    required this.name,
    required this.date,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.reason,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => Lecture(
    id: json['id'],
    name: json['name'],
    date: json['date'],
    startDate: json['start_date'],
    endDate: json['end_date'],
    status: json['status'],
    reason: json['reason'],
  );
}
