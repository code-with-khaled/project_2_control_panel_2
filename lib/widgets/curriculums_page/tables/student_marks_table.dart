import 'package:control_panel_2/models/student_model.dart';
import 'package:flutter/material.dart';

class StudentMarksTable extends StatefulWidget {
  final Student student;

  const StudentMarksTable({super.key, required this.student});

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
        columnSpacing: 20.0,
        columns: [
          DataColumn(
            label: Text(
              'اسم الطالب',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'المادة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'المذاكرة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'الامتحان',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'تسميع أول',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'تسميع ثاني',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: widget.student.subjects.map((subject) {
          return DataRow(
            cells: [
              DataCell(Text(widget.student.firstName)),
              DataCell(Text(subject)),
              DataCell(Text("")),
              DataCell(Text("")),
              DataCell(Text("")),
              DataCell(Text("")),
            ],
          );
        }).toList(),
      ),
    );
  }
}
