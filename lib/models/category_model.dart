class Category {
  final int id;
  final String name;
  final int courses;
  final int students;
  final double rating;

  const Category({
    required this.id,
    required this.name,
    required this.courses,
    required this.students,
    required this.rating,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    courses: json['courses_count'],
    students: json['students_count'],
    rating: json['courses_feedbacks_avg_rating'],
  );
}
