import 'package:control_panel_2/widgets/students_page/sections/overview/overview_row.dart';
import 'package:flutter/material.dart';

class OverviewRight extends StatelessWidget {
  final String university;
  final String specialization;
  final String level;

  const OverviewRight({
    super.key,
    required this.university,
    required this.specialization,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined),
              SizedBox(width: 6),
              Text(
                "Education",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          OverviewRow(left: "University:", right: university),
          OverviewRow(left: "Specialization:", right: specialization),
          OverviewRow(left: "Education level:", right: level),
        ],
      ),
    );
  }
}
