import 'dart:ui';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/services/auth_service.dart';
import 'package:control_panel_2/pages/login_screen.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State variables
  bool _obsecure = true;
  bool _codeSent = false;
  bool _verifiedCode = false;
  String? otpCode;
  bool _isSending = false;
  bool _isVerifying = false;
  bool _isResetting = false;

  void _showPassword() {
    setState(() {
      _obsecure = !_obsecure;
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

  // APIs
  Future<void> _sendOTP() async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      await _authService.sendOTP(_usernameController.text.trim());
      setState(() {
        _codeSent = true;
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في إرسال رمز التحقق'),
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
          _isSending = false;
        });
      }
    }
  }

  Future<void> _verifyOTP() async {
    if (_isVerifying) return;

    if (otpCode == null || otpCode!.isEmpty) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في التحقق'),
            content: Text('يجب إدخال رمز التحقق كاملاً'),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      await _authService.verifyOTP(_usernameController.text.trim(), otpCode!);
      setState(() {
        _verifiedCode = true;
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في التحقق من الرمز'),
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
          _isVerifying = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_isResetting) return;

    setState(() {
      _isResetting = true;
    });

    try {
      await _authService.resetPassword(
        _usernameController.text.trim(),
        otpCode!,
        _passwordController.text,
      );
      setState(() {
        _verifiedCode = true;
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في إعادة تعيين كلمة المرور'),
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
          _isResetting = false;
        });
      }
    }
  }

  late AuthService _authService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _authService = AuthService(apiClient: apiClient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Solid color or gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Blur layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(
              color: Colors.white.withValues(
                alpha: 0.1,
              ), // Optional frosted tint
            ),
          ),

          Form(
            key: _formKey,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 540),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "مرحباً بك",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),

                        Text(
                          "أدخل معلومات حسابك لتصل للوحة تحكم مسار",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(height: 30),

                        if (!_codeSent && !_verifiedCode) _buildCodeNotSent(),

                        if (_codeSent && !_verifiedCode) _buildCodeIsSent(),

                        if (_verifiedCode) _buildSetNewPassword(),

                        SizedBox(height: 20),

                        _buildBackToLoginButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeNotSent() => Column(
    children: [
      Text(
        "إعادة تعيين كلمة المرور",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 5),

      Text(
        "أدخل اسم المستخدم الخص بك لإرسال رمز التحقق لك",
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ),
      SizedBox(height: 30),

      _buildUsernameField(),
      SizedBox(height: 20),

      _buildResetButton(),
    ],
  );

  Widget _buildCodeIsSent() => Column(
    children: [
      Text(
        "أدخل رمز التحقق",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 5),

      Text(
        "تم إرسال رمز التحقق للرقم الخاص بـ: ${_usernameController.text}",
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ),
      SizedBox(height: 30),
      _buildOTP(),
      SizedBox(height: 20),
      _buildVerifyButton(),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          HoverUnderlineText(
            text: "إدخال اسم المستخدم مجدداً؟",
            onTap: () => setState(() {
              _codeSent = false;
            }),
          ),
        ],
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

  Widget _buildOTP() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: OTPTextField(
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 40,
            style: TextStyle(fontSize: 17),
            onChanged: (_) {},
            onCompleted: (pin) {
              setState(() {
                otpCode = pin;
              });
            },
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );

  Widget _buildResetButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _sendOTP();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: _isSending
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text("إرسال رمز التحقق"),
          ),
        ),
      ),
    ],
  );

  Widget _buildVerifyButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            _verifyOTP();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: _isVerifying
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text("التحقق من الرمز"),
          ),
        ),
      ),
    ],
  );

  Widget _buildSetNewPassword() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildNewPasswordField(),
      SizedBox(height: 20),

      _buildConfirmNewPasswordField(),
      SizedBox(height: 20),

      _buildUpdatePasswordButton(),
    ],
  );

  Widget _buildNewPasswordField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "كلمة المرور الجديدة *",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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

  Widget _buildConfirmNewPasswordField() => Column(
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

  Widget _buildUpdatePasswordButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Add form submission logic here
              _resetPassword();
              // Navigator.pop(context);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text("تعديل كلمة المرور"),
          ),
        ),
      ),
    ],
  );

  Widget _buildBackToLoginButton() => Row(
    children: [
      Expanded(
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 21.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            "العودة لتسجيل الدخول",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    ],
  );
}
