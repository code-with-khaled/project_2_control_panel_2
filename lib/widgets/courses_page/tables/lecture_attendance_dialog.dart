import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/attendance_model.dart';
import 'package:control_panel_2/models/lecture_model.dart';
import 'package:flutter/material.dart';

class LectureAtendanceTable extends StatefulWidget {
  final Lecture lecture;

  const LectureAtendanceTable({super.key, required this.lecture});

  @override
  State<LectureAtendanceTable> createState() => _LectureAtendanceTableState();
}

class _LectureAtendanceTableState extends State<LectureAtendanceTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  // Variables for API integration
  late CourseService _courseService;
  bool _isLoading = true;

  List<Attendance> _attendances = [
    Attendance(
      id: 1,
      student: AttendanceStudent(
        id: 1,
        firstName: "firstName",
        middletName: "middletName",
        lastName: "lastName",
      ),
      status: "تأخير مبرر",
      reason: Reason(reason: "حالة مرضية"),
    ),
    Attendance(
      id: 1,
      student: AttendanceStudent(
        id: 1,
        firstName: "firstName",
        middletName: "middletName",
        lastName: "lastName",
      ),
      status: "حاضر",
      notes: "مشاركة متميزة",
    ),
    Attendance(
      id: 1,
      student: AttendanceStudent(
        id: 1,
        firstName: "firstName",
        middletName: "middletName",
        lastName: "lastName",
      ),
      status: "تأخير غير مبرر",
    ),
  ];

  Future<void> _loadAttendances() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await _courseService.fetchAttendances(
        token,
        widget.lecture.id,
      );
      setState(() {
        _attendances += response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    }

    // ignore: avoid_print
    print(_attendances.toString());
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _courseService = CourseService(apiClient: apiClient);

    _loadAttendances();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              padding: EdgeInsets.all(20),
              strokeWidth: 2,
              color: Colors.blue,
            ),
          )
        : _attendances.isEmpty
        ? _buildEmptyState()
        : LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DataTable(
                      columnSpacing: 20,
                      horizontalMargin: 20,
                      columns: [
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 150),
                            child: Text(
                              'اسم الطالب',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: Text(
                              'الحالة',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: Text(
                              'السبب',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: Text(
                              'ملاحظات',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                      rows: _attendances.map((attendance) {
                        return DataRow(
                          cells: [
                            DataCell(Text(attendance.student.fullName)),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusBgColor(attendance.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  attendance.status,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: _getStatusColor(attendance.status),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              attendance.reason != null
                                  ? Text(
                                      attendance.reason!.reason,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    )
                                  : Text("-"),
                            ),
                            DataCell(
                              attendance.notes != null
                                  ? Text(attendance.notes!)
                                  : Text('-'),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'لا يوجد جدول حضور',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'تأخير مبرر':
        return Colors.blue.shade100;
      case 'تأخير غير مبرر':
        return Colors.red.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'تأخير مبرر':
        return Colors.blue.shade900;
      case 'تأخير غير مبرر':
        return Colors.red.shade900;
      default:
        return Colors.green.shade800;
    }
  }
}
