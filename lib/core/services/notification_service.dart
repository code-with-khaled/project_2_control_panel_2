import 'package:control_panel_2/core/api/api_client.dart';

class NotificationService {
  final ApiClient apiClient;

  NotificationService({required this.apiClient});

  Future<void> sendToStudent(String? token, String message, int id) async {
    final response = await apiClient.post(
      "dashboard/notifications/students/send/$id",
      body: {'message': message},
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Sending Notification Failed');
    }
  }

  Future<void> sendToTeacher(String? token, String message, int id) async {
    final response = await apiClient.post(
      "dashboard/notifications/teachers/send/$id",
      body: {'message': message},
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Sending Notification Failed');
    }
  }

  Future<void> sendToAllStudents(String? token, String message) async {
    final response = await apiClient.post(
      "dashboard/notifications/students/send-all",
      body: {'message': message},
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Sending Notification Failed');
    }
  }

  Future<void> sendToAllTeachers(String? token, String message) async {
    final response = await apiClient.post(
      "dashboard/notifications/teachers/send-all",
      body: {'message': message},
      token: token,
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Sending Notification Failed');
    }
  }
}
