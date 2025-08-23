import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/advertisement_model.dart';

import 'package:http/http.dart' as http;

class AdvertisementsService {
  final ApiClient apiClient;

  AdvertisementsService({required this.apiClient});

  Future<void> createAdvertisement(
    String? token,
    Advertisement advertisement,
    String? imageUrl,
    String? filename,
  ) async {
    final uri = Uri.parse("http://127.0.0.1:8000/api/dashboard/ads");
    final request = http.MultipartRequest('POST', uri);
    request.fields['type'] = advertisement.type;
    request.fields['start_date'] = advertisement.startDate;
    request.fields['end_date'] = advertisement.endDate;

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
    final responseJson = await http.Response.fromStream(response);
    // ignore: avoid_print
    print(responseJson.body);

    if (response.statusCode != 200) {
      throw Exception('Advertisement create failed');
    }
  }
}
