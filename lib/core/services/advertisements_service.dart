import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/advertisement_model.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdvertisementsService {
  final ApiClient apiClient;

  AdvertisementsService({required this.apiClient});

  Future<List<Advertisement>> fetchAdvertisements(String? token) async {
    final response = await apiClient.get('dashboard/ads', token: token);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];

      return data.map((json) => Advertisement.fromJson(json)).toList();
    } else {
      throw Exception('Fetch ads failed');
    }
  }

  Future<void> createAdvertisement(
    String? token,
    Advertisement advertisement,
    String? imageUrl,
    String? filename,
  ) async {
    final uri = Uri.parse("http://127.0.0.1:8000/api/dashboard/ads");
    final request = http.MultipartRequest('POST', uri);
    request.fields['type'] = advertisement.type;
    request.fields['start_date'] = DateFormat(
      'yyyy-MM-dd',
    ).format(advertisement.startDate);
    request.fields['end_date'] = DateFormat(
      'yyyy-MM-dd',
    ).format(advertisement.endDate);

    if (imageUrl != null) {
      final List<int> imageBytes = base64Decode(imageUrl.split(',').last);
      request.files.add(
        http.MultipartFile.fromBytes('media', imageBytes, filename: filename),
      );
    }

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Advertisement create failed');
    }
  }

  Future<void> editAdvertisement(
    String? token,
    int id,
    Map<String, String> advertisement,
    String? imageUrl,
    String? filename,
  ) async {
    final uri = Uri.parse("http://127.0.0.1:8000/api/dashboard/ads/$id");
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields.addAll(advertisement);
    request.fields['_method'] = 'PUT';

    if (imageUrl != null) {
      final List<int> imageBytes = base64Decode(imageUrl.split(',').last);
      request.files.add(
        http.MultipartFile.fromBytes('media', imageBytes, filename: filename),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();
    // ignore: avoid_print
    print(jsonDecode(body));

    if (response.statusCode != 200) {
      throw Exception('Advertisement update failed');
    }
  }

  Future<void> deleteAdvertisement(String? token, int id) async {
    final response = await apiClient.delete("dashboard/ads/$id", token: token);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Delete Advertisement Failed');
    }
  }
}
