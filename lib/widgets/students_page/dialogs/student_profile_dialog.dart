import 'package:control_panel_2/widgets/students_page/dialogs/enrollment/enroll_student_dialog.dart';
import 'package:control_panel_2/widgets/students_page/dialogs/send_notification_dialog.dart';
import 'package:control_panel_2/widgets/students_page/nav_button.dart';
import 'package:control_panel_2/widgets/students_page/sections/discounts/discounts_section.dart';
import 'package:control_panel_2/widgets/students_page/sections/overview/overview_section.dart';
import 'package:control_panel_2/widgets/students_page/sections/receipts/receipts_section.dart';
import 'package:control_panel_2/widgets/students_page/sections/reviews/reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dialog displaying comprehensive student profile information
///
/// Shows [name] and [username] with tabbed sections for different profile aspects
class StudentProfileDialog extends StatefulWidget {
  final String name;
  final String username;

  const StudentProfileDialog({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  State<StudentProfileDialog> createState() => _StudentProfileDialogState();
}

class _StudentProfileDialogState extends State<StudentProfileDialog> {
  String _activeFilter = 'نظرة عامة'; // Currently selected section

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
          maxWidth: 1000, // Wider dialog for profile content
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
                SizedBox(height: 24),

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
          "الملف الشخصي للطالب",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        // Action buttons container
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wrapped buttons for responsive layout
              Flexible(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  runAlignment: WrapAlignment.end,
                  children: [
                    // Notification button
                    _buildNotificationButton(),

                    // Enroll button
                    _buildEnrollButton(),
                  ],
                ),
              ),
              SizedBox(width: 10),

              // Close button
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Builds notification action button
  Widget _buildNotificationButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SendNotificationDialog(),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_outlined),
            SizedBox(width: 10),
            Flexible(
              child: Text("إرسال إشعار", overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  // Builds enroll action button
  Widget _buildEnrollButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) =>
              EnrollStudentDialog(name: widget.name, username: widget.username),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_add_alt),
            SizedBox(width: 10),
            Flexible(
              child: Text("تسجيل في دورة", overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
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
              navkey: "نظرة عامة",
              isActive: _activeFilter == "نظرة عامة",
              onTap: () => _setFilter("نظرة عامة"),
            ),
          ),

          // Receipts tab
          Expanded(
            child: NavButton(
              navkey: "الفواتير",
              isActive: _activeFilter == "الفواتير",
              onTap: () => _setFilter("الفواتير"),
            ),
          ),

          // Discounts tab
          Expanded(
            child: NavButton(
              navkey: "الخصومات",
              isActive: _activeFilter == "الخصومات",
              onTap: () => _setFilter("الخصومات"),
            ),
          ),

          // Reviews tab
          Expanded(
            child: NavButton(
              navkey: "التقييمات",
              isActive: _activeFilter == "التقييمات",
              onTap: () => _setFilter("التقييمات"),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate content section based on active filter
  Widget _buildCurrentSection() {
    switch (_activeFilter) {
      case "الفواتير":
        return ReceiptsSection();
      case "الخصومات":
        return DiscountsSection();
      case "التقييمات":
        return ReviewsSection();
      default:
        return OverviewSection(name: widget.name, username: widget.username);
    }
  }
}
