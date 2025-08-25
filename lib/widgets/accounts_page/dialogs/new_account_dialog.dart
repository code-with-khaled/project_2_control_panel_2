import 'dart:typed_data';

import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NewAccountDialog extends StatefulWidget {
  const NewAccountDialog({super.key});

  @override
  State<NewAccountDialog> createState() => _NewAccountDialogState();
}

class _NewAccountDialogState extends State<NewAccountDialog> {
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

  // State variables
  bool _obsecure = true;
  Uint8List? _imageBytes;
  String? _selectAccountType;
  String? _selectedEducationLevel;

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with close button
                  _buildHeader(),
                  SizedBox(height: 25),

                  // Profile Picture
                  _buildProfilePicture(),
                  SizedBox(height: 25),

                  // Account Type
                  _buildAccountType(),
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

                  // Education Level
                  _buildEducationLevelField(),
                  SizedBox(height: 25),

                  // Password fields
                  _buildPasswordField(),
                  SizedBox(height: 25),
                  _buildConfirmPasswordField(),
                  SizedBox(height: 40),

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

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "إنشاء حساب جديد",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Spacer(),
      IconButton(
        icon: Icon(Icons.close, size: 20),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      ),
    ],
  );

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

  Widget _buildAccountType() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("نوع الحساب *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectAccountType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر نوع الحساب',
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
        items: ['إداري', 'محاسب'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectAccountType = newValue);
        },
        validator: (value) => _validateNotEmpty(value, "نوع الحساب"),
      ),
    ],
  );

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

  Widget _buildSubmitButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("إلغاء"),
          ),
        ),
      ),
      SizedBox(width: 15),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Form is valid - process data
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("إنشاء الحساب"),
          ),
        ),
      ),
    ],
  );
}
