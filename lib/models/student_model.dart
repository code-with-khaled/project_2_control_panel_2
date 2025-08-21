class Student {
  final int? id;
  final String username;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phone;
  final String parentPhone;
  final String? image;
  final String? password;
  final String educationLevel;
  final String gender;
  final DateTime birthDate;
  final int roleId;

  Student({
    this.id,
    required this.username,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phone,
    required this.parentPhone,
    this.image,
    this.password,
    required this.educationLevel,
    required this.gender,
    required this.birthDate,
    this.roleId = 5,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'first_name': firstName,
    'middle_name': middleName,
    'last_name': lastName,
    'phone': phone,
    'parent_phone': parentPhone,
    'image': image,
    'password': password,
    'education_level': educationLevel,
    'gender': gender,
    'birth_date': birthDate.toIso8601String(),
    'role_id': roleId,
  };

  // Helper getters
  String get fullName => '$firstName $middleName $lastName';
}
