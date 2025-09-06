import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:flutter/material.dart';

/// Displays a table of available courses with enrollment capability
///
/// Takes an [onEnroll] callback that triggers when enrollment is initiated
class CoursesTable extends StatefulWidget {
  final Future<bool> Function(int, String) onEnroll;

  const CoursesTable({super.key, required this.onEnroll});

  @override
  State<CoursesTable> createState() => _CoursesTableState();
}

class _CoursesTableState extends State<CoursesTable> {
  // State variables
  bool _isLoading = true;

  List<Course> _courses = [];

  Future<void> _fetchCourses() async {
    try {
      final token = TokenHelper.getToken();
      final data = await _courseService.fetchCourses(token);
      _courses = data['courses'];
    } catch (e) {
      throw Exception(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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

    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue,
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: BoxBorder.all(color: Colors.grey[300]!),
            ),
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey[300]!,
                  ), // Row dividers
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(), // Course name (flexible)
                  1: FlexColumnWidth(), // Category (flexible)
                  2: FlexColumnWidth(), // Teacher (flexible)
                  3: IntrinsicColumnWidth(), // Action (fits content)
                },
                children: [
                  // Table header row
                  TableRow(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    children: [
                      _buildHeaderCell('اسم الدورة'), // "Course Name"
                      _buildHeaderCell('التصنيف'), // "Category"
                      _buildHeaderCell('المعلم'), // "Teacher"
                      _buildHeaderCell('إجراء'), // "Action"
                    ],
                  ),

                  // Course data rows
                  ..._courses.map(
                    (course) => TableRow(
                      decoration: BoxDecoration(color: Colors.white),
                      children: [
                        _buildCourseNameCell(course.name),
                        _buildCategoryCell(Text(course.categoryName)),
                        _buildTeacherCell(course.teacher.fullName),
                        _buildActionCell(
                          ElevatedButton(
                            onPressed: () async {
                              final isEnrolled = await widget.onEnroll(
                                course.id!,
                                course.name,
                              );
                              if (isEnrolled) {
                                setState(() {
                                  _isLoading = true;
                                  _fetchCourses();
                                });
                              }
                            }, // Trigger enrollment callback
                            child: Text("تسجيل"), // "Enroll"
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // Builds a standardized header cell
  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600),
        textDirection: TextDirection.rtl, // Right-align Arabic headers
      ),
    );
  }

  // Builds course name cell with icon
  Widget _buildCourseNameCell(String name) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book, size: 12, color: Colors.black87),
          SizedBox(width: 7),
          Flexible(
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textDirection: TextDirection.rtl, // Right-align Arabic text
            ),
          ),
        ],
      ),
    );
  }

  // Builds category cell
  Widget _buildCategoryCell(Widget category) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Right-align category
        children: [category],
      ),
    );
  }

  // Builds teacher cell
  Widget _buildTeacherCell(String teacher) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        teacher,
        textDirection: TextDirection.rtl, // Right-align Arabic text
      ),
    );
  }

  // Builds action/enroll button cell
  Widget _buildActionCell(Widget action) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: action,
    );
  }
}
