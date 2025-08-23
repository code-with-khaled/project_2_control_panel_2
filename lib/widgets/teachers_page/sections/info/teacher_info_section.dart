import 'package:control_panel_2/models/teacher_model.dart';
import 'package:flutter/material.dart';

/// Displays teacher information in two organized sections:
/// 1. Personal information (email, phone, education, experience)
/// 2. Additional information (join date, detailed experience, description)
class TeacherInfoSection extends StatelessWidget {
  final Teacher teacher;

  const TeacherInfoSection({super.key, required this.teacher});

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

          // Education and phone row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                // Phone field
                child: Row(
                  children: [
                    Icon(Icons.phone_outlined, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(teacher.phone),
                  ],
                ),
              ),
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
                    Text(
                      "${teacher.educationLevel} | ${teacher.specialization}",
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Headline
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.person_3_outlined, size: 18, color: Colors.black54),
              SizedBox(width: 8),
              Flexible(child: Text(teacher.headline)),
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
              Text("التقييم: ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Text(teacher.rate!.toStringAsFixed(1)),
            ],
          ),
          SizedBox(height: 10),

          // Detailed experience
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("الخبرات: ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Flexible(child: Text(teacher.experiences)),
            ],
          ),
          SizedBox(height: 10),

          // Professional description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("الوصف: ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Flexible(child: Text(teacher.description)),
            ],
          ),
        ],
      ),
    );
  }
}
