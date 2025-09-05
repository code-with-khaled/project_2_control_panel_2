import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

class AddStudentDialog extends StatefulWidget {
  final VoidCallback callback;

  const AddStudentDialog({super.key, required this.callback});

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _parentNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State variables
  bool _obsecure = true;
  String? _selectedGender;
  DateTime? _selectedDate;
  String? _imageUrl;
  String _fileName = "لم يتم اختيار ملف";
  String? _selectedEducationLevel;
  bool _isSubmitting = false;

  void _showPassword() {
    setState(() {
      _obsecure = !_obsecure;
    });
  }

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

  String _getEducationLevel(String? level) {
    switch (level) {
      case "إعدادي":
        return "preparatory";
      case "ثانوي":
        return "secondary";
      case "جامعي":
        return "university";
      case "دراسات عليا":
        return "postgraduate";
      default:
        return "other";
    }
  }

  // Variables for API integration
  late StudentService _studentService;

  Future<void> _createStudent() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final middleName = _middleNameController.text.trim();
    final parentPhone = _parentNumberController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _mobileNumberController.text.trim();
    final educationLevel = _getEducationLevel(_selectedEducationLevel);
    final gender = _selectedGender;
    final birthDate = _selectedDate;
    final password = _passwordController.text.trim();
    final image = _imageUrl;

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
      password: password,
      image: image,
    );

    try {
      final token = TokenHelper.getToken();
      await _studentService.createStudent(token, student);

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
            title: Text('خطأ في إنشاء حساب الطالب'),
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

    final apiClient = ApiHelper.getClient();
    _studentService = StudentService(apiClient: apiClient);
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

                  // Password fields
                  Row(
                    children: [
                      Expanded(child: _buildPasswordField()),
                      SizedBox(width: 15),
                      Expanded(child: _buildConfirmPasswordField()),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Education Level field
                  _buildEducationLevelField(),
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
        backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
        child: _imageUrl == null
            ? Icon(Icons.camera_alt_outlined, color: Colors.grey)
            : null,
      ),
      if (_imageUrl != null)
        Padding(
          padding: const EdgeInsets.only(right: 60, bottom: 60),
          child: IconButton(
            onPressed: () => setState(() {
              _imageUrl = null;
              _fileName = "لم يتم اختيار ملف";
            }),
            icon: Icon(Icons.cancel_outlined, color: Colors.red),
          ),
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
        items: ['إعدادي', 'ثانوي', 'جامعي', 'دراسات عليا', 'غير ذلك'].map((
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

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _createStudent();
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
                child: Text("إنشاء حساب الطالب"),
              ),
      ),
    ],
  );
}
