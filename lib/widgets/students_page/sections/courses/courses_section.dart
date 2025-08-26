import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_course_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoursesSection extends StatefulWidget {
  final int id;

  const CoursesSection({super.key, required this.id});

  @override
  State<CoursesSection> createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection> {
  bool _isLoading = false;

  List<StudentCourse> _courses = [];

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      _courses = await _studentService.fetchStudentCourses(token, widget.id);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  late StudentService _studentService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _studentService = StudentService(apiClient: apiClient);

    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _courses.isEmpty
        ? Center(child: Text("لا يوجد دورات"))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.import_contacts),
                  SizedBox(width: 6),
                  Text(
                    "الكورسات المسجل بها",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate number of columns based on available width
                  const double itemWidth = 270; // Minimum card width
                  int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
                  itemsPerRow = itemsPerRow.clamp(
                    1,
                    3,
                  ); // Limit between 1-3 columns

                  // Build responsive grid of account cards
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      for (final course in _courses)
                        SizedBox(
                          width:
                              (constraints.maxWidth -
                                  (20 * (itemsPerRow - 1))) /
                              itemsPerRow,
                          child: CourseCard(course: course),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
  }
}

class CourseCard extends StatefulWidget {
  final StudentCourse course;

  const CourseCard({super.key, required this.course});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isHovered = false; // Tracks hover state for visual feedback

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Course image
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/course.png",
                  ), // Make sure your Course model has an imagePath property
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 12),

            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 15),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(child: Icon(Icons.person)),
                      SizedBox(width: 10),

                      Text(
                        widget.course.teacher.fullName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                          SizedBox(width: 3),
                          Text(
                            '${widget.course.studentCount} مسجلين',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 5),
                          Text(
                            widget.course.rating.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
