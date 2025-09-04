import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:control_panel_2/models/teacher_disbursement_model.dart';
import 'package:control_panel_2/widgets/teachers_page/sections/disbursements/teacher_receipt_card.dart';
import 'package:flutter/material.dart';

class TeacherDisbursementsSection extends StatefulWidget {
  final int id;

  const TeacherDisbursementsSection({super.key, required this.id});

  @override
  State<TeacherDisbursementsSection> createState() =>
      _TeacherDisbursementsSectionState();
}

class _TeacherDisbursementsSectionState
    extends State<TeacherDisbursementsSection> {
  bool _isLoading = false;

  List<TeacherDisbursement> _receipts = [
    TeacherDisbursement(
      id: 1,
      name: "name",
      amount: 500000,
      date: DateTime.now(),
    ),
  ];

  late TeacherService _teacherService;

  Future<void> _fetchReceipts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      _receipts += await _teacherService.fetchTeacherReciepts(token, widget.id);
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

    _teacherService = TeacherService(apiClient: apiClient);

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
                    "فواتير المدرس",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Wrap(
                runSpacing: 10,
                children: [
                  for (var receipt in _receipts)
                    TeacherReceiptCard(receipt: receipt),
                ],
              ),
            ],
          );
  }
}
