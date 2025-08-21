import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/student_model.dart';

class StudentsService {
  final ApiClient apiClient;

  StudentsService({required this.apiClient});

  Future<List<Student>> fetchStudents(String? token) async {
    final response = await apiClient.get("dashboard/students", token: token);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> items = json['data']['items'];
      return items.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Fetch students failed');
    }
  }

  Future<void> createStudent(String? token, Student student) async {
    final response = await apiClient.post(
      "dashboard/students",
      body: student.toJson(),
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Create student failed');
    }
  }

  Future<void> deleteStudent(String? token, int id) async {
    final response = await apiClient.delete(
      "dashboard/students/$id",
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Create student failed');
    }
  }
}
