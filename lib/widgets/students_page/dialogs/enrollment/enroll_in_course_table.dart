import 'package:flutter/material.dart';

/// Displays a table of available courses with enrollment capability
///
/// Takes an [onEnroll] callback that triggers when enrollment is initiated
class CoursesTable extends StatelessWidget {
  final void Function() onEnroll;

  const CoursesTable({super.key, required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    // Generate mock course data (in real app, this would come from API/database)
    final List<Map<String, dynamic>> courses = List.generate(5, (index) {
      // Course data template
      String courseName = "رياكت - المستوى المتقدم"; // "React - Advanced"
      Widget category = Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "برمجة", // "Programming"
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
      );
      String teacher = "أحمد محمد"; // "John Smith"
      String date = "٦/٥/٢٠٢٤"; // Arabic numerals for date

      return {
        'name': courseName,
        'category': category,
        'teacher': teacher,
        'date': date,
        'action': ElevatedButton(
          onPressed: () => onEnroll(), // Trigger enrollment callback
          child: Text("تسجيل"), // "Enroll"
        ),
      };
    });

    return Container(
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              children: [
                _buildHeaderCell('اسم الدورة'), // "Course Name"
                _buildHeaderCell('التصنيف'), // "Category"
                _buildHeaderCell('المعلم'), // "Teacher"
                _buildHeaderCell('إجراء'), // "Action"
              ],
            ),

            // Course data rows
            ...courses.map(
              (course) => TableRow(
                decoration: BoxDecoration(color: Colors.white),
                children: [
                  _buildCourseNameCell(course['name']),
                  _buildCategoryCell(course['category']),
                  _buildTeacherCell(course['teacher']),
                  _buildActionCell(course['action']),
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
