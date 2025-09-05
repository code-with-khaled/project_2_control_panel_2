import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/discount_model.dart';

class DiscountService {
  final ApiClient apiClient;

  DiscountService({required this.apiClient});

  Future<List<Discount>> fetchDiscounts(String? token) async {
    final response = await apiClient.get("dashboard/discounts", token: token);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];

      return data.map((json) => Discount.fromJson(json)).toList();
    } else {
      throw Exception('Fetch discounts failed');
    }
  }

  Future<void> createDiscount(
    String? token,
    Map<String, dynamic> discount,
  ) async {
    final response = await apiClient.post(
      'dashboard/discounts',
      token: token,
      body: discount,
    );

    if (response.statusCode != 200) {
      throw Exception('Create discount failed');
    }
  }

  Future<void> editDiscount(
    String? token,
    int id,
    Map<String, dynamic> discount,
  ) async {
    final response = await apiClient.put(
      'dashboard/discounts/$id',
      token: token,
      body: discount,
    );

    print(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception('Edit discount failed');
    }
  }

  Future<void> deleteDiscount(String? token, int id) async {
    final response = await apiClient.delete(
      'dashboard/discounts/$id',
      token: token,
    );

    print(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception('Delete discount failed');
    }
  }
}
