import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:web/web.dart' as web;

class ApiClient {
  final String baseUrl;
  final http.Client httpClient;

  ApiClient({required this.baseUrl, required this.httpClient});

  // String? _getCsrfToken() {
  //   final meta = web.document.querySelector('meta[name="csrf-token"]');
  //   return meta?.getAttribute('content');
  // }

  // Map<String, String> _getHeaders() {
  //   return {
  //     'Content-Type': 'application/json',
  //     'X-CSRF-Token': _getCsrfToken() ?? '',
  //   };
  // }

  Future<http.Response> get(
    String? endpoint, {
    Map<String, dynamic>? params,
    String? token,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/$endpoint',
    ).replace(queryParameters: params);
    return await httpClient.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> post(
    String? endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    return await httpClient.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    return await httpClient.put(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    return await httpClient.delete(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }
}
