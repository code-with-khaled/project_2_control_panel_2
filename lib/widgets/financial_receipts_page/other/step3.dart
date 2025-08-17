import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:flutter/material.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final TextEditingController _firstNameController = TextEditingController();

  // Validation function
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            "خطوة 3: القيمة المالية",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 25),

          _buildFinancialValueField(),
        ],
      ),
    );
  }

  Widget _buildFinancialValueField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "القيمة المالية (\$)",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل القيمة",
        controller: _firstNameController,
        suffix: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(onTap: () {}, child: Icon(Icons.arrow_drop_up, size: 20)),
            InkWell(onTap: () {}, child: Icon(Icons.arrow_drop_down, size: 20)),
          ],
        ),
        validator: (value) => _validateNotEmpty(value, "القيمة المالية"),
      ),
    ],
  );
}
