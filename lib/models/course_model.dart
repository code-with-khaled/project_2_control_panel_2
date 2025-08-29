class Course {
  final String? id;
  final String name;
  final String image;
  final String category;
  // final String description;
  final CourseTeacher teacher;
  final double rating;
  final int enrollments;

  const Course({
    this.id,
    required this.name,
    required this.image,
    required this.category,
    // required this.description,
    required this.teacher,
    required this.rating,
    required this.enrollments,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    category: json['category_name'],
    teacher: CourseTeacher.fromJson(json['teacher']),
    rating: json['rating'],
    enrollments: json['number_of_students'],
  );
}

class CourseTeacher {
  final int id;
  final String firstName;
  final String lastName;
  final String image;

  CourseTeacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  factory CourseTeacher.fromJson(Map<String, dynamic> json) => CourseTeacher(
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    image: json['image'],
  );

  get fullName => '$firstName $lastName';
}
