import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/account_service.dart';
import 'package:control_panel_2/models/account_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

class EditAccountDialog extends StatefulWidget {
  final Account account;
  final VoidCallback callback;

  const EditAccountDialog({
    super.key,
    required this.account,
    required this.callback,
  });

  @override
  State<EditAccountDialog> createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends State<EditAccountDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  // State variables
  String? _selectAccountType;
  String? _selectedEducationLevel;
  bool _isSubmitting = false;

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

  String _getEducationLevelArabic(String? level) {
    switch (level) {
      case "preparatory":
        return "إعدادي";
      case "secondary":
        return "ثانوي";
      case "university":
        return "جامعي";
      case "postgraduate":
        return "دراسات عليا";
      default:
        return "غير ذلك";
    }
  }

  String _getAccountType(String? type) {
    switch (type) {
      case "إداري":
        return "finance";
      default:
        return "staff";
    }
  }

  String _getAccountTypeArabic(String? type) {
    switch (type) {
      case "staff":
        return "إداري";
      default:
        return "محاسب";
    }
  }

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

  // Variables for API integration
  late AccountService _accountService;

  Future<void> _editTeacher() async {
    if (_isSubmitting || !_hasChanges) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = TokenHelper.getToken();
      await _accountService.editAccount(
        token,
        _changedFields,
        widget.account.id!,
        _imageUrl,
        _fileName,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم تعديل حساب المدرس بنجاح')));
        widget.callback();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تعديل المدرس'),
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

    _selectAccountType = widget.account.type == "staff" ? "إداري" : "محاسب";
    _firstNameController.text = widget.account.firstName;
    _lastNameController.text = widget.account.lastName;
    _usernameController.text = widget.account.username;
    _mobileNumberController.text = widget.account.phone;
    _selectedEducationLevel = _getEducationLevelArabic(
      widget.account.educationLevel,
    );

    _addControllerListeners();

    final apiClient = ApiHelper.getClient();

    _accountService = AccountService(apiClient: apiClient);
  }

  final Map<String, String> _changedFields = {};
  bool _hasChanges = false;

  void _addControllerListeners() {
    _firstNameController.addListener(() {
      if (_firstNameController.text != widget.account.firstName) {
        _changedFields['first_name'] = _firstNameController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('first_name');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _lastNameController.addListener(() {
      if (_lastNameController.text != widget.account.lastName) {
        _changedFields['last_name'] = _lastNameController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('last_name');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _usernameController.addListener(() {
      if (_usernameController.text != widget.account.username) {
        _changedFields['username'] = _usernameController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('username');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _mobileNumberController.addListener(() {
      if (_mobileNumberController.text != widget.account.phone) {
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
              // CircleAvatar(
              //   radius: 50,
              //   backgroundColor: Colors.grey[200],
              //   backgroundImage: _imageBytes != null
              //       ? MemoryImage(_imageBytes!)
              //       : null,
              //   child: _imageBytes == null
              //       ? Icon(Icons.camera_alt_outlined, color: Colors.grey)
              //       : null,
              // ),
              // if (_imageBytes != null)
              //   Positioned(
              //     top: 1,
              //     right: 1,
              //     child: IconButton(
              //       onPressed: () => setState(() => _imageBytes = null),
              //       icon: Icon(Icons.cancel_outlined, color: Colors.red),
              //     ),
              //   ),
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
          if (newValue != _getAccountTypeArabic(widget.account.type)) {
            _changedFields['type'] = _getAccountType(newValue);
            _hasChanges = true;
          } else {
            _changedFields.remove('type');
            _hasChanges = _changedFields.isNotEmpty;
          }
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
        items: ['إعدادي', 'ثانوي', 'جامعي', 'دراسات عليا', 'غير ذلك'].map((
          String value,
        ) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedEducationLevel = newValue);
          if (newValue !=
              _getEducationLevelArabic(widget.account.educationLevel)) {
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
              _editTeacher();
              // print(_changedFields.toString());
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
                  child: Text("إنشاء الحساب"),
                ),
        ),
      ),
    ],
  );
}
