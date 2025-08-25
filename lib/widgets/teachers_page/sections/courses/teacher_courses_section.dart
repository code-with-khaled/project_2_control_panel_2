import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TeacherCoursesSection extends StatefulWidget {
  final int id;

  const TeacherCoursesSection({super.key, required this.id});

  @override
  State<TeacherCoursesSection> createState() => _TeacherCoursesSectionState();
}

class _TeacherCoursesSectionState extends State<TeacherCoursesSection> {
  String? dropdownValue2 = "الأحدث";
  bool _isLoading = false;

  // Date formatter instance
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy', 'ar');

  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _filteredCourses = [];

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      _courses = await _teacherService.fetchCourse(token, widget.id);
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

  late TeacherService _teacherService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _teacherService = TeacherService(apiClient: apiClient);

    _fetchCourses();

    _applyFilters(); // Initialize filtered list
  }

  void _applyFilters() {
    setState(() {
      // Apply sorting
      if (dropdownValue2 == "الأعلى تقييم") {
        _filteredCourses.sort((a, b) {
          final aRating = a['rating'] ?? 0.0;
          final bRating = b['rating'] ?? 0.0;
          return (bRating as double).compareTo(aRating as double);
        });
      } else if (dropdownValue2 == "عدد الطلاب") {
        _filteredCourses.sort(
          (a, b) => (b['enrolledCount'] as double).compareTo(
            a['enrolledCount'] as double,
          ),
        );
      } else {
        // Default sort by date (assuming newer dates come first)
        _filteredCourses.sort((a, b) => b['date'].compareTo(a['date']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile filter section
        Row(
          children: [
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                value: dropdownValue2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue2 = newValue;
                    _applyFilters();
                  });
                },
                items: <String>['الأحدث', 'الأعلى تقييم', 'عدد الطلاب']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        // Courses list
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: _filteredCourses.map((course) {
                  return Column(
                    children: [
                      _buildCourseCard(
                        title: course['name'],
                        enrolledCount: course['number_of_students'],
                        rating: course['rating'],
                        date: course['start_date'],
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildCourseCard({
    required String title,
    required int enrolledCount,
    required dynamic rating,
    required DateTime date,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course title and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              // Enrolled count
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text("$enrolledCount مسجلين"),
                ],
              ),
              SizedBox(width: 16),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.yellow),
                  SizedBox(width: 4),
                  rating == null ? Text("لا يوجد تقييم") : Text("$rating/5.0"),
                ],
              ),
              SizedBox(width: 16),

              // Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(_dateFormatter.format(date)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
