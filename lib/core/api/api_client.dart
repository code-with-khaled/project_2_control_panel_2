import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

class ApiClient {
  final String baseUrl;
  final http.Client httpClient;

  ApiClient({required this.baseUrl, required this.httpClient});

  String? _getCsrfToken() {
    final meta = web.document.querySelector('meta[name="csrf-token"]');
    return meta?.getAttribute('content');
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-CSRF-Token': _getCsrfToken() ?? '',
    };
  }

  Future<http.Response> get(
    String? endpoint, {
    Map<String, dynamic>? params,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/$endpoint',
    ).replace(queryParameters: params);
    return await httpClient.get(uri, headers: _getHeaders());
  }

  Future<http.Response> post(
    String? endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    return await httpClient.post(
      uri,
      headers: _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
  }
}
