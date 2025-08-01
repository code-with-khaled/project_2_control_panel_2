import 'package:control_panel_2/constants/all_curriculums.dart';
import 'package:control_panel_2/constants/all_students.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/curriculums_page/tables/student_marks_table.dart';
import 'package:flutter/material.dart';

class MarksSection extends StatefulWidget {
  const MarksSection({super.key});

  @override
  State<MarksSection> createState() => _MarksSectionState();
}

class _MarksSectionState extends State<MarksSection> {
  final ScrollController _horizontalScroll = ScrollController();

  // State variables
  String? _selectedStudent;

  @override
  void initState() {
    super.initState();
    _selectedStudent = allStudents.first['name'];
  }

  @override
  Widget build(BuildContext context) {
    final student = allStudents.firstWhere(
      (student) => student['name'] == _selectedStudent,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      "أدخل العلامات",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "أدخل المذاكرة، الامتحان النهائي، التسميعات",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: DropdownButtonFormField<String>(
                value: _selectedStudent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'اختر الطالب',
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
                items: allStudents
                    .map<DropdownMenuItem<String>>(
                      (student) => DropdownMenuItem(
                        value: student['name'],
                        child: Text(student['name']),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() => _selectedStudent = newValue);
                },
                // validator: _validateGender,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        if (MediaQuery.of(context).size.width > 600)
          Row(
            children: [
              Expanded(
                child: StudentMarksTable(
                  student: Student(
                    id: "1",
                    firstName: student['name'],
                    lastName: "lastName",
                    username: "username",
                    email: "email",
                    joinDate: "joinDate",
                    subjects: allCurriculums.first.subjects,
                  ),
                ),
              ),
            ],
          )
        else
          Scrollbar(
            controller: _horizontalScroll,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalScroll,
              scrollDirection: Axis.horizontal,
              child: StudentMarksTable(
                student: Student(
                  id: "1",
                  firstName: student['name'],
                  lastName: "lastName",
                  username: "username",
                  email: "email",
                  joinDate: "joinDate",
                  subjects: allCurriculums.first.subjects,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
