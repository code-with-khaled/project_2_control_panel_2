import 'package:flutter/foundation.dart';

@immutable
class Teacher {
  final int? id;
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final String? password;
  final String? image;
  final String educationLevel;
  final String specialization;
  final String headline;
  final String experiences;
  final String description;
  final double? rate;
  final int roleId;

  const Teacher({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    this.password,
    this.image,
    required this.educationLevel,
    required this.specialization,
    required this.headline,
    required this.experiences,
    required this.description,
    this.rate,
    this.roleId = 4,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      image: json['image'] as String?,
      educationLevel: json['education_level'] as String,
      specialization: json['specialization'] as String,
      headline: json['headline'] as String,
      experiences: json['experiences'] as String,
      description: json['description'] as String,
      rate: double.parse(json['rate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'phone': phone,
      'password': password,
      'image': image,
      'education_level': educationLevel,
      'specialization': specialization,
      'headline': headline,
      'experiences': experiences,
      'description': description,
      'rate': rate.toString(),
      'role_id': roleId,
    };
  }

  // Helper getters
  String get fullName => '$firstName $lastName';
  String get fullImageUrl => 'http://127.0.0.1:8000$image';
}
