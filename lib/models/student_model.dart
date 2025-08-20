class Student {
  final int id;
  final String username;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phone;
  final String parentPhone;
  final String? image;
  final String educationLevel;
  final String gender;
  final DateTime birthDate;

  Student({
    required this.id,
    required this.username,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phone,
    required this.parentPhone,
    this.image,
    required this.educationLevel,
    required this.gender,
    required this.birthDate,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'],
    username: json['username'],
    firstName: json['first_name'],
    middleName: json['middle_name'],
    lastName: json['last_name'],
    phone: json['phone'],
    parentPhone: json['parent_phone'],
    image: json['image'],
    educationLevel: json['education_level'],
    gender: json['gender'],
    birthDate: DateTime.parse(json['birth_date']),
  );
}
