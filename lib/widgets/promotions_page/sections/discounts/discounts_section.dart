import 'package:flutter/material.dart';

class DiscountsSection extends StatelessWidget {
  const DiscountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        SizedBox(height: 20),

        _buildDiscounts(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "إدارة الحسومات",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {},
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

  Widget _buildDiscounts(BuildContext context) {
    return MediaQuery.of(context).size.width >= 885
        ? Wrap(
            spacing: 25,
            runSpacing: 25,
            children: [
              for (int i = 0; i < 6; i++)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 410),
                  child: _buildDiscount(),
                ),
            ],
          )
        : Wrap(
            runSpacing: 25,
            children: [for (int i = 0; i < 6; i++) _buildDiscount()],
          );
  }

  Widget _buildDiscount() {
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
          _buildDiscountHeader(),
          SizedBox(height: 10),

          _buildDiscountValueAndUsage(),
          SizedBox(height: 10),

          _buildDiscountInfo(),
          SizedBox(height: 10),

          _buildFotter(),
        ],
      ),
    );
  }

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

  Widget _buildDiscountValueAndUsage() {
    return Row(
      children: [
        Expanded(
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

  Widget _buildDiscountInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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

  // Builds Actions (edit / delete)
  Widget _buildFotter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_buildEditButton(), SizedBox(width: 5), _buildDeleteButton()],
    );
  }

  // Builds edit ad button
  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {},
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

  // Builds delete ad button
  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: () {},
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
