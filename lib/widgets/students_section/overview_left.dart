import 'package:control_panel_2/widgets/students_section/overview_row.dart';
import 'package:flutter/material.dart';

class OverviewLeft extends StatelessWidget {
  final String name;
  final String username;
  final String phone;
  final String gender;

  const OverviewLeft({
    super.key,
    required this.name,
    required this.username,
    required this.phone,
    required this.gender,
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
              Icon(Icons.person_outline),
              SizedBox(width: 6),
              Text(
                "Personal Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          OverviewRow(left: "Full Name:", right: name),
          OverviewRow(left: "Username:", right: username),
          OverviewRow(left: "phone:", right: phone),
          OverviewRow(left: "Gender:", right: gender),
        ],
      ),
    );
  }
}
