import 'package:flutter/foundation.dart';

@immutable
class Teacher {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String mobileNumber;
  final String educationLevel;
  final String specialization;
  final String certificates;
  final String experience;
  final String description;
  final Uint8List? profileImage;
  final DateTime joinDate;
  final double rating;
  final bool isActive;

  const Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.mobileNumber,
    required this.educationLevel,
    required this.specialization,
    required this.certificates,
    required this.experience,
    required this.description,
    this.profileImage,
    required this.joinDate,
    this.rating = 0.0,
    this.isActive = true,
  });

  // Named constructor for empty teacher
  Teacher.empty()
    : this(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        mobileNumber: '',
        educationLevel: '',
        specialization: '',
        certificates: '',
        experience: '',
        description: '',
        profileImage: null,
        joinDate: DateTime.now(),
        rating: 0.0,
        isActive: false,
      );

  // CopyWith method for immutable updates
  Teacher copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? mobileNumber,
    String? educationLevel,
    String? specialization,
    String? certificates,
    String? experience,
    String? description,
    Uint8List? profileImage,
    DateTime? joinDate,
    double? rating,
    bool? isActive,
  }) {
    return Teacher(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      educationLevel: educationLevel ?? this.educationLevel,
      specialization: specialization ?? this.specialization,
      certificates: certificates ?? this.certificates,
      experience: experience ?? this.experience,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      joinDate: joinDate ?? this.joinDate,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
    );
  }

  // JSON Serialization
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      username: json['username'] as String,
      mobileNumber: json['mobileNumber'] as String,
      educationLevel: json['educationLevel'] as String,
      specialization: json['specialization'] as String,
      certificates: json['certificates'] as String,
      experience: json['experience'] as String,
      description: json['description'] as String,
      profileImage: json['profileImage'] != null
          ? Uint8List.fromList(List<int>.from(json['profileImage']))
          : null,
      joinDate: DateTime.parse(json['joinDate'] as String),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'mobileNumber': mobileNumber,
      'educationLevel': educationLevel,
      'specialization': specialization,
      'certificates': certificates,
      'experience': experience,
      'description': description,
      'profileImage': profileImage?.toList(),
      'joinDate': joinDate.toIso8601String(),
      'rating': rating,
      'isActive': isActive,
    };
  }

  // Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Teacher &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username &&
        other.mobileNumber == mobileNumber &&
        other.educationLevel == educationLevel &&
        other.specialization == specialization &&
        other.certificates == certificates &&
        other.experience == experience &&
        other.description == description &&
        listEquals(other.profileImage, profileImage) &&
        other.joinDate == joinDate &&
        other.rating == rating &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      firstName,
      lastName,
      username,
      mobileNumber,
      educationLevel,
      specialization,
      certificates,
      experience,
      description,
      profileImage,
      joinDate,
      rating,
      isActive,
    );
  }

  // Helper getters
  String get fullName => '$firstName $lastName';
  String get formattedJoinDate =>
      '${joinDate.day}/${joinDate.month}/${joinDate.year}';
}
