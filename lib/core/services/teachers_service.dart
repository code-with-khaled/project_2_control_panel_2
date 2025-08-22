import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/teacher_model.dart';

class TeachersService {
  final ApiClient apiClient;

  TeachersService({required this.apiClient});

  Future<Map<String, dynamic>> fetchTeachers(
    String? token, {
    int page = 1,
  }) async {
    final response = await apiClient.get(
      "dashboard/teachers?page=$page",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> items = json['data']['items'];
      final meta = json['data']['meta'];

      return {
        'teachers': items.map((json) => Teacher.fromJson(json)).toList(),
        'pagination': {
          'current_page': meta['current_page'],
          'last_page': meta['last_page'],
          'per_page': meta['per_page'],
          'total': meta['total'],
        },
      };
    } else {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'حدث خطأ غير متوقع';
      final errors = errorData['errors'] as Map<String, dynamic>?;
      String detailedErrors = '';
      errors?.forEach((field, messages) {
        if (messages is List) {
          for (var msg in messages) {
            detailedErrors += '\n• $msg';
          }
        }
      });
      throw Exception('$message$detailedErrors');
    }
  }

  Future<void> createTeacher(String? token, Teacher teacher) async {
    final response = await apiClient.post(
      "dashboard/teachers",
      body: teacher.toJson(),
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'حدث خطأ غير متوقع';
      final errors = errorData['errors'] as Map<String, dynamic>?;
      String detailedErrors = '';
      errors?.forEach((field, messages) {
        if (messages is List) {
          for (var msg in messages) {
            detailedErrors += '\n• $msg';
          }
        }
      });
      throw Exception('$message$detailedErrors');
    }
  }

  Future<void> editTeacher(String? token, int id, Teacher student) async {
    final response = await apiClient.put(
      "dashboard/teachers/$id",
      body: student.toJson(),
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'حدث خطأ غير متوقع';
      final errors = errorData['errors'] as Map<String, dynamic>?;
      String detailedErrors = '';
      errors?.forEach((field, messages) {
        if (messages is List) {
          for (var msg in messages) {
            detailedErrors += '\n• $msg';
          }
        }
      });
      throw Exception('$message$detailedErrors');
    }
  }

  Future<void> deleteTeacher(String? token, int id) async {
    final response = await apiClient.delete(
      "dashboard/teachers/$id",
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'حدث خطأ غير متوقع';
      final errors = errorData['errors'] as Map<String, dynamic>?;
      String detailedErrors = '';
      errors?.forEach((field, messages) {
        if (messages is List) {
          for (var msg in messages) {
            detailedErrors += '\n• $msg';
          }
        }
      });
      throw Exception('$message$detailedErrors');
    }
  }
}
