import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvancedAnalysis extends StatefulWidget {
  const AdvancedAnalysis({super.key});

  @override
  State<AdvancedAnalysis> createState() => _AdvancedAnalysisState();
}

class _AdvancedAnalysisState extends State<AdvancedAnalysis> {
  // Controllers for managing text input fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // State variables
  DateTime? _selectedDate;

  // Users checkboxes
  bool _previousDiscounts = false;
  bool _brokeLeaderboards = false;

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey[300]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitleField(),
        SizedBox(height: 25),
        _buildCompletionDate(),
        SizedBox(height: 25),

        Row(
          children: [
            Checkbox(
              value: _previousDiscounts,
              checkColor: Colors.white,
              activeColor: Colors.black,
              onChanged: (bool? value) {
                setState(() {
                  _previousDiscounts = value ?? false;
                });
              },
            ),
            Text("الطلاب الذين لم يستفيدوا من حسومات سابقة"),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _brokeLeaderboards,
              checkColor: Colors.white,
              activeColor: Colors.black,
              onChanged: (bool? value) {
                setState(() {
                  _brokeLeaderboards = value ?? false;
                });
              },
            ),
            Text("الطلاب الذين حطموا لوائح الصدارة"),
          ],
        ),
      ],
    );
  }

  /// Builds the title input field
  Widget _buildTitleField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "الحد الأدنى لقيمة الشراء *",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "المستخدمين الذين اشتروا كورسات بهذه القيمة أو أكثر",
        controller: _titleController,
        // validator: (value) => _validateNotEmpty(value, "اسم الأب"),
      ),
    ],
  );

  Widget _buildCompletionDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "تاريخ انهاء الكورسات *",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 2),
      TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          hintText: 'التاريخ الذي أنهى الطالب كورساته قبله',
          suffixIcon: Icon(Icons.calendar_today),
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
        readOnly: true,
        onTap: () => _selectDate(context),
        // validator: _validateDate,
      ),
    ],
  );
}
