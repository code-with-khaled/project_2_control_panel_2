import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/course_data_dialog.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/course_details_dialog.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/course_enrollments_dialog.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/edit_course_dialog.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isHovered = false; // Tracks hover state for visual feedback

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => CourseDetailsDialog(course: widget.course),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
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
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.course.name,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) =>
                              EditCourseDialog(course: widget.course),
                        ),
                        icon: Icon(Icons.edit_document),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.file_upload_outlined),
                      ),
                      IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) =>
                              CourseEnrollmentsDialog(course: widget.course),
                        ),
                        icon: Icon(Icons.group_add_outlined),
                      ),
                      IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) =>
                              CourseDataDialog(course: widget.course),
                        ),
                        icon: Icon(Icons.insert_chart_outlined_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  widget.course.category,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school_outlined, color: Colors.grey),
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[200],
                        ),
                        child: Text(
                          widget.course.id!,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_outline, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        "أ. ${widget.course.teacher}",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.group_outlined, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        "${widget.course.enrollments} ملتحقون",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
