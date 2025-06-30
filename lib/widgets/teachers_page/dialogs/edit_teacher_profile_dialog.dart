import 'dart:typed_data';

import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditTeacherProfileDialog extends StatefulWidget {
  final Teacher teacher;

  const EditTeacherProfileDialog({super.key, required this.teacher});

  @override
  State<EditTeacherProfileDialog> createState() =>
      _EditTeacherProfileDialogState();
}

class _EditTeacherProfileDialogState extends State<EditTeacherProfileDialog> {
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
  final TextEditingController _certificatesController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // State variables
  Uint8List? _imageBytes;
  String? _selectedEducationLevel;

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

  @override
  void initState() {
    super.initState();

    // Initialize controllers with teacher data
    _firstNameController.text = widget.teacher.firstName;
    _lastNameController.text = widget.teacher.lastName;
    _usernameController.text = widget.teacher.username;
    _mobileNumberController.text = widget.teacher.mobileNumber;

    // Password fields are intentionally left empty for security
    _passwordController.text = '';
    _confirmPasswordController.text = '';

    _specializationController.text = widget.teacher.specialization;
    _certificatesController.text = widget.teacher.certificates;
    _experienceController.text = widget.teacher.experience;
    _descriptionController.text = widget.teacher.description;

    // Set the education level dropdown value
    _selectedEducationLevel = widget.teacher.educationLevel;

    // Set the profile image if it exists
    _imageBytes = widget.teacher.profileImage;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _specializationController.dispose();
    _certificatesController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'مطلوب $fieldName';
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

  String? _validateSpecialization(String? value) {
    if (value == null || value.isEmpty) {
      return 'التخصص مطلوب';
    }
    return null;
  }

  String? _validateCertifications(String? value) {
    if (value == null || value.isEmpty) {
      return 'الشهدات مطلوبة';
    }
    return null;
  }

  String? _validateExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'الخبرة مطلوبة';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'الوصف مطلوب';
    }
    return null;
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
                        "تعديل بيانات المدرس",
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

                  // Certificates field
                  _buildCertificatesField(),
                  SizedBox(height: 25),

                  // Work Experience field
                  _buildWorkExperienceField(),
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
      SizedBox(height: 2),
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
      SizedBox(height: 2),
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
      SizedBox(height: 2),
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
      SizedBox(height: 2),
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
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل كلمة المرور",
        controller: _passwordController,
        maxLines: 1,
        obsecure: true,
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
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أعد إدخال كلمة المرور",
        controller: _confirmPasswordController,
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
        items: ['دبلوم', 'بكالوريوس', 'ماجستير', 'دكتوراه', 'أخرى'].map((
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
      Text("التخصص الجامعي *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "مثال: رياضيات، كيمياء",
        controller: _specializationController,
        validator: _validateSpecialization,
      ),
    ],
  );

  Widget _buildCertificatesField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الشهادات *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل الشهادات ذات الصلة والمؤهلات",
        controller: _certificatesController,
        maxLines: 3,
        validator: _validateCertifications,
      ),
    ],
  );

  Widget _buildWorkExperienceField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("سنوات الخبرة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "مثال:  5 سنوات",
        controller: _experienceController,
        validator: _validateExperience,
      ),
    ],
  );

  Widget _buildDescriptionField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("وصف قصير *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "شرح مختصر حول خلفية المدرس و خبرته",
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
