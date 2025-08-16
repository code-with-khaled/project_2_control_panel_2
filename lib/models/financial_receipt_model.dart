class FinancialReceipt {
  final String number;
  final String type;
  final String date;
  final String person;
  final String item;
  String? service;
  final String ammount;
  String? reason;

  FinancialReceipt({
    required this.reason,
    required this.number,
    required this.type,
    required this.date,
    required this.person,
    required this.item,
    required this.service,
    required this.ammount,
  });
}
