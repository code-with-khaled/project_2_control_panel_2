import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/category_model.dart';

class CategoryService {
  final ApiClient apiClient;

  CategoryService({required this.apiClient});

  Future<List<Category>> fetchCategories(String? token) async {
    final response = await apiClient.get('dashboard/categories', token: token);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];

      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Fetch categories failed');
    }
  }

  Future<void> createCategory(String? token, String name) async {
    final response = await apiClient.post(
      'dashboard/categories',
      token: token,
      body: {"translations[ar][name]": name},
    );

    if (response.statusCode != 200) {
      throw Exception('Category create failed');
    }
  }

  Future<void> editCategory(String? token, int id, String name) async {
    final response = await apiClient.post(
      'dashboard/categories/$id',
      token: token,
      body: {"translations[ar][name]": name, "_method": "PUT"},
    );

    if (response.statusCode != 200) {
      throw Exception('Category edit failed');
    }
  }

  Future<void> deleteCategory(String? token, int id) async {
    final response = await apiClient.delete(
      'dashboard/categories/$id',
      token: token,
    );

    if (response.statusCode != 200) {
      throw Exception('Category delete failed');
    }
  }
}
