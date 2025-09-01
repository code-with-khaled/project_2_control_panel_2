import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/students_page/sections/overview/overview_row.dart';
import 'package:control_panel_2/widgets/students_page/statistic_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewSection extends StatelessWidget {
  final Student student;

  const OverviewSection({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline),
            SizedBox(width: 6),
            Text(
              "المعلومات الشخصية",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 5),
        OverviewRow(
          left: "ولد في:",
          right: DateFormat('MMM dd, yyyy', 'ar').format(student.birthDate),
        ),
        OverviewRow(left: "رقم الهاتف:", right: student.phone),
        OverviewRow(left: "الجنس:", right: student.gender),
        OverviewRow(left: "المستوى التعليمي:", right: student.educationLevel),
        OverviewRow(
          left: "عدد الدورات المكتملة:",
          right: student.completedCoursesCount.toString(),
        ),
        SizedBox(height: 10),
        _buildStatisticsSection(),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 700) {
          return Row(
            children: [
              _buildStatCard(
                icon: Icons.import_contacts,
                color: Colors.blue,
                number: student.completedCoursesCount.toString(),
                text: "الدورات المكتملة", // Completed Courses
              ),
              SizedBox(width: 10),
              _buildStatCard(
                icon: Icons.star_border,
                color: Colors.orange,
                number: student.feedbacksAvg.toString(),
                text: "متوسط التقييم", // Average Rating
              ),
              SizedBox(width: 10),
              _buildStatCard(
                icon: Icons.import_contacts,
                color: Colors.green,
                number: student.feedbacksCount.toString(),
                text: "التقييمات المقدمة", // Reviews Given
              ),
              SizedBox(width: 10),
              _buildStatCard(
                icon: Icons.import_contacts,
                color: Colors.purple,
                number: student.answersCount.toString(),
                text: "المساهمات", // Contributions
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.import_contacts,
                    color: Colors.blue,
                    number: student.completedCoursesCount.toString(),
                    text: "الدورات المكتملة",
                  ),
                  SizedBox(width: 10),
                  _buildStatCard(
                    icon: Icons.star_border,
                    color: Colors.orange,
                    number: student.feedbacksAvg.toString(),
                    text: "متوسط التقييم",
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.import_contacts,
                    color: Colors.green,
                    number: student.feedbacksCount.toString(),
                    text: "التقييمات المقدمة",
                  ),
                  SizedBox(width: 10),
                  _buildStatCard(
                    icon: Icons.import_contacts,
                    color: Colors.purple,
                    number: student.answersCount.toString(),
                    text: "المساهمات",
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String number,
    required String text,
  }) {
    return Expanded(
      child: StatisticCard(
        icon: Icon(icon, color: color, size: 27),
        number: number,
        text: text,
        backgoundColor: color.withValues(alpha: 0.1),
        color: color,
      ),
    );
  }
}
