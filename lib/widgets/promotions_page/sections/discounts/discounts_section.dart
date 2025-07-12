import 'package:control_panel_2/models/discount_model.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/add_discount_dialog.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/edit_discount_dialog.dart';
import 'package:flutter/material.dart';

/// Displays and manages discount coupons with:
/// - Responsive grid layout
/// - Discount details and statistics
/// - Edit and deactivation functionality
class DiscountsSection extends StatelessWidget {
  const DiscountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context), // Section header with create button
        SizedBox(height: 20),
        _buildDiscounts(context), // Discount cards grid
      ],
    );
  }

  /// Builds section header with title and create button
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "إدارة الحسومات",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddDiscountDialog(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 10),
                Text("إنشاء حسم"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds responsive grid of discount cards
  Widget _buildDiscounts(BuildContext context) {
    return MediaQuery.of(context).size.width >= 885
        ? Wrap(
            // Wide screen layout (3 columns)
            spacing: 25,
            runSpacing: 25,
            children: [
              for (int i = 0; i < 6; i++)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 410),
                  child: _buildDiscount(context),
                ),
            ],
          )
        : Wrap(
            // Narrow screen layout (1 column)
            runSpacing: 25,
            children: [for (int i = 0; i < 6; i++) _buildDiscount(context)],
          );
  }

  /// Builds individual discount card
  Widget _buildDiscount(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDiscountHeader(), // Discount title and status
          SizedBox(height: 10),
          _buildDiscountValueAndUsage(), // Value and usage stats
          SizedBox(height: 10),
          _buildDiscountInfo(), // Additional info (dates, target etc.)
          SizedBox(height: 10),
          _buildFooter(context), // Action buttons
        ],
      ),
    );
  }

  /// Builds discount header with title and active status
  Widget _buildDiscountHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "عرض شتاء 2025",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              "حسم خاص على جميع كورسات البرمجة",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
        Chip(
          label: Text(
            "فعال",
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }

  /// Builds discount value and usage statistics
  Widget _buildDiscountValueAndUsage() {
    return Row(
      children: [
        Expanded(
          // Discount value card
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "75\$",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "القيمة",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          // Usage stats card
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "48/50",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "الاستخدام",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds additional discount information
  Widget _buildDiscountInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Expiry date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey),
                SizedBox(width: 5),
                Text("تاريخ الانتهاء:", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text("2024-01-25"),
          ],
        ),
        SizedBox(height: 5),

        // Revenue generated
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: Colors.grey),
                SizedBox(width: 5),
                Text("الدخل:", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text("3600\$"),
          ],
        ),
        SizedBox(height: 5),

        // Target audience
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.adjust, color: Colors.grey),
                SizedBox(width: 5),
                Text("الفئة المستهدفة:", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text("جميع المستخدمين"),
          ],
        ),
      ],
    );
  }

  /// Builds action buttons (edit and deactivate)
  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildEditButton(context),
        SizedBox(width: 5),
        _buildDeleteButton(),
      ],
    );
  }

  /// Builds edit discount button
  Widget _buildEditButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => EditDiscountDialog(
            discount: Discount(
              title: "عرض شتاء 2025",
              description: "حسم خاص على جميع كورسات البرمجة",
              value: 75,
              quantity: 50,
              date: "2024-01-25",
              allUsers: true,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined),
            SizedBox(width: 3),
            Flexible(child: Text("تعديل")),
          ],
        ),
      ),
    );
  }

  /// Builds deactivate discount button
  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: () {}, // TODO: Implement deactivation functionality
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block, color: Colors.red),
            SizedBox(width: 3),
            Flexible(
              child: Text("إلغاء التفعيل", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
