import 'dart:convert';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/models/order_model.dart';
import 'package:control_panel_2/models/receipt_model.dart';

class ReceiptService {
  final ApiClient apiClient;

  ReceiptService({required this.apiClient});

  Future<List<Receipt>> fetchReceipts(String? token) async {
    final response = await apiClient.get(
      'dashboard/finance/receipts',
      token: token,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> receipts = body['data']['receipts'];

      return receipts.map((json) => Receipt.fromJson(json)).toList();
    } else {
      throw Exception('Fetch receipts failed');
    }
  }

  Future<List<Order>> fetchOrders(String? token) async {
    final response = await apiClient.get(
      'dashboard/finance/receipts',
      token: token,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> receipts = body['data']['expenditure_orders'];

      return receipts.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Fetch receipts failed');
    }
  }

  Future<void> createReceipt(
    String? token,
    Map<String, dynamic> receipt,
  ) async {
    final response = await apiClient.post(
      'dashboard/receipts',
      token: token,
      body: receipt,
    );

    if (response.statusCode != 200) {
      throw Exception('Create receipt failed');
    }
  }

  Future<void> createDisbursement(
    String? token,
    Map<String, dynamic> disbursement,
  ) async {
    final response = await apiClient.post(
      'dashboard/expenditure_orders',
      token: token,
      body: disbursement,
    );

    if (response.statusCode != 200) {
      throw Exception('Create disbursement failed');
    }
  }

  Future<void> deleteReceipt(String? token, int id) async {
    final response = await apiClient.delete(
      'dashboard/receipts/$id',
      token: token,
    );

    if (response.statusCode != 200) {
      throw Exception('Delete receipt failed');
    }
  }
}
