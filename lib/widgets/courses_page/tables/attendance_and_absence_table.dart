import 'dart:math';

import 'package:control_panel_2/constants/all_students.dart';
import 'package:flutter/material.dart';

class AttendanceAndAbsenceTable extends StatefulWidget {
  const AttendanceAndAbsenceTable({super.key});

  @override
  State<AttendanceAndAbsenceTable> createState() =>
      _AttendanceAndAbsenceTableState();
}

class _AttendanceAndAbsenceTableState extends State<AttendanceAndAbsenceTable> {
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;

  int _currentPage = 1;
  final int _itemsPerPage = 3;

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        // Reset scroll position when changing pages
        _scrollController1.jumpTo(0);
        _scrollController2.jumpTo(0);
      });
    }
  }

  void _goToNextPage() {
    final totalPages = (allStudents.length / _itemsPerPage).ceil();
    if (_currentPage < totalPages) {
      setState(() {
        _currentPage++;
        // Reset scroll position when changing pages
        _scrollController1.jumpTo(0);
        _scrollController2.jumpTo(0);
      });
    }
  }

  int get _totalPages {
    return (allStudents.length / _itemsPerPage).ceil();
  }

  @override
  void initState() {
    super.initState();
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
    _scrollController1.addListener(() {
      _scrollController2.jumpTo(_scrollController1.offset);
    });
    _scrollController2.addListener(() {
      _scrollController1.jumpTo(_scrollController2.offset);
    });
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Date and Time
                  SizedBox(
                    width: 300,
                    height: 248,
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior().copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        controller: _scrollController1,
                        child: AttendanceDateTable(),
                      ),
                    ),
                  ),
                  // Attendance
                  SizedBox(
                    height: 248,
                    child: Scrollbar(
                      controller: _scrollController2,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(left: 10),
                        controller: _scrollController2,
                        scrollDirection: Axis.vertical,
                        child: AttendanceTable(page: _currentPage),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _currentPage > 1 ? _goToPreviousPage() : null,
                icon: Icon(Icons.chevron_left),
              ),
              Text("$_currentPage - $_totalPages"),
              IconButton(
                onPressed: () => _currentPage < 3 ? _goToNextPage() : null,
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AttendanceDateTable extends StatefulWidget {
  const AttendanceDateTable({super.key});

  @override
  AttendanceDateTableState createState() => AttendanceDateTableState();
}

class AttendanceDateTableState extends State<AttendanceDateTable> {
  late List<Map<String, dynamic>> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.generate(
      20,
      (index) => {'date': '5/24/2025', 'time': '09:00 AM'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.black26),
      columns: [
        DataColumn(
          label: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        DataColumn(
          label: Text('الوقت', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
      rows: _courses
          .map(
            (course) => DataRow(
              cells: [
                DataCell(Text(course['date'])),
                DataCell(Text(course['time'])),
              ],
            ),
          )
          .toList(),
    );
  }
}

class AttendanceTable extends StatefulWidget {
  final int page;

  const AttendanceTable({super.key, required this.page});

  @override
  State<AttendanceTable> createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  late List<String> names;

  List<String> getStudentsNames<String>(List<String> list, int pageNumber) {
    int startIndex = (pageNumber - 1) * 3;
    int endIndex = startIndex + 3;

    return list.sublist(startIndex, endIndex);
  }

  void _updateNames() {
    final startIndex = (widget.page - 1) * 3;
    final endIndex = min(startIndex + 3, allStudents.length);
    names = allStudents
        .sublist(startIndex, endIndex)
        .map((student) => student['name'].toString())
        .toList();

    // Ensure we always have 3 names (pad with empty strings if needed)
    while (names.length < 3) {
      names.add("");
    }
  }

  @override
  void didUpdateWidget(covariant AttendanceTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page != widget.page) {
      _updateNames();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateNames();
  }

  @override
  Widget build(BuildContext context) {
    List<String> states = ["حاضر", "غائب", "منسحب", "غير مسجل"];
    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.black26),
      columns: [
        if (names.isNotEmpty)
          DataColumn(
            label: Text(
              names[0],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        if (names.length > 1)
          DataColumn(
            label: Text(
              names[1],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        if (names.length > 2)
          DataColumn(
            label: Text(
              names[2],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
      ],
      rows: List.generate(
        20,
        (index) => DataRow(
          cells: [
            DataCell(
              AttendanceTracker(state: states[Random().nextInt(states.length)]),
            ),
            DataCell(
              names[1] != ""
                  ? AttendanceTracker(
                      state: states[Random().nextInt(states.length)],
                    )
                  : Text(""),
            ),
            DataCell(
              names[2] != ""
                  ? AttendanceTracker(
                      state: states[Random().nextInt(states.length)],
                    )
                  : Text(""),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceTracker extends StatelessWidget {
  const AttendanceTracker({super.key, required this.state});

  final String state;

  Color circleColor(String state) {
    if (state == "حاضر") {
      return Colors.green;
    } else if (state == "غائب") {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        state != "غير مسجل"
            ? Icon(Icons.circle, size: 14, color: circleColor(state))
            : Icon(Icons.circle_outlined, size: 14),
        SizedBox(width: 6),
        Text(state),
      ],
    );
  }
}
