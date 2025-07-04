import 'package:control_panel_2/widgets/other/nav_button.dart';
import 'package:control_panel_2/widgets/teachers_page/sections/courses/teacher_courses_section.dart';
import 'package:control_panel_2/widgets/teachers_page/sections/info/teacher_info_section.dart';
import 'package:control_panel_2/widgets/teachers_page/sections/reviews/teacher_reviews_section.dart';
import 'package:control_panel_2/widgets/teachers_page/sections/stat_panel/teacher_stat_panel_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dialog displaying comprehensive teacher profile information
///
/// Shows [name] and [username] with tabbed sections for different profile aspects
class TeacherProfileDialog extends StatefulWidget {
  final String name;
  final String username;

  const TeacherProfileDialog({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  State<TeacherProfileDialog> createState() => _TeacherProfileDialogState();
}

class _TeacherProfileDialogState extends State<TeacherProfileDialog> {
  String _activeFilter = 'المعلومات الشخصية'; // Currently selected section

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
          maxWidth: 800, // Wider dialog for profile content
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

                // Student profile summary
                _buildProfileSummary(),
                SizedBox(height: 16),

                Divider(height: 1),
                SizedBox(height: 16),

                // Navigation tabs for different sections
                _buildNavigationTabs(),
                SizedBox(height: 10),

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
        // Dialog title
        Text(
          "الملف الشخصي للمدرس",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

  // Builds student profile summary section
  Widget _buildProfileSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile avatar
        CircleAvatar(radius: 40, child: Icon(Icons.person, size: 42)),
        SizedBox(width: 16),

        // Name and username
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.username,
              style: GoogleFonts.roboto(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
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
              navkey: "المعلومات الشخصية",
              isActive: _activeFilter == "المعلومات الشخصية",
              onTap: () => _setFilter("المعلومات الشخصية"),
            ),
          ),

          // Receipts tab
          Expanded(
            child: NavButton(
              navkey: "الكورسات",
              isActive: _activeFilter == "الكورسات",
              onTap: () => _setFilter("الكورسات"),
            ),
          ),

          // Discounts tab
          Expanded(
            child: NavButton(
              navkey: "المراجعات",
              isActive: _activeFilter == "المراجعات",
              onTap: () => _setFilter("المراجعات"),
            ),
          ),

          // Reviews tab
          Expanded(
            child: NavButton(
              navkey: "اللوحة الإحصائية",
              isActive: _activeFilter == "اللوحة الإحصائية",
              onTap: () => _setFilter("اللوحة الإحصائية"),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate content section based on active filter
  Widget _buildCurrentSection() {
    switch (_activeFilter) {
      case "الكورسات":
        return TeacherCoursesSection();
      case "المراجعات":
        return TeacherReviewsSection();
      case "اللوحة الإحصائية":
        return TeacherStatPanelSection();
      default:
        return TeacherInfoSection();
    }
  }
}
