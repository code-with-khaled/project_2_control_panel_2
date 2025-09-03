import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/widgets/courses_page/sections/attendance_section.dart';
import 'package:control_panel_2/widgets/courses_page/sections/course_feedbacks_section.dart';
import 'package:control_panel_2/widgets/courses_page/sections/exams_section.dart';
import 'package:control_panel_2/widgets/courses_page/sections/students_receipts_section.dart';
import 'package:control_panel_2/widgets/other/nav_button.dart';
import 'package:flutter/material.dart';

class CourseDataDialog extends StatefulWidget {
  final Course course;

  const CourseDataDialog({super.key, required this.course});

  @override
  State<CourseDataDialog> createState() => _CourseDataDialogState();
}

class _CourseDataDialogState extends State<CourseDataDialog> {
  String _activeFilter = 'الحضور'; // Currently selected section

  /// Updates the active section filter
  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight:
              MediaQuery.of(context).size.height * 0.8, // 80% screen height
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with action buttons
                _buildHeader(),
                SizedBox(height: 16),

                // Navigation tabs for different sections
                _buildNavigationTabs(),
                SizedBox(height: 8),

                // Dynamic content section
                _buildCurrentSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds dialog header with title and action buttons
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            "بيانات الكورس - ${widget.course.name}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        IconButton(
          icon: Icon(Icons.close, size: 20),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }

  // Builds navigation tabs for profile sections
  Widget _buildNavigationTabs() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blueGrey[50],
      ),
      child: Row(
        children: [
          // Overview tab
          Expanded(
            child: NavButton(
              navkey: "الحضور",
              isActive: _activeFilter == "الحضور",
              onTap: () => _setFilter("الحضور"),
            ),
          ),

          // Receipts tab
          Expanded(
            child: NavButton(
              navkey: "الاختبارات",
              isActive: _activeFilter == "الاختبارات",
              onTap: () => _setFilter("الاختبارات"),
            ),
          ),

          // Discounts tab
          Expanded(
            child: NavButton(
              navkey: "الإيصالات",
              isActive: _activeFilter == "الإيصالات",
              onTap: () => _setFilter("الإيصالات"),
            ),
          ),

          // Reviews tab
          Expanded(
            child: NavButton(
              navkey: "الاستبيانات والمراجعات",
              isActive: _activeFilter == "الاستبيانات والمراجعات",
              onTap: () => _setFilter("الاستبيانات والمراجعات"),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate content section based on active filter
  Widget _buildCurrentSection() {
    switch (_activeFilter) {
      case "الاختبارات":
        return ExamsSection();
      case "الإيصالات":
        return StudentsReceiptsSection();
      case "الاستبيانات والمراجعات":
        return CourseFeedbacksSection(id: widget.course.id!);
      default:
        return AttendanceSection(course: widget.course);
    }
  }
}
