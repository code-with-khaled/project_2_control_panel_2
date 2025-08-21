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
      throw Exception('Login failed');
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
