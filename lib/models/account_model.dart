class Account {
  final int? id;
  final String? type;
  final String? image;
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final String educationLevel;
  final String? password;
  final int roleId;

  const Account({
    this.id,
    this.type,
    this.image,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    required this.educationLevel,
    this.password,
    required this.roleId,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json['id'],
    type: json['role_id'] == 2 ? "staff" : "finance",
    image: json['image'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    username: json['username'],
    phone: json['phone'],
    educationLevel: json['education_level'],
    roleId: json['role_id'] ?? 2,
  );

  Map<String, dynamic> toJson() => {
    'image': image,
    'first_name': firstName,
    'last_name': lastName,
    'username': username,
    'phone': phone,
    'education_level': educationLevel,
    'password': password,
    'role_id': type == "staff" ? 2 : 3,
  };

  // Helper getters
  String get fullName => '$firstName $lastName';
}
