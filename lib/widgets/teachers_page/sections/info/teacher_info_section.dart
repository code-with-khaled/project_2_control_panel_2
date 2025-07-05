import 'package:flutter/material.dart';

/// Displays teacher information in two organized sections:
/// 1. Personal information (email, phone, education, experience)
/// 2. Additional information (join date, detailed experience, description)
class TeacherInfoSection extends StatelessWidget {
  const TeacherInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPersonalInfo(), // Personal details section
        SizedBox(height: 20),
        _buildAdditionalInfo(), // Additional information section
      ],
    );
  }

  /// Builds the personal information card with:
  /// - Email
  /// - Phone number
  /// - Education level
  /// - Years of experience
  Widget _buildPersonalInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with icon
          Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 8),
              Text(
                "المعلومات الشخصية",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),

          // Email and phone row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                // Email field
                child: Row(
                  children: [
                    Icon(Icons.mail_outline, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Flexible(child: Text("ahmad_mohamed@gmail.com")),
                  ],
                ),
              ),
              Expanded(
                // Phone field
                child: Row(
                  children: [
                    Icon(Icons.phone_outlined, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text("0994-387-970"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Education and experience row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                // Education field
                child: Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 8),
                    Text("ماجستير في الفيزياء"),
                  ],
                ),
              ),
              Expanded(
                // Experience field
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 8),
                    Text("3 سنوات من الخبرة"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the additional information card with:
  /// - Join date
  /// - Detailed experience
  /// - Professional description
  Widget _buildAdditionalInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            "معلومات إضافية",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),

          // Join date
          Row(
            children: [
              Text(
                "تاريخ الانضمام: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Text("11/6/2025"),
            ],
          ),
          SizedBox(height: 10),

          // Detailed experience
          Row(
            children: [
              Text("الخبرات: ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Flexible(
                child: Text("+8 سنوات في تدريس الفيزياء النظرية والتطبيقية"),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Professional description
          Row(
            children: [
              Text("الوصف: ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  "مدرس صاحب شغف كبير وخبرة في الفيزياء، كرس حياته لمساعدة الطلاب على الوصول لأهدافهم التعليمية.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
