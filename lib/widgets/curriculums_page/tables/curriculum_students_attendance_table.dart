import 'package:control_panel_2/constants/all_students.dart';
import 'package:flutter/material.dart';

class CurriculumStudentsAttendanceTable extends StatefulWidget {
  const CurriculumStudentsAttendanceTable({super.key});

  @override
  CurriculumStudentsAttendanceTableState createState() =>
      CurriculumStudentsAttendanceTableState();
}

class CurriculumStudentsAttendanceTableState
    extends State<CurriculumStudentsAttendanceTable> {
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
      width: 800,
      child: PaginatedDataTable(
        rowsPerPage: _rowsPerPage,
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columns: [
          DataColumn(
            label: Text(
              'اسم الطالب',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataColumn(
            label: Text(
              'الحالة الحالية',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataColumn(
            label: Text(
              'أخذ الحضور',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
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

  @override
  DataRow? getRow(int index) {
    final student = allStudents[index];

    return DataRow(
      color: WidgetStateColor.resolveWith((states) {
        return Colors.white;
      }),
      cells: [
        DataCell(Text(student['name'])),
        DataCell(Text(student['status'])),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.check),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black26),
                  ),
                ),
              ),
              SizedBox(width: 5),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.access_time),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black26),
                  ),
                ),
              ),
              SizedBox(width: 5),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.close),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black26),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => allStudents.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
