import 'package:control_panel_2/constants/all_accounts.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/disbursement/other/setp3.dart';
import 'package:flutter/material.dart';

class EmployeeSection extends StatefulWidget {
  const EmployeeSection({super.key});

  @override
  State<EmployeeSection> createState() => _EmployeeSectionState();
}

class _EmployeeSectionState extends State<EmployeeSection> {
  // State variables
  String? _selectedEmployee;

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

              _buildEmployeeField(),
            ],
          ),
        ),
        SizedBox(height: 20),

        if (_selectedEmployee != null) DisbursementSetp3(),
      ],
    );
  }

  Widget _buildEmployeeField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الموظف", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedEmployee,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر الموطف',
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
        items: allAccounts.map((value) {
          return DropdownMenuItem<String>(
            value: value.fullName,
            child: Text(value.fullName),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedEmployee = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );
}
