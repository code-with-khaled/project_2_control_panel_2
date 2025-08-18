import 'package:control_panel_2/widgets/financial_receipts_page/disbursement/sections/employee_section.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/disbursement/sections/teacher_section.dart';
import 'package:flutter/material.dart';

class AddDisbursementDialog extends StatefulWidget {
  const AddDisbursementDialog({super.key});

  @override
  State<AddDisbursementDialog> createState() => _AddDisbursementDialogState();
}

class _AddDisbursementDialogState extends State<AddDisbursementDialog> {
  // State variables
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
        "إنشاء أمر صرف",
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
          "خطوة 1: نوع أمر الصرف",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 25),

        _buildTypeField(),
      ],
    ),
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
        items: ['راتب موظف', 'راتب مدرس', 'عملية تحويل', 'عملية شراء'].map((
          String value,
        ) {
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
      case 'راتب موظف':
        return EmployeeSection();
      case 'راتب مدرس':
        return TeacherSection();
      case 'عملية تحويل':
      // return TranseferSection();
      case 'عملية شراء':
      // return PurchaseSection();
      default:
        return Text("");
    }
  }
}
