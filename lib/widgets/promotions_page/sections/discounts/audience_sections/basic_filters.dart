import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:flutter/material.dart';

class BasicFilters extends StatefulWidget {
  const BasicFilters({super.key});

  @override
  State<BasicFilters> createState() => _BasicFiltersState();
}

class _BasicFiltersState extends State<BasicFilters> {
  // Controllers for all form fields
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();

  // State variables
  String? _selectedGender;
  String? _selectedEducationLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First Name and Last Name fields
        Row(
          children: [
            Expanded(child: _buildFirstNameField()),
            SizedBox(width: 15),
            Expanded(child: _buildGenderField()),
          ],
        ),
        SizedBox(height: 25),

        // Education Level field
        Row(
          children: [
            Expanded(child: _buildEducationLevelField()),
            SizedBox(width: 15),
            Expanded(child: _buildSpecializationField()),
          ],
        ),
      ],
    );
  }

  Widget _buildFirstNameField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("العمر *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل العمر",
        controller: _ageController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildGenderField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الجنس *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر الجنس',
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        items: ['ذكر', 'أنثى'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedGender = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );

  Widget _buildEducationLevelField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المستوى التعليمي *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      DropdownButtonFormField<String>(
        value: _selectedEducationLevel,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر المستوى التعليمي',
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        items:
            [
              'الثانوية العامة',
              'دبلوم',
              'بكالوريوس',
              'ماجستير',
              'دكتوراه',
              'أخرى',
            ].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedEducationLevel = newValue);
        },
        // validator: (value) => _validateNotEmpty(value, "المستوى التعليمي"),
      ),
    ],
  );

  Widget _buildSpecializationField() {
    if (_selectedEducationLevel == 'الثانوية العامة' ||
        _selectedEducationLevel == null) {
      return Spacer();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("التخصص *", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 2),
          CustomTextField(
            hintText: "مثال: رياضيات، فنون، إعلام",
            controller: _specializationController,
            // validator: _validateSpecialization,
          ),
        ],
      );
    }
  }
}
