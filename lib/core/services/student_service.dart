import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/models/student_receipt_model.dart';

class StudentService {
  final ApiClient apiClient;

  StudentService({required this.apiClient});

  Future<Map<String, dynamic>> fetchStudents(
    String? token, {
    int page = 1,
  }) async {
    final response = await apiClient.get(
      "dashboard/students?page=$page",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> items = json['data']['items'];
      final meta = json['data']['meta'];

      return {
        'students': items.map((json) => Student.fromJson(json)).toList(),
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

  Future<void> createStudent(String? token, Student student) async {
    final response = await apiClient.post(
      "dashboard/students",
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

  Future<void> editStudent(String? token, int id, Student student) async {
    final response = await apiClient.put(
      "dashboard/students/$id",
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

  Future<void> deleteStudent(String? token, int id) async {
    final response = await apiClient.delete(
      "dashboard/students/$id",
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

  Future<List<StudentReceipt>> fetchStudentReciepts(
    String? token,
    int id,
  ) async {
    final response = await apiClient.get(
      "dashboard/students/$id/receipts",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((json) => StudentReceipt.fromJson(json)).toList();
    } else {
      throw Exception('Fetch student reciepts Failed');
    }
  }
}
