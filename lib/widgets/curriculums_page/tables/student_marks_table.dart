import 'package:control_panel_2/models/curriculum_model.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/curriculums_page/sections/marks_section/mark_input_field.dart';
import 'package:flutter/material.dart';

class StudentMarksTable extends StatefulWidget {
  final Student student;
  final Curriculum curriculum;

  const StudentMarksTable({
    super.key,
    required this.student,
    required this.curriculum,
  });

  @override
  State<StudentMarksTable> createState() => _StudentMarksTableState();
}

class _StudentMarksTableState extends State<StudentMarksTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DataTable(
        // ignore: deprecated_member_use
        dataRowHeight: 60,
        columnSpacing: 20.0,
        columns: [
          DataColumn(
            label: Text(
              'اسم الطالب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'المادة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '(مذاكرة/100)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '(امتحان/100)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '(تسميع أول/100)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '(تسميع ثاني/100)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
        rows: widget.curriculum.subjects.map((subject) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  widget.student.firstName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(
                Chip(
                  label: Text(subject, style: TextStyle(color: Colors.black)),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  backgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                ),
              ),
              DataCell(MarkInputField()),
              DataCell(MarkInputField()),
              DataCell(MarkInputField()),
              DataCell(MarkInputField()),
            ],
          );
        }).toList(),
      ),
    );
  }
}
