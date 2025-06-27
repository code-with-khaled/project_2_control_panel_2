import 'package:control_panel_2/widgets/students_page/dialogs/student_profile_dialog.dart';
import 'package:control_panel_2/widgets/teachers_page/dialogs/teacher_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Compact student profile card that expands to full dialog on tap
///
/// Displays key student information including:
/// - [name] and [username]
/// - [email] contact
/// - [joinDate] of enrollment
class TeacherProfile extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final DateTime joinDate;

  const TeacherProfile({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.joinDate,
  });

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
    ).format(widget.joinDate);

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

  // Shows the full student profile dialog
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          TeacherProfileDialog(name: widget.name, username: widget.username),
    );
  }

  // Builds card decoration with hover effects
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

  // Builds profile header with avatar and name
  Widget _buildProfileHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(radius: 22, child: Icon(Icons.person)),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              widget.username,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  // Builds field of study section
  Widget _buildFieldOfStudy() {
    return Row(
      children: [
        Icon(Icons.person_outline),
        SizedBox(width: 8),
        Text("ماجستير في الفيزياء"),
      ],
    );
  }

  // Builds course progress section
  Widget _buildCourseProgress() {
    return Row(
      children: [
        Icon(Icons.menu_book),
        SizedBox(width: 8),
        Text("6 كورسات"),
        Text("  •  178 طالب"),
      ],
    );
  }

  // Builds rating display section
  Widget _buildRatingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.yellow),
            SizedBox(width: 8),
            Text("متوسط التقييم"),
            SizedBox(width: 8),
            Text("4.6"),
          ],
        ),
      ],
    );
  }

  // Builds footer with join date and actions
  Widget _buildFooter(String formattedDate) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showProfileDialog(context);
            },
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
        InkWell(
          onTap: () {},
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
        InkWell(
          onTap: () {},
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
