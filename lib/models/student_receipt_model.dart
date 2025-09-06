class StudentReceipt {
  final int id;
  final String name;
  final int amount;
  final String status;
  final DateTime date;

  StudentReceipt({
    required this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.date,
  });

  factory StudentReceipt.fromJson(Map<String, dynamic> json) => StudentReceipt(
    id: json['id'],
    name: json['name'],
    amount: json['amount'],
    status: json['status'],
    date: DateTime.parse(json['date']),
  );
}

class StudentReceiptDetails {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String type;
  final String name;
  final int transactionId;
  final double amount;
  final DateTime date;
  final String status;

  StudentReceiptDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.type,
    required this.name,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory StudentReceiptDetails.fromJson(Map<String, dynamic> json) {
    return StudentReceiptDetails(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      transactionId: json['transaction_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'type': type,
      'name': name,
      'transaction_id': transactionId,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}
