class Discount {
  final String title;
  final String description;
  final int value;
  final int quantity;
  final String date;
  final bool allUsers;

  const Discount({
    required this.title,
    required this.description,
    required this.value,
    required this.quantity,
    required this.date,
    required this.allUsers,
  });
}
