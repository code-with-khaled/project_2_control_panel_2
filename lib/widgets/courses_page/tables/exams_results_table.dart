import 'dart:math';

import 'package:control_panel_2/constants/all_students.dart';
import 'package:flutter/material.dart';

class ExamsResultsTable extends StatefulWidget {
  const ExamsResultsTable({super.key});

  @override
  State<ExamsResultsTable> createState() => _ExamsResultsTableState();
}

class _ExamsResultsTableState extends State<ExamsResultsTable> {
  late CourseDataSource _dataSource;
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _dataSource = CourseDataSource(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: PaginatedDataTable(
        rowsPerPage: _rowsPerPage,
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
        columns: [
          DataColumn(
            label: Text(
              'اسم الطالب',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataColumn(
            label: Text(
              'الامتحان النصفي',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataColumn(
            label: Text(
              'الامتحان النهائي',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataColumn(
            label: Text(
              "المجموع",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataColumn(label: Icon(Icons.arrow_upward)),
        ],
        source: _dataSource,
      ),
    );
  }
}

/// **Custom DataSource for Pagination**
class CourseDataSource extends DataTableSource {
  final BuildContext context;
  CourseDataSource(this.context);

  final List<Map<String, dynamic>> _courses = List.generate(
    allStudents.length,
    (index) {
      int midterm = Random().nextInt(100);
      int finalExam = Random().nextInt(100);
      int total = midterm + finalExam;
      int ranking = index + 1;

      return {
        'name': allStudents.elementAt(index)['name'],
        'midterm': midterm.toString(),
        'final': finalExam.toString(),
        'total': total.toString(),
        'ranking': ranking.toString(),
      };
    },
  );

  @override
  DataRow? getRow(int index) {
    if (index >= _courses.length) return null;
    final course = _courses[index];

    return DataRow(
      color: WidgetStateColor.resolveWith((states) {
        return Colors.white;
      }),
      cells: [
        DataCell(Text(course['name'])),
        DataCell(Text(course['midterm'])),
        DataCell(Text(course['final'])),
        DataCell(Text(course['total'])),
        DataCell(
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(course['ranking']),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _courses.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
