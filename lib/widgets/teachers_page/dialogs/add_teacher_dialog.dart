import 'dart:typed_data';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTeacherDialog extends StatefulWidget {
  final VoidCallback callback;

  const AddTeacherDialog({super.key, required this.callback});

  @override
  State<AddTeacherDialog> createState() => _AddTeacherDialogState();
}

class _AddTeacherDialogState extends State<AddTeacherDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _experiencesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // State variables
  bool _obsecure = true;
  Uint8List? _imageBytes;
  String? _selectedEducationLevel;
  bool _isSubmitting = false;

  void _showPassword() {
    setState(() {
      _obsecure = !_obsecure;
    });
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 8) {
      return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'كلمات المرور غير متطابقة';
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

  String? _validateHeadline(String? value) {
    if (value == null || value.isEmpty) {
      return 'المؤهل مطلوب';
    }
    return null;
  }

  String? _validateExperiences(String? value) {
    if (value == null || value.isEmpty) {
      return 'الخبرات مطلوبة';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'الوصف مطلوب';
    }
    return null;
  }

  // Variables for API integration
  late TeacherService _teachersService;

  Future<void> _createTeacher() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _mobileNumberController.text.trim();
    // final educationLevel = _selectedEducationLevel;
    final educationLevel = 'university';

    final password = _passwordController.text.trim();
    final specialization = _specializationController.text.trim();
    final headline = _headlineController.text.trim();
    final experiences = _experiencesController.text.trim();
    final description = _descriptionController.text.trim();

    final teacher = Teacher(
      firstName: firstName,
      lastName: lastName,
      username: username,
      phone: phone,
      password: password,
      educationLevel: educationLevel,
      specialization: specialization,
      headline: headline,
      experiences: experiences,
      description: description,
    );

    try {
      final token = TokenHelper.getToken();
      await _teachersService.createTeacher(token, teacher);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إنشاء حساب الطالب بنجاح')));
        widget.callback();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في إنشاء حساب الطالب الطالب'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _teachersService = TeacherService(apiClient: apiClient);
  }

  @override
  void dispose() {
    // Clean up controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _specializationController.dispose();
    _headlineController.dispose();
    _experiencesController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                        "إنشاء حساب مدرس جديد",
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

                  // Profile Picture
                  _buildProfilePicture(),
                  SizedBox(height: 25),

                  // First Name and last name fields
                  Row(
                    children: [
                      Expanded(child: _buildFirstNameField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildLastNameField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Username field
                  _buildUsernameField(),
                  SizedBox(height: 25),

                  // Phone Number field
                  _buildMobileNumberField(),
                  SizedBox(height: 25),

                  // Password fields
                  Row(
                    children: [
                      Expanded(child: _buildPasswordField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildConfirmPasswordField()),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Education Level and Specialization fields
                  Row(
                    children: [
                      Expanded(child: _buildEducationLevelField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildSpecializationField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Headline field
                  _buildHeadlineField(),
                  SizedBox(height: 25),

                  // Experiences field
                  _buildExperiencesField(),
                  SizedBox(height: 25),

                  // Short Description field
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

  Widget _buildProfilePicture() {
    return Center(
      child: Column(
        children: [
          Text(
            "الصورة الشخصية (اختياري)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _imageBytes != null
                    ? MemoryImage(_imageBytes!)
                    : null,
                child: _imageBytes == null
                    ? Icon(Icons.camera_alt_outlined, color: Colors.grey)
                    : null,
              ),
              if (_imageBytes != null)
                Positioned(
                  top: 1,
                  right: 1,
                  child: IconButton(
                    onPressed: () => setState(() => _imageBytes = null),
                    icon: Icon(Icons.cancel_outlined, color: Colors.red),
                  ),
                ),
            ],
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              _pickImage();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.black12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_upload_outlined),
                  SizedBox(width: 5),
                  Text(
                    "تحميل الصورة",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        validator: (value) => _validateMobileNumber(value),
      ),
    ],
  );

  Widget _buildPasswordField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("كلمة المرور *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل كلمة المرور",
        controller: _passwordController,
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
        suffix: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
            onPressed: () {
              _showPassword();
            },
            icon: _obsecure
                ? Icon(Icons.visibility_outlined, color: Colors.grey.shade600)
                : Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.grey.shade600,
                  ),
          ),
        ),
        maxLines: 1,
        obsecure: _obsecure,
        validator: _validatePassword,
      ),
    ],
  );

  Widget _buildConfirmPasswordField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "تأكيد كلمة المرور *",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أعد إدخال كلمة المرور",
        controller: _confirmPasswordController,
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
        maxLines: 1,
        obsecure: true,
        validator: _validateConfirmPassword,
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
        items: ['غير ذلك', 'دراسات عليا', 'جامعي', 'ثانوي', 'إعدادي'].map((
          String value,
        ) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedEducationLevel = newValue);
        },
        validator: (value) => _validateNotEmpty(value, "المستوى التعليمي"),
      ),
    ],
  );

  Widget _buildSpecializationField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("التخصص *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "مثال: رياضيات، كيمياء",
        controller: _specializationController,
      ),
    ],
  );

  Widget _buildHeadlineField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المؤهلات *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل المؤهلات",
        controller: _headlineController,
        validator: _validateHeadline,
      ),
    ],
  );

  Widget _buildExperiencesField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الخبرات *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل الخبرات الخاصة بالمدرس",
        maxLines: 3,
        controller: _experiencesController,
        validator: _validateExperiences,
      ),
    ],
  );

  Widget _buildDescriptionField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("وصف قصير *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "شرح مختصر حول خلفية المدرس",
        maxLines: 4,
        controller: _descriptionController,
        validator: _validateDescription,
      ),
    ],
  );

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _createTeacher();
          }
        },
        child: _isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("إنشاء حساب المدرس"),
              ),
      ),
    ],
  );
}
