import 'package:control_panel_2/constants/all_courses.dart';
// import 'package:control_panel_2/widgets/financial_receipts_page/payment_and_return/other/step3.dart';
import 'package:flutter/material.dart';

class CourseSection extends StatefulWidget {
  final bool isReturn;

  const CourseSection({super.key, required this.isReturn});

  @override
  State<CourseSection> createState() => _CourseSectionState();
}

class _CourseSectionState extends State<CourseSection> {
  // State variables
  String? _selectedCourse;

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
                "خطوة 2: تحديد الكورس",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),

              _buildCourseField(),
            ],
          ),
        ),
        SizedBox(height: 20),

        // if (_selectedCourse != null) Step3(isReturn: widget.isReturn),
      ],
    );
  }

  Widget _buildCourseField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الكورس", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedCourse,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر الكورس',
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
        items: courses.map((value) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Text(value.name),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedCourse = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );
}
