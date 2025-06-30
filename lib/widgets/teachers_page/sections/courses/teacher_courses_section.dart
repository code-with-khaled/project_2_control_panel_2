import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherCoursesSection extends StatefulWidget {
  const TeacherCoursesSection({super.key});

  @override
  State<TeacherCoursesSection> createState() => _TeacherCoursesSectionState();
}

class _TeacherCoursesSectionState extends State<TeacherCoursesSection> {
  String? dropdownValue = "جميع الكورسات";
  String? dropdownValue2 = "الأحدث";

  // Date formatter instance
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy', 'ar');

  final List<Map<String, dynamic>> _courses = [
    {
      "title": "الفيزياء للمهندسين",
      "isPublished": false,
      "enrolledCount": 0,
      "rating": 3.9,
      "date": DateTime(2024, 1, 10), // Using DateTime instead of string
    },
    {
      "title": "الدارات الكهربائية",
      "isPublished": true,
      "enrolledCount": 156,
      "rating": 4.6,
      "date": DateTime(2023, 6, 15),
    },
    {
      "title": "الرياضيات المتقدمة",
      "isPublished": true,
      "enrolledCount": 89,
      "rating": 4.8,
      "date": DateTime(2024, 3, 5),
    },
    {
      "title": "برمجة التطبيقات",
      "isPublished": false,
      "enrolledCount": 0,
      "rating": null,
      "date": DateTime(2024, 2, 20),
    },
    // Add more courses as needed
  ];
  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _applyFilters(); // Initialize filtered list
  }

  void _applyFilters() {
    setState(() {
      _filteredCourses = _courses.where((course) {
        // Apply dropdown filter
        return dropdownValue == "جميع الكورسات" ||
            (dropdownValue == "المنشورة" && course['isPublished']) ||
            (dropdownValue == "غير المنشورة" && !course['isPublished']);
      }).toList();

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
            // Dropdown filter section
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                value: dropdownValue,
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
                    dropdownValue = newValue;
                    _applyFilters();
                  });
                },
                items: <String>['جميع الكورسات', 'المنشورة', 'غير المنشورة']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
              ),
            ),
            SizedBox(width: 10),
            // Dropdown2 filter section
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
        Column(
          children: _filteredCourses.map((course) {
            return Column(
              children: [
                _buildCourseCard(
                  title: course['title'],
                  isPublished: course['isPublished'],
                  enrolledCount: course['enrolledCount'],
                  rating: course['rating'],
                  date: course['date'],
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
    required bool isPublished,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: isPublished ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPublished ? "منشور" : "غير منشور",
                  style: TextStyle(
                    color: isPublished ? Colors.white : Colors.black87,
                    fontSize: 12,
                  ),
                ),
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
