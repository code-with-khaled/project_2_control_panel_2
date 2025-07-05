import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/teachers_page/dialogs/edit_teacher_profile_dialog.dart';
import 'package:control_panel_2/widgets/teachers_page/dialogs/teacher_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Compact teacher profile card that:
/// - Displays key teacher information
/// - Expands to full dialog on tap
/// - Supports edit and delete actions
class TeacherProfile extends StatefulWidget {
  final Teacher teacher;

  const TeacherProfile({super.key, required this.teacher});

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  bool isHovered = false; // Tracks hover state for visual feedback

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'MMM dd, yyyy',
      'ar',
    ).format(widget.teacher.joinDate);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: _buildCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile header with avatar and name
            _buildProfileHeader(),
            SizedBox(height: 10),

            // Field of study section
            _buildFieldOfStudy(),
            SizedBox(height: 10),

            // Course progress section
            _buildCourseProgress(),
            SizedBox(height: 10),

            // Rating display
            _buildRatingSection(),
            SizedBox(height: 10),

            // Footer with join date and actions
            _buildFooter(formattedDate),
          ],
        ),
      ),
    );
  }

  /// Shows detailed teacher profile dialog
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TeacherProfileDialog(
        name: widget.teacher.fullName,
        username: widget.teacher.username,
      ),
    );
  }

  /// Builds card decoration with hover effect
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(6),
      boxShadow: isHovered
          ? [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ]
          : [],
    );
  }

  /// Builds profile header with avatar and name
  Widget _buildProfileHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: widget.teacher.profileImage != null
              ? MemoryImage(widget.teacher.profileImage!)
              : null,
          child: widget.teacher.profileImage == null
              ? Icon(Icons.person)
              : null,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.teacher.fullName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              widget.teacher.username,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds education level and specialization section
  Widget _buildFieldOfStudy() {
    return Row(
      children: [
        Icon(Icons.school),
        SizedBox(width: 8),
        Text(widget.teacher.educationLevel),
        SizedBox(width: 8),
        Text("•"),
        SizedBox(width: 8),
        Text(widget.teacher.specialization),
      ],
    );
  }

  /// Builds teaching statistics section
  Widget _buildCourseProgress() {
    return Row(
      children: [
        Icon(Icons.menu_book),
        SizedBox(width: 8),
        Text("6 كورسات"),
        SizedBox(width: 8),
        Text("•"),
        SizedBox(width: 8),
        Text("178 طالب"),
      ],
    );
  }

  /// Builds rating display section
  Widget _buildRatingSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.yellow),
        SizedBox(width: 8),
        Text("متوسط التقييم"),
        SizedBox(width: 8),
        Text(widget.teacher.rating.toStringAsFixed(1)),
      ],
    );
  }

  /// Builds footer with actions and join date
  Widget _buildFooter(String formattedDate) {
    return Row(
      children: [
        // View details button
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showProfileDialog(context),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 17.5),
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text("عرض التفاصيل"),
          ),
        ),
        SizedBox(width: 7.5),

        // Edit button
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  EditTeacherProfileDialog(teacher: widget.teacher),
            );
          },
          child: Container(
            padding: EdgeInsets.all(7.5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.edit, size: 21),
          ),
        ),
        SizedBox(width: 7.5),

        // Delete button
        InkWell(
          onTap: () {}, // TODO: Implement delete functionality
          child: Container(
            padding: EdgeInsets.all(7.5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.delete_outline, size: 21),
          ),
        ),
      ],
    );
  }
}
