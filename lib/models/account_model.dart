class Account {
  final String type;
  final String firstName;
  final String lastName;
  final String username;
  final String phoneNumber;
  final String education;
  final int roleId;

  const Account({
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phoneNumber,
    required this.education,
    required this.roleId,
  });

  // Helper getters
  String get fullName => '$firstName $lastName';
}
