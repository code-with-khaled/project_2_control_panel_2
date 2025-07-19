import 'package:control_panel_2/widgets/courses_page/tables/students_receipts_table.dart';
import 'package:flutter/material.dart';

class StudentsReceiptsSection extends StatefulWidget {
  const StudentsReceiptsSection({super.key});

  @override
  State<StudentsReceiptsSection> createState() =>
      _StudentsReceiptsSectionState();
}

class _StudentsReceiptsSectionState extends State<StudentsReceiptsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 25),
          StudentsReceiptsTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.receipt_long_outlined),
        SizedBox(width: 10),
        Text(
          "إيصالات السحب والدفع",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
