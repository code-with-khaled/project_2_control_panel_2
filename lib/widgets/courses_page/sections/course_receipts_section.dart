import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/course_receipt_mode.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentsReceiptsSection extends StatefulWidget {
  final int id;

  const StudentsReceiptsSection({super.key, required this.id});

  @override
  State<StudentsReceiptsSection> createState() =>
      _StudentsReceiptsSectionState();
}

class _StudentsReceiptsSectionState extends State<StudentsReceiptsSection> {
  bool _isLoading = false;

  List<CourseReceipt> _receipts = [
    CourseReceipt(
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

  late CourseService _studentService;

  Future<void> _fetchReceipts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      _receipts += await _studentService.fetchCourseReciepts(token, widget.id);
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

    _studentService = CourseService(apiClient: apiClient);

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
                    CourseReceiptCard(receipt: receipt),
                ],
              ),
            ],
          );
  }
}

class CourseReceiptCard extends StatefulWidget {
  final CourseReceipt receipt;

  const CourseReceiptCard({super.key, required this.receipt});

  @override
  State<CourseReceiptCard> createState() => _CourseReceiptCardState();
}

class _CourseReceiptCardState extends State<CourseReceiptCard> {
  // State variables
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final receipt = widget.receipt;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        // onTap: () => showDialog(
        //   context: context,
        //   builder: (context) => ReceiptDetailsDialog(receipt: receipt),
        // ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    receipt.id.toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getTypeColor(receipt.type),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      receipt.type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "التاريخ:",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Text(DateFormat('yyyy-MM-dd').format(receipt.date)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "القيمة:",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Text(
                    receipt.amount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String status) {
    switch (status) {
      case "دفع":
        return Colors.green.shade900;
      default:
        return Colors.yellow.shade900;
    }
  }
}
