class StudentCourse {
  final int? id;
  final String? image;
  final String name;
  final String category;
  final String studentCount;
  final int rating;
  final CourseTeacher teacher;

  StudentCourse({
    this.id,
    this.image,
    required this.name,
    required this.category,
    required this.studentCount,
    required this.rating,
    required this.teacher,
  });

  factory StudentCourse.fromJson(Map<String, dynamic> json) => StudentCourse(
    id: json['id'],
    image: json['image'],
    name: json['name'],
    category: json['category_name'],
    studentCount: json['number_of_students'],
    rating: json['rating'],
    teacher: CourseTeacher.fromJson(json['teacher']),
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
