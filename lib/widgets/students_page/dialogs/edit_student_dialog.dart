import 'dart:typed_data';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/students_service.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditStudentDialog extends StatefulWidget {
  final VoidCallback callback;
  final Student student;

  const EditStudentDialog({
    super.key,
    required this.student,
    required this.callback,
  });

  @override
  State<EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _parentNumberController;
  late TextEditingController _usernameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _dateController;
  final TextEditingController _specializationController =
      TextEditingController();

  // State variables
  String? _selectedGender;
  DateTime? _selectedDate;
  Uint8List? _imageBytes;
  String _fileName = "لم يتم اختيار ملف";
  String? _selectedEducationLevel;

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  // Image picker function
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageBytes = result.files.single.bytes;
        _fileName = result.files.single.name;
      });
    }
  }

  // Validation functions
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الجوال مطلوب';
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return 'أدخل رقم جوال صحيح';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'تاريخ الميلاد مطلوب';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null) {
      return 'الجنس مطلوب';
    }
    return null;
  }

  String? _validateSpecialization(String? value) {
    if (value == null || value.isEmpty) {
      return 'التخصص مطلوب';
    }
    return null;
  }

  // Variables for API integration
  late StudentsService _studentService;

  Future<void> _editStudent() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final middleName = _middleNameController.text.trim();
    final parentPhone = _parentNumberController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _mobileNumberController.text.trim();
    final educationLevel = _selectedEducationLevel == "بكالوريوس"
        ? 'university'
        : '';
    final gender = _selectedGender;
    final birthDate = _selectedDate;

    final student = Student(
      username: username,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      phone: phone,
      parentPhone: parentPhone,
      educationLevel: educationLevel,
      gender: gender!,
      birthDate: birthDate!,
    );

    try {
      final token = TokenHelper.getToken();
      await _studentService.editStudent(token, widget.student.id!, student);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم تعديل حساب الطالب بنجاح')));
        widget.callback();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تعديل الطالب'),
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.student.firstName,
    );
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _middleNameController = TextEditingController(
      text: widget.student.middleName,
    );
    _parentNumberController = TextEditingController(
      text: widget.student.parentPhone,
    );
    _usernameController = TextEditingController(text: widget.student.username);
    _mobileNumberController = TextEditingController(text: widget.student.phone);
    _dateController = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(widget.student.birthDate),
    );

    _selectedGender = widget.student.gender;
    _selectedEducationLevel = widget.student.educationLevel == "جامعي"
        ? 'بكالوريوس'
        : '';
    _selectedDate = widget.student.birthDate;

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _studentService = StudentsService(apiClient: apiClient);
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
                        "إنشاء حساب طالب جديد",
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

                  // First Name and Last Name fields
                  Row(
                    children: [
                      Expanded(child: _buildFirstNameField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildLastNameField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Father's Name field
                  Row(
                    children: [
                      Expanded(child: _buildFatherNameField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildFatherNumberField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Username and Mobile Number fields
                  Row(
                    children: [
                      Expanded(child: _buildUsernameField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildMobileNumberField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Gender and Date of Birth fields
                  Row(
                    children: [
                      Expanded(child: _buildGenderField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildDateOfBirthField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Profile Image section
                  _buildProfileImageSection(),
                  SizedBox(height: 20),

                  // Education Level field
                  Row(
                    children: [
                      Expanded(child: _buildEducationLevelField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildSpecializationField()),
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

  Widget _buildFirstNameField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الاسم الأول *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل الاسم الأول",
        controller: _firstNameController,
        validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildLastNameField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الاسم الأخير *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل الاسم الأخير",
        controller: _lastNameController,
        validator: (value) => _validateNotEmpty(value, "الاسم الأخير"),
      ),
    ],
  );

  Widget _buildFatherNameField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("اسم الأب *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل اسم الأب",
        controller: _middleNameController,
        validator: (value) => _validateNotEmpty(value, "اسم الأب"),
      ),
    ],
  );

  Widget _buildFatherNumberField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("رقم جوال الأب *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل رقم الجوال",
        controller: _parentNumberController,
        validator: _validateMobileNumber,
      ),
    ],
  );

  Widget _buildUsernameField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("اسم المستخدم *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل اسم المستخدم",
        controller: _usernameController,
        validator: (value) => _validateNotEmpty(value, "اسم المستخدم"),
      ),
    ],
  );

  Widget _buildMobileNumberField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("رقم الجوال *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل رقم الجوال",
        controller: _mobileNumberController,
        validator: _validateMobileNumber,
      ),
    ],
  );

  Widget _buildGenderField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الجنس *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
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
        items: ['M', 'F'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedGender = newValue);
        },
        validator: _validateGender,
      ),
    ],
  );

  Widget _buildDateOfBirthField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ الميلاد *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      TextFormField(
        controller: _dateController,
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
        onTap: () => _selectDate(context),
        validator: _validateDate,
      ),
    ],
  );

  Widget _buildProfileImageSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "صورة الملف الشخصي (اختياري)",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          Expanded(child: _buildImagePickerButton()),
          SizedBox(width: 15),
          _buildImagePreview(),
        ],
      ),
    ],
  );

  Widget _buildImagePickerButton() => InkWell(
    onTap: _pickImage,
    child: Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: "اختر ملف",
            hintStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 120, bottom: 2),
          child: Text(_fileName),
        ),
      ],
    ),
  );

  Widget _buildImagePreview() => Stack(
    alignment: Alignment.center,
    children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[200],
        backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
        child: _imageBytes == null
            ? Icon(Icons.camera_alt_outlined, color: Colors.grey)
            : null,
      ),
      if (_imageBytes != null)
        Padding(
          padding: const EdgeInsets.only(right: 60, bottom: 60),
          child: IconButton(
            onPressed: () => setState(() {
              _imageBytes = null;
              _fileName = "لم يتم اختيار ملف";
            }),
            icon: Icon(Icons.cancel_outlined, color: Colors.red),
          ),
        ),
    ],
  );

  Widget _buildEducationLevelField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المستوى التعليمي *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
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
        validator: (value) => _validateNotEmpty(value, "المستوى التعليمي"),
      ),
    ],
  );

  Widget _buildSpecializationField() {
    if (_selectedEducationLevel == 'الثانوية العامة' ||
        _selectedEducationLevel == null) {
      return SizedBox.shrink();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("التخصص *", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          CustomTextField(
            hintText: "مثال: رياضيات، فنون، إعلام",
            controller: _specializationController,
            validator: _validateSpecialization,
          ),
        ],
      );
    }
  }

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid - process data
            _editStudent();
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("تعديل حساب الطالب"),
        ),
      ),
    ],
  );
}
