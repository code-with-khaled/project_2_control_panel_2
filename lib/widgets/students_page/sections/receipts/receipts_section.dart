import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_receipt_model.dart';
import 'package:control_panel_2/widgets/students_page/sections/receipts/receipt_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReceiptsSection extends StatefulWidget {
  final int id;

  const ReceiptsSection({super.key, required this.id});

  @override
  State<ReceiptsSection> createState() => _ReceiptsSectionState();
}

class _ReceiptsSectionState extends State<ReceiptsSection> {
  bool _isLoading = false;

  List<StudentReceipt> _receipts = [];

  late StudentService _studentService;

  Future<void> _fetchReceipts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      _receipts = await _studentService.fetchStudentReciepts(token, widget.id);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _studentService = StudentService(apiClient: apiClient);

    _fetchReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt),
                  SizedBox(width: 6),
                  Text(
                    "فواتير الطلاب",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Wrap(
                runSpacing: 10,
                children: [
                  for (var receipt in _receipts.where(
                    (receipt) => receipt.type != "صرف",
                  ))
                    ReceiptCard(receipt: receipt),
                ],
              ),
            ],
          );
  }
}
