import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/category_model.dart';
import 'package:http/http.dart' as http;

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

  Future<void> createCategory(
    String? token,
    String name,
    String? imageUrl,
    String? filename,
  ) async {
    final uri = Uri.parse("http://127.0.0.1:8000/api/dashboard/categories");
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['translations[ar][name]'] = name;

    if (imageUrl != null) {
      final List<int> imageBytes = base64Decode(imageUrl.split(',').last);
      request.files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: filename),
      );
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Category create failed');
    }
  }

  Future<void> editCategory(
    String? token,
    int id,
    String? name,
    String? imageUrl,
    String? filename,
  ) async {
    final uri = Uri.parse("http://127.0.0.1:8000/api/dashboard/categories/$id");
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (name != null) request.fields['translations[ar][name]'] = name;
    request.fields['_method'] = 'PUT';

    if (imageUrl != null) {
      final List<int> imageBytes = base64Decode(imageUrl.split(',').last);
      request.files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: filename),
      );
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Category create failed');
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
