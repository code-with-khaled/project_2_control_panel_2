import 'package:control_panel_2/widgets/students_page/sections/overview/overview_row.dart';
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
                "المعلومات الشخصية", // "Personal Information"
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          OverviewRow(left: "الاسم الكامل:", right: name), // "Full Name:"
          OverviewRow(left: "اسم المستخدم:", right: username), // "Username:"
          OverviewRow(left: "رقم الهاتف:", right: phone), // "phone:"
          OverviewRow(left: "الجنس:", right: gender), // "Gender:"
        ],
      ),
    );
  }
}
