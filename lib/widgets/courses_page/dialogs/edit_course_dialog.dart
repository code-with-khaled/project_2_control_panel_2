import 'package:control_panel_2/constants/all_teachers.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

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
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _coursePriceController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // State variables
  String? _selectedCategory;
  String? _selectedTeacher;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Variables for storing the course image
  String? _imageUrl;
  String? _fileName;

  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file!); // This reads the file as a Base64 string

      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageUrl = reader.result as String;
          _fileName = file.name;
        });
      });
    });
  }

  // Date picker functions
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2, now.month, now.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey[300]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime endDate = DateTime(now.year, now.month, now.day + 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: endDate,
      lastDate: DateTime(endDate.year + 3, endDate.month, endDate.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey[300]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _courseNameController.text = widget.course.name;
    _selectedCategory = widget.course.category;
    _selectedTeacher = widget.course.teacher.fullName;
    // _coursePriceController.text = widget.course.price.toString();
    // _courseDescriptionController.text = widget.course.description;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
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
                        "تعديل معلومات الدورة",
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

                  // Category Name field
                  _buildCategoryField(),
                  SizedBox(height: 25),

                  // Level's field
                  _buildLevelField(),
                  SizedBox(height: 25),

                  // Teacher's field
                  _buildTeacherField(),
                  SizedBox(height: 25),

                  // Hourse.No field
                  _buildNumberOfHoursField(),
                  SizedBox(height: 25),

                  // Price field
                  _buildPriceField(),
                  SizedBox(height: 25),

                  // Description field
                  _buildDescriptionField(),
                  SizedBox(height: 25),

                  _buildImageSection(),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: _buildStartDate()),
                      SizedBox(width: 10),
                      Expanded(child: _buildEndDate()),
                    ],
                  ),
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
      Text("اسم الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل اسم الدورة",
        controller: _courseNameController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildCategoryField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("التصنيف *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
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

  Widget _buildLevelField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("مستوى الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل اسم الدورة",
        controller: _levelController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildTeacherField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المدرس *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
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

  Widget _buildNumberOfHoursField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("عدد الساعات *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل ساعات الدورة",
        controller: _hoursController,
        prefixIcon: Icon(Icons.timer_outlined, color: Colors.grey.shade600),
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildPriceField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("سعر التسجيل *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
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
      Text("وصف الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل وصف  قصير للدورة",
        maxLines: 3,
        controller: _courseDescriptionController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  /// Builds the image upload section with preview capability
  Widget _buildImageSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("صورة الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
          if (_imageUrl != null)
            InkWell(
              onTap: () {
                setState(() {
                  _imageUrl = null;
                });
              },
              child: Icon(Icons.delete_forever, color: Colors.red),
            ),
        ],
      ),
      SizedBox(height: 5),
      InkWell(
        onTap: _pickImage,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: _imageUrl == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                    Text(
                      "اضغط لتحميل الصورة",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(_fileName!, overflow: TextOverflow.ellipsis),
                  ],
                ),
        ),
      ),
    ],
  );

  Widget _buildStartDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ البدء *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      TextFormField(
        controller: _startDateController,
        decoration: InputDecoration(
          hintText: 'mm/dd/yyyy',
          suffixIcon: Icon(Icons.calendar_today),
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
        readOnly: true,
        onTap: () => _selectStartDate(context),
        // validator: _validateStartDate,
      ),
    ],
  );

  Widget _buildEndDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ الإنتهاء *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      TextFormField(
        controller: _endDateController,
        decoration: InputDecoration(
          hintText: 'mm/dd/yyyy',
          suffixIcon: Icon(Icons.calendar_today),
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
        readOnly: true,
        onTap: () => _selectEndDate(context),
        // validator: _validateEndDate,
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
