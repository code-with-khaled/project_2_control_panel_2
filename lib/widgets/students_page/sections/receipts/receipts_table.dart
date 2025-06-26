import 'dart:math';
import 'package:flutter/material.dart';

class ReceiptsTable extends StatelessWidget {
  final List<Map<String, dynamic>> _receipts = List.generate(5, (index) {
    int receiptCode = Random().nextInt(1000) + 1000;
    int date = Random().nextInt(29) + 1;
    int month = Random().nextInt(12) + 1;
    int amount = Random().nextInt(200) + 50;
    String type = Random().nextBool() ? 'دفع' : 'سحب'; // Translated to Arabic

    return {
      'receipt': 'RW$receiptCode',
      'date': '$date/${month.toString().padLeft(2, '0')}/2025',
      'type': type,
      'amount': '$amount  ل.س', // Changed to Syrian Pound symbol
    };
  });

  ReceiptsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.symmetric(
        inside: BorderSide(color: Colors.grey[300]!),
      ),
      columnWidths: const {
        0: FixedColumnWidth(120),
        1: FixedColumnWidth(100),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(80),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Header Row
        TableRow(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                'الإيصال', // 'Receipt'
                style: TextStyle(fontWeight: FontWeight.w600),
                textDirection: TextDirection.rtl,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                'التاريخ', // 'Date'
                style: TextStyle(fontWeight: FontWeight.w600),
                textDirection: TextDirection.rtl,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                'النوع', // 'Type'
                style: TextStyle(fontWeight: FontWeight.w600),
                textDirection: TextDirection.rtl,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                'المبلغ', // 'Amount'
                style: TextStyle(fontWeight: FontWeight.w600),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        // Data Rows
        ..._receipts.map(
          (receipt) => TableRow(
            decoration: BoxDecoration(color: Colors.white),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(receipt['receipt']),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(receipt['date']),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(receipt['type']),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  receipt['amount'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
