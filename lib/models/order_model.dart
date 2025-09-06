class Order {
  final int? id;
  final String courseName;
  final int amount;
  final DateTime date;
  final String teacher;

  Order({
    this.id,
    required this.courseName,
    required this.amount,
    required this.date,
    required this.teacher,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    courseName: json['course_name'],
    amount: json['amount'],
    date: DateTime.parse(json['date']),
    teacher: json['teacher_name'],
  );
}
