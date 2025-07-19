import 'package:control_panel_2/widgets/courses_page/tables/exams_results_table.dart';
import 'package:flutter/material.dart';

class ExamsSection extends StatefulWidget {
  const ExamsSection({super.key});

  @override
  State<ExamsSection> createState() => _ExamsSectionState();
}

class _ExamsSectionState extends State<ExamsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), SizedBox(height: 25), ExamsResultsTable()],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.school_outlined),
        SizedBox(width: 10),
        Text(
          "نتائج الاختبارات",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
