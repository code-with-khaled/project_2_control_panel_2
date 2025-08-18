import 'package:control_panel_2/widgets/financial_receipts_page/payment_and_return/other/step3.dart';
import 'package:flutter/material.dart';

class BookSection extends StatefulWidget {
  final bool isReturn;

  const BookSection({super.key, required this.isReturn});

  @override
  State<BookSection> createState() => _BookSectionState();
}

class _BookSectionState extends State<BookSection> {
  // State variables
  String? _selectedBook;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "خطوة 2: تحديد الكتاب",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),

              _buildBookField(),
            ],
          ),
        ),
        SizedBox(height: 20),

        if (_selectedBook != null) Step3(isReturn: widget.isReturn),
      ],
    );
  }

  Widget _buildBookField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الكتاب", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedBook,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر الكتاب',
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        items: [''].map((value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedBook = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );
}
