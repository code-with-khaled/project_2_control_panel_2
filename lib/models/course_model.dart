class Course {
  final int? id;
  final String name;
  final String image;
  final String categoryName;
  final String description;
  final CourseTeacher teacher;
  final int rating;
  final int enrollments;
  final DateTime startDate;
  final DateTime endDate;
  final int price;
  final String level;
  final int numberOfHours;

  const Course({
    this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.categoryName,
    required this.price,
    required this.teacher,
    required this.rating,
    required this.startDate,
    required this.endDate,
    required this.level,
    required this.enrollments,
    required this.numberOfHours,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    description: json['description'],
    categoryName: json['category_name'],
    teacher: CourseTeacher.fromJson(json['teacher']),
    rating: json['rating'],
    enrollments: json['number_of_students'],
    startDate: DateTime.parse(json['start_date']),
    endDate: DateTime.parse(json['end_date']),
    price: json['price'],
    level: json['level'],
    numberOfHours: json['number_of_hours'],
  );
}

class CourseTeacher {
  final int id;
  final String firstName;
  final String lastName;
  final String? image;

  CourseTeacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
  });

  factory CourseTeacher.fromJson(Map<String, dynamic> json) => CourseTeacher(
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    image: json['image'],
  );

  get fullName => '$firstName $lastName';
}
