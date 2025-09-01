import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/account_model.dart';

class AccountService {
  final ApiClient apiClient;

  AccountService({required this.apiClient});

  // ignore: unused_element
  Future<void> _createAccount(String? token, Account account) async {
    final response = await apiClient.post(
      'dashboard/employees',
      token: token,
      body: account.toJson(),
    );

    // ignore: avoid_print
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
    } else {
      throw Exception('فشل إنشاء الحساب');
    }
  }
}
