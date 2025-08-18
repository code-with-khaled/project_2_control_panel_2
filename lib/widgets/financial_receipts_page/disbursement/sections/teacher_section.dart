import 'package:control_panel_2/constants/all_teachers.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/disbursement/other/setp3.dart';
import 'package:flutter/material.dart';

class TeacherSection extends StatefulWidget {
  const TeacherSection({super.key});

  @override
  State<TeacherSection> createState() => _TeacherSectionState();
}

class _TeacherSectionState extends State<TeacherSection> {
  // State variables
  String? _selectedTeacher;

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
                "خطوة 2: التفاصيل",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),

              _buildTeacherField(),
            ],
          ),
        ),
        SizedBox(height: 20),

        if (_selectedTeacher != null) DisbursementSetp3(),
      ],
    );
  }

  Widget _buildTeacherField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المدرس", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedTeacher,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر المدرس',
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
        items: allTeachers.map((value) {
          return DropdownMenuItem<String>(
            value: value.fullName,
            child: Text(value.fullName),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedTeacher = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );
}
