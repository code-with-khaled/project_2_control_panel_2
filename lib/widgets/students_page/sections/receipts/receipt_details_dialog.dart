import 'package:control_panel_2/models/student_receipt_model.dart';
import 'package:control_panel_2/widgets/students_page/sections/receipts/receipt_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptDetailsDialog extends StatefulWidget {
  final StudentReceipt receipt;

  const ReceiptDetailsDialog({super.key, required this.receipt});

  @override
  State<ReceiptDetailsDialog> createState() => _ReceiptDetailsDialogState();
}

class _ReceiptDetailsDialogState extends State<ReceiptDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with close button
                _buildHeader(),
                SizedBox(height: 25),

                _buildReceiptInfo(),

                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),

                _buildFinancialBreakdown(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "تفاصيل الإيصال",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Spacer(),
      IconButton(
        icon: Icon(Icons.close, size: 20),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      ),
    ],
  );

  Widget _buildReceiptInfo() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.receipt_long_outlined),
          SizedBox(width: 5),
          Text(
            "معلومات الإيصال",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Colors.black54,
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "التاريخ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      DateFormat(
                        'MMM dd, yyyy',
                        'ar',
                      ).format(widget.receipt.date),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 18,
                  color: Colors.black54,
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "النوع",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(widget.receipt.type),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 10),

      _switchItem(widget.receipt.type),
    ],
  );

  Widget _switchItem(String item) {
    switch (item) {
      case "دورة":
        return ReceiptItem(
          icon: Icon(Icons.menu_book_outlined),
          title: "عنوان الدورة",
          content: widget.receipt.name,
        );
      case "رحلة":
        return ReceiptItem(
          icon: Icon(Icons.card_travel),
          title: "عنوان الرحلة",
          content: widget.receipt.name,
        );
      case "كتاب":
        return ReceiptItem(
          icon: Icon(Icons.book_outlined),
          title: "عنوان الكتاب",
          content: widget.receipt.name,
        );
      case "مناهج":
        return ReceiptItem(
          icon: Icon(Icons.import_contacts),
          title: "عنوان المنهاج",
          content: widget.receipt.name,
        );
      default:
        return ReceiptItem(
          icon: Icon(Icons.military_tech_outlined),
          title: "عنوان الشهادة",
          content: widget.receipt.name,
        );
    }
  }

  Widget _buildFinancialBreakdown() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.attach_money_outlined),
          SizedBox(width: 5),
          Text(
            "التفاصيل المالية",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 20),

      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Text(
      //       "القيمة الأصلية:",
      //       style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      //     ),
      //     Text(
      //       widget.receipt.amount.toString(),
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //     ),
      //   ],
      // ),
      // SizedBox(height: 10),

      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Text(
      //       "قيمة الحسم:",
      //       style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      //     ),
      //     Text(
      //       "${5000}-",
      //       style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      //     ),
      //   ],
      // ),
      // SizedBox(height: 10),

      // Divider(),
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "القيمة:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              (int.parse(widget.receipt.amount.toString()) - 5000).toString(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    ],
  );
}
