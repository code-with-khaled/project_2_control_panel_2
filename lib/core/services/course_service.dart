import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/attendance_model.dart';
import 'package:control_panel_2/models/course_feedback_model.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/models/course_receipt_mode.dart';
import 'package:control_panel_2/models/lecture_model.dart';
import 'package:control_panel_2/models/mark_model.dart';
import 'package:control_panel_2/models/selected_course_model.dart';
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

  Future<List<SelectedCourse>> fetchCoursesToSelect(String? token) async {
    final response = await apiClient.get(
      "dashboard/course-list/1",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> teachers = json['data'];

      return teachers.map((json) => SelectedCourse.fromJson(json)).toList();
    } else {
      throw Exception('Fetch courses to select failed');
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
    request.fields['_method'] = 'PUT';

    final response = await request.send();
    final body = await response.stream.bytesToString();
    // ignore: avoid_print
    print(jsonDecode(body));

    if (response.statusCode != 200) {
      throw Exception('Course update failed');
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

  Future<void> enrollStudent(String? token, int id) async {
    // ignore: unused_local_variable
    final response = await apiClient.delete("dashboard/enroll", token: token);
  }

  Future<List<Lecture>> fetchLectures(String? token, int id) async {
    final response = await apiClient.get(
      "dashboard/courses/$id/lectures",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((json) => Lecture.fromJson(json)).toList();
    } else {
      throw Exception('Fetch lectures failed');
    }
  }

  Future<List<Attendance>> fetchAttendances(String? token, int id) async {
    final response = await apiClient.get(
      "dashboard/lectures/$id/attendances",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Fetch lectures failed');
    }
  }

  Future<List<Mark>> fetchCourseGrades(String? token, int id) async {
    final response = await apiClient.get(
      "dashboard/courses/$id/assessments",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((json) => Mark.fromJson(json)).toList();
    } else {
      throw Exception('Fetch course reciepts Failed');
    }
  }

  Future<List<CourseReceipt>> fetchCourseReciepts(String? token, int id) async {
    final response = await apiClient.get(
      "dashboard/courses/$id/receipts",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((json) => CourseReceipt.fromJson(json)).toList();
    } else {
      throw Exception('Fetch course reciepts Failed');
    }
  }

  Future<Map<String, dynamic>> fetchCourseFeedbacks(
    String? token,
    int id,
  ) async {
    final response = await apiClient.get(
      "dashboard/courses/$id/feedbacks",
      token: token,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'];
      final feedbacks = (data['feedbacks'] as List<dynamic>)
          .map((json) => CourseFeedback.fromJson(json))
          .toList();

      return {
        'count': data['count'],
        'average': data['average'],
        'feedbacks': feedbacks,
      };
    } else {
      throw Exception('Fetch coruse feedbacks failed');
    }
  }
}
