import 'package:control_panel_2/constants/all_students.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/sections/book_section.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/sections/certificate_section.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/sections/course_section.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/sections/curriculum_section.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/sections/trip_section.dart';
import 'package:flutter/material.dart';

class AddPaymentDialog extends StatefulWidget {
  const AddPaymentDialog({super.key});

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  // State variables
  String? _selectedStudent;
  String? _selectedType;

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

                _buildStep1(),
                SizedBox(height: 20),

                _buildStep2(),
                SizedBox(height: 20),

                _buildSubmitButton(),
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
        "إنشاء إيصال دفع",
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

  Widget _buildStep1() => Container(
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
          "خطوة 1: المعلومات الأساسية",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 25),

        _buildStudentField(),
        SizedBox(height: 20),

        _buildTypeField(),
      ],
    ),
  );

  Widget _buildStudentField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("اسم الطالب", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedStudent,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر الطالب',
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
        items: allStudents.map((value) {
          return DropdownMenuItem<String>(
            value: value['name'],
            child: Text(value['name']),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedStudent = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );

  Widget _buildTypeField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("نوع الإيصال", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر نوع الإيصال',
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
        items: ['شهادة', 'كورس', 'رحلة', 'كتاب', 'مناهج'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedType = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("إلغاء"),
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {
          // if (_formKey.currentState!.validate()) {
          //   // Form is valid - process data
          // }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("إنشاء الإيصال"),
        ),
      ),
    ],
  );

  Widget _buildStep2() {
    switch (_selectedType) {
      case 'شهادة':
        return CertificateSection();
      case 'كورس':
        return CourseSection();
      case 'رحلة':
        return TripSection();
      case 'كتاب':
        return BookSection();
      case 'مناهج':
        return CurriculumSection();
      default:
        return Text("");
    }
  }
}
