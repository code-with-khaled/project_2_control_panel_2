class StudentFeedback {
  final int? id;
  final String body;
  final DateTime date;
  final double rating;

  StudentFeedback({
    this.id,
    required this.body,
    required this.date,
    required this.rating,
  });

  factory StudentFeedback.fromJson(Map<String, dynamic> json) =>
      StudentFeedback(
        id: json['id'],
        body: json['body'],
        date: DateTime.parse(json['feedbacked_at']),
        rating: json['rating'],
      );
}
