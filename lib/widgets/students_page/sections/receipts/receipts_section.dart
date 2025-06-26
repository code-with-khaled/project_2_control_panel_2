import 'package:control_panel_2/widgets/students_page/sections/receipts/receipts_table.dart';
import 'package:flutter/material.dart';

class ReceiptsSection extends StatelessWidget {
  const ReceiptsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Row(children: [Expanded(child: ReceiptsTable())]),
      ],
    );
  }
}
