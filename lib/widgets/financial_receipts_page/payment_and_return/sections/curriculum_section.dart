import 'package:control_panel_2/constants/all_curriculums.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/payment_and_return/other/step3.dart';
import 'package:flutter/material.dart';

class CurriculumSection extends StatefulWidget {
  final bool isReturn;

  const CurriculumSection({super.key, required this.isReturn});

  @override
  State<CurriculumSection> createState() => _CurriculumSectionState();
}

class _CurriculumSectionState extends State<CurriculumSection> {
  // State variables
  String? _selectedCurriculum;

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
                "خطوة 2: تحديد المنهاج",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),

              _buildCurriculumField(),
            ],
          ),
        ),
        SizedBox(height: 20),

        if (_selectedCurriculum != null) Step3(isReturn: widget.isReturn),
      ],
    );
  }

  Widget _buildCurriculumField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المنهاج", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedCurriculum,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر المنهاج',
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
        items: allCurriculums.map((value) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Text(value.name),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedCurriculum = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );
}
