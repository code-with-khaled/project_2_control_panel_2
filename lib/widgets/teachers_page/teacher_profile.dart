import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/teachers_page/dialogs/edit_teacher_profile_dialog.dart';
import 'package:control_panel_2/widgets/teachers_page/dialogs/teacher_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Compact teacher profile card that:
/// - Displays key teacher information
/// - Expands to full dialog on tap
/// - Supports edit and delete actions
class TeacherProfile extends StatefulWidget {
  final VoidCallback callback;
  final Teacher teacher;

  const TeacherProfile({
    super.key,
    required this.teacher,
    required this.callback,
  });

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  bool isHovered = false; // Tracks hover state for visual feedback
  bool _isDeleting = false;

  // Variables for API integration
  late TeacherService _teachersService;

  Future<void> _deleteStudent() async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف حساب ${widget.teacher.fullName}؟',
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
      _teachersService.deleteTeacher(token, widget.teacher.id!);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حذف حساب المدرس بنجاح')));

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

    _teachersService = TeacherService(apiClient: apiClient);
  }

  @override
  Widget build(BuildContext context) {
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
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// Shows detailed teacher profile dialog
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TeacherProfileDialog(teacher: widget.teacher),
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
          backgroundImage: widget.teacher.image != null
              ? NetworkImage(widget.teacher.fullImageUrl)
              : null,
          child: widget.teacher.image == null ? Icon(Icons.person) : null,
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
        Text(widget.teacher.rate!.toStringAsFixed(1)),
      ],
    );
  }

  /// Builds footer with actions and join date
  Widget _buildFooter() {
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
              builder: (context) => EditTeacherProfileDialog(
                teacher: widget.teacher,
                callback: widget.callback,
              ),
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
          onTap: () => _deleteStudent(),
          child: Container(
            padding: EdgeInsets.all(7.5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: _isDeleting
                ? CircularProgressIndicator(strokeWidth: 2)
                : Icon(Icons.delete_outline, size: 21),
          ),
        ),
      ],
    );
  }
}
