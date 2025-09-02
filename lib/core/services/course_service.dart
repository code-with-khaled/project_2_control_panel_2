import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:http/http.dart' as http;

class CourseService {
  final ApiClient apiClient;

  CourseService({required this.apiClient});

  Future<Map<String, dynamic>> fetchCourses(
    String? token, {
    int page = 1,
  }) async {
    final response = await apiClient.get(
      "dashboard/courses?page=$page",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> items = json['data']['items'];
      final meta = json['data']['meta'];

      return {
        'courses': items.map((json) => Course.fromJson(json)).toList(),
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

  Future<void> createCourse(
    String? token,
    Map<String, String> course,
    String? imageUrl,
    String? filename,
  ) async {
    final uri = Uri.parse("http://127.0.0.1:8000/api/dashboard/courses");
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields.addAll(course);

    if (imageUrl != null) {
      final List<int> imageBytes = base64Decode(imageUrl.split(',').last);
      request.files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: filename),
      );
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Course create failed');
    }
  }

  Future<void> updateCourse(
    String? token,
    int id,
    Map<String, String> course,
  ) async {
    final uri = Uri.parse("http://127.0.0.1:8000/api/dashboard/courses/$id");
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields.addAll(course);

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Course create failed');
    }
  }

  Future<void> deleteCourse(String? token, int id) async {
    final response = await apiClient.delete(
      "dashboard/courses/$id",
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
