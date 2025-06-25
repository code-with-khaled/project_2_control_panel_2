import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:control_panel_2/widgets/students_page/dialogs/enrollment/enroll_in_course_table.dart';
import 'package:flutter/material.dart';

/// Dialog for enrolling a student in available courses
///
/// Requires [name] and [username] of the student to be enrolled
class EnrollStudentDialog extends StatefulWidget {
  final String name;
  final String username;

  const EnrollStudentDialog({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  State<EnrollStudentDialog> createState() => _EnrollStudentDialogState();
}

class _EnrollStudentDialogState extends State<EnrollStudentDialog> {
  // Controller for course search functionality
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose(); // Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800, // Dialog max width
          maxHeight:
              MediaQuery.of(context).size.height * 0.8, // 80% of screen height
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog header with close button
                _buildDialogHeader(),

                // Student name display
                _buildStudentInfoRow(),
                SizedBox(height: 10),

                // Course search field
                SearchField(
                  controller: _searchController,
                  hintText: "Search courses by name, category, or teacher...",
                ),
                SizedBox(height: 16),

                // Courses table with enrollment capability
                CoursesTable(onEnroll: () => _showEnrollmentSuccessToast()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds dialog header with title and close button
  Widget _buildDialogHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enroll Student in Course",
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
  }

  // Displays student name being enrolled
  Widget _buildStudentInfoRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Select a course to enroll ",
          style: TextStyle(color: Colors.black54),
        ),
        Text(
          widget.name,
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  // Shows toast notification when enrollment succeeds
  void _showEnrollmentSuccessToast() {
    showCustomToast(
      context,
      'Enrollment Updated!',
      '${widget.name} has been enrolled in the course successfully!',
    );
  }

  /// Displays a custom toast notification
  ///
  /// [title] - Notification header text
  /// [message] - Detailed notification message
  void showCustomToast(BuildContext context, String title, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 380, // Fixed width for consistency
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-dismiss after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }
}
