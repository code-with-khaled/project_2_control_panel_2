import 'package:control_panel_2/widgets/curriculums_page/tables/curriculum_teachers_attendance_table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeachersAttendanceSection extends StatefulWidget {
  const TeachersAttendanceSection({super.key});

  @override
  State<TeachersAttendanceSection> createState() =>
      _TeachersAttendanceSectionState();
}

class _TeachersAttendanceSectionState extends State<TeachersAttendanceSection> {
  // Controllers for managing text input fields
  final TextEditingController _dateController = TextEditingController();

  // State variables
  DateTime? _selectedDate = DateTime.now();

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_outlined),
            SizedBox(width: 10),
            Text(
              "حضور المدرسين",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("التاريخ", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 2),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: 'mm/dd/yyyy',
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
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
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "أخذ الحضور"
                "  -  "
                "${DateFormat('MM/dd/yyyy').format(_selectedDate!)}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: CurriculumTeachersAttendanceTable()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
