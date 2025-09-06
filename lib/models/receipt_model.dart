class Receipt {
  final int? id;
  final String name;
  final int amount;
  final String status;
  final DateTime date;
  final String student;

  Receipt({
    this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.date,
    required this.student,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
    id: json['id'],
    name: json['name'],
    amount: json['amount'],
    status: json['status'],
    date: DateTime.parse(json['date']),
    student: json['student_name'],
  );
}
