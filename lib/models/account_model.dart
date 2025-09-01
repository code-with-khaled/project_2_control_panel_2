class Account {
  final String type;
  final String? image;
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final String educationLevel;
  final String? password;
  final int roleId;

  const Account({
    required this.type,
    this.image,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    required this.educationLevel,
    this.password,
    required this.roleId,
  });

  Map<String, dynamic> toJson() => {
    'image': image,
    'first_name': firstName,
    'last_name': lastName,
    'username': username,
    'phone': phone,
    'education_level': educationLevel,
    'password': password,
  };

  // Helper getters
  String get fullName => '$firstName $lastName';
}
