import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/account_model.dart';
import 'package:http/http.dart' as http;

class AccountService {
  final ApiClient apiClient;

  AccountService({required this.apiClient});

  Future<List<Account>> fetchAccounts(String? token) async {
    final response = await apiClient.get('dashboard/employees', token: token);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];

      return data.map((json) => Account.fromJson(json)).toList();
    } else {
      throw Exception('Fetch accounts failed');
    }
  }

  Future<void> createAccount(
    String? token,
    Account account,
    String? imageUrl,
    String? filename,
  ) async {
    final uri = Uri.parse("http://127.0.0.1:8000/api/dashboard/employees");
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['first_name'] = account.firstName;
    request.fields['last_name'] = account.lastName;
    request.fields['username'] = account.username;
    request.fields['phone'] = account.phone;
    request.fields['education_level'] = account.educationLevel;
    request.fields['password'] = account.password!;
    request.fields['role_id'] = account.roleId.toString();

    if (imageUrl != null) {
      final List<int> imageBytes = base64Decode(imageUrl.split(',').last);
      request.files.add(
        http.MultipartFile.fromBytes('media', imageBytes, filename: filename),
      );
    }

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    // ignore: avoid_print
    print(jsonDecode(responseBody));

    if (response.statusCode == 200) {
    } else {
      throw Exception('فشل إنشاء الحساب');
    }
  }
}
