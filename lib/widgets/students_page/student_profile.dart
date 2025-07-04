import 'package:control_panel_2/widgets/students_page/dialogs/student_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Compact student profile card that expands to full dialog on tap
///
/// Displays key student information including:
/// - [name] and [username]
/// - [email] contact
/// - [joinDate] of enrollment
class StudentProfile extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final DateTime joinDate;

  const StudentProfile({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.joinDate,
  });

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
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
      child: GestureDetector(
        onTap: () => _showProfileDialog(context),
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
              SizedBox(height: 7),

              // Progress bar visualization
              EvaluationBar(),
              SizedBox(height: 15),

              // Rating display
              _buildRatingSection(),
              SizedBox(height: 10),

              Divider(color: Colors.black12),
              SizedBox(height: 10),

              // Footer with join date and actions
              _buildFooter(formattedDate),
            ],
          ),
        ),
      ),
    );
  }

  // Shows the full student profile dialog
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          StudentProfileDialog(name: widget.name, username: widget.username),
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
      children: [
        CircleAvatar(radius: 22, child: Icon(Icons.person)),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.username,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  // Builds field of study section
  Widget _buildFieldOfStudy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, color: Colors.black87, size: 17),
            SizedBox(width: 7),
            Text(
              "المجال الدراسي",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          "جامعة/مدرسة",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  // Builds course progress section
  Widget _buildCourseProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, color: Colors.blue, size: 17),
            SizedBox(width: 8),
            Text("الكورسات"),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("4/8", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "50% اكتمال",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
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
            Icon(Icons.star_border, size: 17, color: Colors.yellow),
            SizedBox(width: 8),
            Text("متوسط التقييم"),
          ],
        ),
        Text("4.6", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Builds footer with join date and actions
  Widget _buildFooter(String formattedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "انضم في: $formattedDate",
          style: TextStyle(color: Colors.black87, fontSize: 12),
        ),
        IconButton(
          onPressed: () {}, // TODO: Implement delete functionality
          icon: Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    );
  }
}

/// Visual progress bar showing course completion ratio
class EvaluationBar extends StatefulWidget {
  const EvaluationBar({super.key});

  @override
  EvaluationBarState createState() => EvaluationBarState();
}

class EvaluationBarState extends State<EvaluationBar> {
  double rating = 4; // Current progress value
  double maxRating = 8; // Maximum possible value

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(5),
      value: rating / maxRating, // Convert to 0-1 range
      minHeight: 8,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
