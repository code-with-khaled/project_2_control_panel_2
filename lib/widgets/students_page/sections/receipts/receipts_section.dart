import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_receipt_model.dart';
import 'package:control_panel_2/widgets/students_page/sections/receipts/student_receipt_card.dart';
import 'package:flutter/material.dart';

class ReceiptsSection extends StatefulWidget {
  final int id;

  const ReceiptsSection({super.key, required this.id});

  @override
  State<ReceiptsSection> createState() => _ReceiptsSectionState();
}

class _ReceiptsSectionState extends State<ReceiptsSection> {
  bool _isLoading = false;

  List<StudentReceipt> _receipts = [
    StudentReceipt(
      id: 1,
      firstName: "firstName",
      lastName: "lastName",
      phone: "phone",
      type: "دورة",
      name: "name",
      transactionId: 1,
      amount: 500000.00,
      date: DateTime.now(),
      status: "status",
    ),
  ];

  late StudentService _studentService;

  Future<void> _fetchReceipts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      _receipts += await _studentService.fetchStudentReciepts(token, widget.id);
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

    final apiClient = ApiHelper.getClient();

    _studentService = StudentService(apiClient: apiClient);

    _fetchReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue,
              padding: EdgeInsets.all(20),
            ),
          )
        : _receipts.isEmpty
        ? Center(child: Text("لا يوجد فواتير"))
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
                    StudentReceiptCard(receipt: receipt),
                ],
              ),
            ],
          );
  }
}
