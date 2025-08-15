import 'dart:ui';

// import 'package:control_panel_2/pages/home_page.dart';
import 'package:control_panel_2/pages/reset_password_page.dart';
import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables
  bool _obsecure = true;
  String _selectedRole = 'manager'; // Default selection

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CustomColors.homepageBg,
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
                        _buildUsernameField(),
                        SizedBox(height: 20),
                        _buildPasswordField(),
                        SizedBox(height: 20),
                        _buildRoleSelection(),
                        SizedBox(height: 25),
                        _buildLoginButton(),
                        SizedBox(height: 10),
                        _buildPasswordEdits(),
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

  Widget _buildPasswordField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("كلمة المرور *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل كلمة المرور",
        controller: _passwordController,
        maxLines: 1,
        obsecure: _obsecure,
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
        validator: _validatePassword,
      ),
    ],
  );

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("نوع الحساب *", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('مدير', style: TextStyle(fontSize: 13)),
                value: 'manager',
                groupValue: _selectedRole,
                activeColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('موظف إداري', style: TextStyle(fontSize: 13)),
                value: 'administrative',
                groupValue: _selectedRole,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('محاسب', style: TextStyle(fontSize: 13)),
                value: 'accountant',
                groupValue: _selectedRole,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Add form submission logic here
            }
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => MyHomePage()),
            // );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text("تسجيل دخول"),
          ),
        ),
      ),
    ],
  );

  Widget _buildPasswordEdits() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HoverUnderlineText(
          text: "نسيت كلمة المرور؟",
          onTap: () {
            Navigator.push(
              context,
              (MaterialPageRoute(
                builder: (context) => ResetPasswordPage(forget: true),
              )),
            );
          },
        ),
        HoverUnderlineText(
          text: "تغيير كلمة المرور",
          onTap: () {
            Navigator.push(
              context,
              (MaterialPageRoute(
                builder: (context) => ResetPasswordPage(forget: false),
              )),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------

class HoverUnderlineText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const HoverUnderlineText({
    required this.text,
    required this.onTap,
    super.key,
  });

  @override
  State<HoverUnderlineText> createState() => _HoverUnderlineTextState();
}

class _HoverUnderlineTextState extends State<HoverUnderlineText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Text(
              widget.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          if (_isHovered)
            Positioned(
              bottom: -1.0, // Controls distance from text
              left: 0,
              right: 0,
              child: Container(height: 1.5, color: Colors.black),
            ),
        ],
      ),
    );
  }
}
