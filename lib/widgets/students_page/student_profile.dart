// ignore_for_file: unused_element

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/students_page/dialogs/edit_student_dialog.dart';
import 'package:control_panel_2/widgets/students_page/dialogs/student_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// Compact student profile card that expands to full dialog on tap
///
/// Displays key student information including:
/// - [name] and [username]
/// - [phone] contact
/// - [joinDate] of enrollment
class StudentProfile extends StatefulWidget {
  final Student student;
  final VoidCallback callback;

  const StudentProfile({
    super.key,
    required this.student,
    required this.callback,
  });

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  bool isHovered = false; // Tracks hover state for visual feedback
  bool _isDeleting = false;

  // Variables for API integration
  late StudentService _studentService;

  Future<void> _deleteStudent() async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف حساب ${widget.student.fullName}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final token = TokenHelper.getToken();
      _studentService.deleteStudent(token, widget.student.id!);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حذف حساب الطالب بنجاح')));

        widget.callback();
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _studentService = StudentService(apiClient: apiClient);
  }

  @override
  Widget build(BuildContext context) {
    final formattedJoinDate = DateFormat(
      'MMM dd, yyyy',
      'ar',
    ).format(widget.student.joinDate!);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
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
              // _buildCourseProgress(),
              // SizedBox(height: 7),

              // Progress bar visualization

              // Rating display
              _buildRatingSection(),
              SizedBox(height: 10),
              EvaluationBar(rating: widget.student.feedbacksAvg!),
              SizedBox(height: 15),

              Divider(color: Colors.black12),
              SizedBox(height: 10),

              // Footer with join date and actions
              _buildFooter(formattedJoinDate),
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
      builder: (context) => StudentProfileDialog(student: widget.student),
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
        CircleAvatar(
          radius: 22,
          backgroundImage: widget.student.image != null
              ? NetworkImage(
                  "http://127.0.0.1:8000${widget.student.image!}",
                  scale: 1.0,
                )
              : null,
          child: widget.student.image == null ? Icon(Icons.person) : null,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.student.fullName,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.student.username,
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
          widget.student.educationLevel,
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
            Text(
              "${widget.student.completedCoursesCount!}/8",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "${(widget.student.completedCoursesCount! * 100 / 8)}% اكتمال",
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
        Text(
          widget.student.feedbacksAvg.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Builds footer with join date and actions
  Widget _buildFooter(String formattedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "انضم في: $formattedDate",
            style: TextStyle(color: Colors.black87, fontSize: 12),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => EditStudentDialog(
                  student: widget.student,
                  callback: widget.callback,
                ),
              ),
              icon: Icon(Icons.edit, color: Colors.green),
            ),
            IconButton(
              onPressed: () => _deleteStudent(),
              icon: _isDeleting
                  ? CircularProgressIndicator(strokeWidth: 2)
                  : Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}

/// Visual progress bar showing course completion ratio
class EvaluationBar extends StatefulWidget {
  final int rating;

  const EvaluationBar({super.key, required this.rating});

  @override
  EvaluationBarState createState() => EvaluationBarState();
}

class EvaluationBarState extends State<EvaluationBar> {
  double maxRating = 5; // Maximum possible value

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(5),
      value: widget.rating / maxRating, // Convert to 0-1 range
      minHeight: 8,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
