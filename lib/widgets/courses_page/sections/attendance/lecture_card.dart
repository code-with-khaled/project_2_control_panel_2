import 'package:control_panel_2/models/lecture_model.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/lecture_attendance_dialog.dart';
import 'package:flutter/material.dart';

class LectureCard extends StatefulWidget {
  final Lecture lecture;

  const LectureCard({super.key, required this.lecture});

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () => _showLectureAttendanceDialog(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          padding: EdgeInsets.all(20),
          decoration: _buildBoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.lecture.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getStatusBgColor(widget.lecture.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.lecture.status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey.shade700,
                    size: 18,
                  ),
                  SizedBox(width: 5),

                  Text(
                    widget.lecture.date,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "تبدأ:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),

                      Text(_parseTime(widget.lecture.startDate)),
                    ],
                  ),
                  SizedBox(width: 20),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "تنتهي:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),

                      Text(_parseTime(widget.lecture.endDate)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),

              if (widget.lecture.reason != null)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "السبب:",
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.lecture.reason!,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),

              if (widget.lecture.reason == null) SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _parseTime(DateTime dateTime) {
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";

    return time;
  }

  Future _showLectureAttendanceDialog() => showDialog(
    context: context,
    builder: (context) => LectureAttendanceDialog(lecture: widget.lecture),
  );

  Decoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(6),
    boxShadow: isHovered
        ? [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ]
        : [],
  );

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'ملغاة':
        return Colors.red.shade300;
      default:
        return Colors.black;
    }
  }
}
