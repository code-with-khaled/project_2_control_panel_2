import 'package:control_panel_2/constants/all_teachers.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';

class EditCourseDialog extends StatefulWidget {
  final Course course;
  const EditCourseDialog({super.key, required this.course});

  @override
  State<EditCourseDialog> createState() => _EditCourseDialogState();
}

class _EditCourseDialogState extends State<EditCourseDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _coursePriceController = TextEditingController();

  // State variables
  String? _selectedCategory;
  String? _selectedTeacher;

  @override
  void initState() {
    super.initState();

    _courseNameController.text = widget.course.name;
    _selectedCategory = widget.course.categorization;
    _selectedTeacher = widget.course.teacher;
    _coursePriceController.text = widget.course.price.toString();
    _courseDescriptionController.text = widget.course.description;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with close button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "تعديل معلومات الكورس",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Course Name field
                  _buildCourseNameField(),
                  SizedBox(height: 25),

                  // Category's Name field
                  _buildCategoryField(),
                  SizedBox(height: 25),

                  // Teacher's field
                  _buildTeacherField(),
                  SizedBox(height: 25),

                  // Price field
                  _buildPriceField(),
                  SizedBox(height: 25),

                  // Description field
                  _buildDescriptionField(),
                  SizedBox(height: 25),

                  // Submit button
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseNameField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الاسم الكورس *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل اسم الكورس",
        controller: _courseNameController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildCategoryField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("التصنيف *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر التصنيف',
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
              'الرياضيات',
              'العلوم',
              'البرمجة',
              'اللغات',
              'العلوم الإنسانية',
              'الفنون والإبداع',
              'الأعمال والاقتصاد',
              'التحضير للاختبارات',
            ].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedCategory = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );

  Widget _buildTeacherField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المدرس *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      DropdownButtonFormField<String>(
        value: _selectedTeacher,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر المدرس',
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
        items: allTeachers.map((teacher) => teacher.fullName).map((
          String value,
        ) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedTeacher = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );

  Widget _buildPriceField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("سعر التسجيل *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل سعر التسجيل",
        controller: _coursePriceController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildDescriptionField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("وصف الكورس *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل وصف  قصير للكورس",
        maxLines: 3,
        controller: _courseDescriptionController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid - process data
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("حفظ التعديلات"),
        ),
      ),
    ],
  );
}
