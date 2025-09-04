class TeacherDisbursement {
  final int id;
  final String name;
  final int amount;
  final DateTime date;

  TeacherDisbursement({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  factory TeacherDisbursement.fromJson(Map<String, dynamic> json) =>
      TeacherDisbursement(
        id: json['id'],
        name: json['name'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
      );
}
