import 'package:flutter/material.dart';

class CoursesTable extends StatelessWidget {
  final void Function() onEnroll;

  const CoursesTable({super.key, required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = List.generate(5, (index) {
      String courseName = "React - Advanced";
      Widget category = Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "Programming",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
      );
      String teacher = "John Smith";
      String date = "6/5/2024";

      return {
        'name': courseName,
        'category': category,
        'teacher': teacher,
        'date': date,
        'action': ElevatedButton(
          onPressed: () => onEnroll(),
          child: Text("Enroll"),
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
            horizontalInside: BorderSide(color: Colors.grey[300]!),
          ),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: IntrinsicColumnWidth(),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    'Course Name',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    'Teacher',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    'Action',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            ...courses.map(
              (course) => TableRow(
                decoration: BoxDecoration(color: Colors.white),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book, size: 12, color: Colors.black87),
                        SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            course['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(children: [course['category']]),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text(course['teacher']),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: course['action'],
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
