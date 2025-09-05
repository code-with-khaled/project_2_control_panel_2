import 'package:control_panel_2/models/lecture_model.dart';
import 'package:control_panel_2/widgets/courses_page/tables/lecture_attendance_dialog.dart';
import 'package:flutter/material.dart';

class LectureAttendanceDialog extends StatefulWidget {
  final Lecture lecture;

  const LectureAttendanceDialog({super.key, required this.lecture});

  @override
  State<LectureAttendanceDialog> createState() =>
      _LectureAttendanceDialogState();
}

class _LectureAttendanceDialogState extends State<LectureAttendanceDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 25),

                _buildAttendanceTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "تتبع الحضور والغياب",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Spacer(),
      IconButton(
        icon: Icon(Icons.close, size: 20),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      ),
    ],
  );

  Widget _buildAttendanceTable() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text("التاريخ والوقت : "),
          Text("${widget.lecture.date}  -  "),
          Text("من ${_parseTime(widget.lecture.startDate)}"),
          SizedBox(width: 10),
          Text("إلى ${_parseTime(widget.lecture.endDate)}"),
        ],
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Expanded(child: LectureAtendanceTable(lecture: widget.lecture)),
        ],
      ),
    ],
  );

  String _parseTime(DateTime dateTime) {
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";

    return time;
  }
}
