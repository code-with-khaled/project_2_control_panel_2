class Category {
  final int id;
  final String name;
  final String? status;
  final int? courses;
  final int? students;
  final int? revenue;
  final double? rating;

  const Category({
    required this.id,
    required this.name,
    this.status,
    this.courses,
    this.students,
    this.revenue,
    this.rating,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'], name: json['name']);
}
