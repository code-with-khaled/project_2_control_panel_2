import 'package:control_panel_2/models/student_receipt_model.dart';
import 'package:control_panel_2/widgets/students_page/sections/receipts/receipt_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptCard extends StatefulWidget {
  final StudentReceipt receipt;

  const ReceiptCard({super.key, required this.receipt});

  @override
  State<ReceiptCard> createState() => _ReceiptCardState();
}

class _ReceiptCardState extends State<ReceiptCard> {
  // State variables
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final receipt = widget.receipt;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => ReceiptDetailsDialog(receipt: receipt),
        ),
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
