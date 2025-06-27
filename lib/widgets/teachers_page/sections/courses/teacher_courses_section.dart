import 'package:flutter/material.dart';

class TeacherCoursesSection extends StatefulWidget {
  const TeacherCoursesSection({super.key});

  @override
  State<TeacherCoursesSection> createState() => _TeacherCoursesSectionState();
}

class _TeacherCoursesSectionState extends State<TeacherCoursesSection> {
  String? dropdownValue = "جميع المدرسين";
  String? dropdownValue2 = "الأحدث";

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
                  });
                },
                items: <String>['جميع المدرسين', 'المنشورة', 'غير المنشورة']
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
          children: [
            _buildCourseCard(
              title: "الفيزياء للمهندسين",
              isPublished: false,
              enrolledCount: 0,
              rating: 3.9,
              lastUpdated: "1/10/2024",
            ),
            SizedBox(height: 16),
            _buildCourseCard(
              title: "الدارات الكهربائية",
              isPublished: true,
              enrolledCount: 156,
              rating: 4.6,
              lastUpdated: "6/15/2023",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseCard({
    required String title,
    required bool isPublished,
    required int enrolledCount,
    required dynamic rating, // Can be double or null
    required String lastUpdated,
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
                  Text("$rating/5.0"),
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
                  Text(lastUpdated),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
