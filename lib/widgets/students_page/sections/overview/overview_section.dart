import 'package:control_panel_2/widgets/students_page/sections/overview/overview_left.dart';
import 'package:control_panel_2/widgets/students_page/sections/overview/overview_right.dart';
import 'package:control_panel_2/widgets/students_page/statistic_card.dart';
import 'package:flutter/material.dart';

class OverviewSection extends StatelessWidget {
  final String name;
  final String username;

  const OverviewSection({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: OverviewLeft(
                      name: name,
                      username: username,
                      phone: '+963-994-387-970',
                      gender: 'Male',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: OverviewRight(
                      university: "MIT",
                      specialization: "Data Science",
                      level: "Master Degree",
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  OverviewLeft(
                    name: name,
                    username: username,
                    phone: '+963-994-387-970',
                    gender: 'Male',
                  ),
                  SizedBox(height: 20),
                  OverviewRight(
                    university: "MIT",
                    specialization: "Data Science",
                    level: "Master Degree",
                  ),
                ],
              );
            }
          },
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
                number: "9",
                text: "Completed Courses",
              ),
              SizedBox(width: 10),
              _buildStatCard(
                icon: Icons.star_border,
                color: Colors.orange,
                number: "4.9",
                text: "Average Rating",
              ),
              SizedBox(width: 10),
              _buildStatCard(
                icon: Icons.import_contacts,
                color: Colors.green,
                number: "28",
                text: "Reviews Given",
              ),
              SizedBox(width: 10),
              _buildStatCard(
                icon: Icons.import_contacts,
                color: Colors.purple,
                number: "45",
                text: "Contributions",
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
                    number: "9",
                    text: "Completed Courses",
                  ),
                  SizedBox(width: 10),
                  _buildStatCard(
                    icon: Icons.star_border,
                    color: Colors.orange,
                    number: "4.9",
                    text: "Average Rating",
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.import_contacts,
                    color: Colors.green,
                    number: "28",
                    text: "Reviews Given",
                  ),
                  SizedBox(width: 10),
                  _buildStatCard(
                    icon: Icons.import_contacts,
                    color: Colors.purple,
                    number: "45",
                    text: "Contributions",
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
