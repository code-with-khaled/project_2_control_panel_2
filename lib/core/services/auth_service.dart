import 'package:control_panel_2/core/api/api_client.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService({required this.apiClient});

  Future<void> login(String email, String password) async {
    final response = await apiClient.post(
      'auth/login',
      body: {'email': email, 'password': password},
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }
  }

  Future<void> logout() async {
    await apiClient.post('auth/logout');
    // Backend should clear the cookie
  }
}
