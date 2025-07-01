import 'package:flutter/material.dart';

class DiscountsSection extends StatelessWidget {
  const DiscountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context), SizedBox(height: 20),
        //  _buildDiscounts(),
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

  // ignore: unused_element
  Widget _buildDiscounts() {
    return Wrap(spacing: 20, runSpacing: 20, children: [
      ],
    );
  }

  // Builds Actions (edit / delete)
  // ignore: unused_element
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
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 3),
            Flexible(
              child: Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
