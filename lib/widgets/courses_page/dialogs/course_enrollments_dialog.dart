import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/select_student_dialog.dart';
import 'package:control_panel_2/widgets/courses_page/tables/students_enrollments_table.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';

class CourseEnrollmentsDialog extends StatefulWidget {
  final Course course;

  const CourseEnrollmentsDialog({super.key, required this.course});

  @override
  State<CourseEnrollmentsDialog> createState() =>
      _CourseEnrollmentsDialogState();
}

class _CourseEnrollmentsDialogState extends State<CourseEnrollmentsDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _searchEnrollmentsController =
      TextEditingController();

  Student? _selectedStudent;

  void _selectStudent(Student? student) {
    if (student != null) {
      setState(() {
        _selectedStudent = student;
      });
    }
  }

  bool _isEnrolling = false;

  Future<void> _enrollStudent() async {
    if (_isEnrolling) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        title: Text('تأكيد الحذف'),
        content: Text(
          'هل أنت متأكد من رغبتك في تسجيل ${_selectedStudent!.fullName} في دورة ${widget.course.name} ؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('تأكيد', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isEnrolling = true;
    });

    try {
      final token = TokenHelper.getToken();
      await _courseService.enrollStudent(
        token,
        _selectedStudent!.id!,
        widget.course.id!,
      );

      if (mounted) {
        showCustomToast(
          context,
          'تم تحديث التسجيل!',
          'تم تسجيل ${_selectedStudent!.fullName} في الدورة بنجاح!',
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تسجيل الطالب'),
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnrolling = false;
        });
      }
    }
  }

  late CourseService _courseService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();
    _courseService = CourseService(apiClient: apiClient);
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
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Header section with close button
                _buildHeader(),
                SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _buildStudentField()),
                    SizedBox(width: 5),

                    ElevatedButton(
                      onPressed: () {
                        _enrollStudent();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 21,
                          horizontal: 12.5,
                        ),
                      ),
                      child: _isEnrolling
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text("تسجيل الطالب"),
                    ),
                  ],
                ),
                SizedBox(height: 25),

                _buildSearchSection2(),
                SizedBox(height: 25),

                SizedBox(
                  width: 400,
                  child: StudentsEnrollmentsTable(
                    searchQuery: _searchEnrollmentsController.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the dialog header with title and close button
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            "إدارة التسجيل - ${widget.course.name}",
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

  Widget _buildStudentField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "اختر طالب للتسجيل في دورة",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5),
      InkWell(
        onTap: () => _selectStudentDialog(),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedStudent == null
                  ? Text("اضغط لاخيار طالب", style: TextStyle(fontSize: 16))
                  : Text(
                      _selectedStudent!.fullName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
              Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        ),
      ),
    ],
  );

  void _selectStudentDialog() => showDialog(
    context: context,
    builder: (context) => SelectStudentDialog(callback: _selectStudent),
  );

  Widget _buildSearchSection2() {
    return SearchField(
      controller: _searchEnrollmentsController,
      hintText: "ابحث عن الطلاب المنتسبين ",
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  void showCustomToast(BuildContext context, String title, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
        left: 20, // Changed to left for RTL
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 380,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, // Right-align for RTL
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.right, // Right-align text
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  textAlign: TextAlign.right, // Right-align text
                ),
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
