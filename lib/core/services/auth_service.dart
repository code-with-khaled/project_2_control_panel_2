import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService({required this.apiClient});

  Future<String> login({
    required String username,
    required String password,
    required int roleId,
  }) async {
    final response = await apiClient.post(
      'auth/login',
      body: {'username': username, 'password': password, 'role_id': roleId},
    );

    // ignore: avoid_print
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['token'];
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
        } else {
          detailedErrors = '\n• $messages';
        }
      });
      throw Exception('$message$detailedErrors');
    }
  }

  Future<void> sendOTP(String username) async {
    final response = await apiClient.post(
      'auth/forget-password',
      body: {'username': username},
    );

    // ignore: avoid_print
    print(jsonDecode(response.body));

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
        } else {
          detailedErrors = '\n• $messages';
        }
      });
      throw Exception('$message$detailedErrors');
    }
  }

  Future<void> verifyOTP(String username, String code) async {
    final response = await apiClient.post(
      'auth/verify',
      body: {'username': username, 'code': code},
    );

    // ignore: avoid_print
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
    } else {
      throw Exception('رمز التحقق غير صحيح أو منتهي الصلاحية');
    }
  }

  Future<void> resetPassword(
    String username,
    String code,
    String password,
  ) async {
    final response = await apiClient.post(
      'auth/change-password',
      body: {'username': username, 'code': code, 'password': password},
    );

    // ignore: avoid_print
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
    } else {
      throw Exception('فشل إعادة تعيين كلمة المرور');
    }
  }

  Future<void> logout(String token) async {
    final response = await apiClient.post('auth/logout', token: token);

    // ignore: avoid_print
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
    } else {
      throw Exception('Logout failed');
    }
  }
}
