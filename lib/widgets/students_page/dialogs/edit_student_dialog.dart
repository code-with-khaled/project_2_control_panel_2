import 'dart:typed_data';

import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  // State variables
  String? _selectedGender;
  DateTime? _selectedDate;
  Uint8List? _imageBytes;
  String _fileName = "لم يتم اختيار ملف";
  String? _selectedEducationLevel;
  bool _isEditing = false;

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
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      if (picked != widget.student.birthDate) {
        _changedFields['birth_date'] = DateFormat('yyyy-MM-dd').format(picked);
        _hasChanges = true;
      } else {
        _changedFields.remove('birth_date');
        _hasChanges = _changedFields.isNotEmpty;
      }
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

  Future<void> _editStudent() async {
    if (_isEditing || !_hasChanges) return;

    setState(() {
      _isEditing = true;
    });

    try {
      final token = TokenHelper.getToken();
      await _studentService.updateStudent(
        token,
        widget.student.id!,
        _changedFields,
      );

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
    } finally {
      if (mounted) {
        setState(() {
          _isEditing = false;
        });
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
    _selectedEducationLevel = widget.student.educationLevel;
    _selectedDate = widget.student.birthDate;

    // Add listeners to track changes
    _addControllerListeners();

    final apiClient = ApiHelper.getClient();
    _studentService = StudentService(apiClient: apiClient);
  }

  final Map<String, dynamic> _changedFields = {};
  bool _hasChanges = false;

  void _addControllerListeners() {
    _firstNameController.addListener(() {
      if (_firstNameController.text != widget.student.firstName) {
        _changedFields['first_name'] = _firstNameController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('first_name');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _lastNameController.addListener(() {
      if (_lastNameController.text != widget.student.lastName) {
        _changedFields['last_name'] = _lastNameController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('last_name');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _middleNameController.addListener(() {
      if (_middleNameController.text != widget.student.middleName) {
        _changedFields['middle_name'] = _middleNameController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('middle_name');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _parentNumberController.addListener(() {
      if (_parentNumberController.text != widget.student.parentPhone) {
        _changedFields['parent_phone'] = _parentNumberController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('parent_phone');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _usernameController.addListener(() {
      if (_usernameController.text != widget.student.username) {
        _changedFields['username'] = _usernameController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('username');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _mobileNumberController.addListener(() {
      if (_mobileNumberController.text != widget.student.phone) {
        _changedFields['phone'] = _mobileNumberController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('phone');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });
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
          if (newValue != widget.student.gender) {
            _changedFields['gender'] = newValue;
            _hasChanges = true;
          } else {
            _changedFields.remove('gender');
            _hasChanges = _changedFields.isNotEmpty;
          }
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
        items: ['إعدادي', 'ثانوي', 'جامعي', 'دراسات عليا', 'غير ذلك'].map((
          String value,
        ) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedEducationLevel = newValue);
          if (newValue != widget.student.educationLevel) {
            _changedFields['education_level'] = _getEducationLevel(newValue);
            _hasChanges = true;
          } else {
            _changedFields.remove('education_level');
            _hasChanges = _changedFields.isNotEmpty;
          }
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
            // Form is valid - process data
            _editStudent();
            // print(_changedFields.toString());
          }
        },
        child: _isEditing
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
                child: Text("تعديل حساب الطالب"),
              ),
      ),
    ],
  );
}
