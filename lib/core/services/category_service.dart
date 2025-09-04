import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/category_model.dart';

class CategoryService {
  final ApiClient apiClient;

  CategoryService({required this.apiClient});

  Future<List<Category>> fetchCategories(String? token) async {
    final response = await apiClient.get('dashboard/categories', token: token);

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];

      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Fetch categories failed');
    }
  }
}
