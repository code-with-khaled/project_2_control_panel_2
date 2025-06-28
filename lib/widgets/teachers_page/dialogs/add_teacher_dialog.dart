import 'package:flutter/material.dart';

class AddTeacherDialog extends StatefulWidget {
  const AddTeacherDialog({super.key});

  @override
  State<AddTeacherDialog> createState() => _AddTeacherDialogState();
}

class _AddTeacherDialogState extends State<AddTeacherDialog> {
  final _formKey = GlobalKey<FormState>();

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

                  // First Name and Last Name fields
                  // Row(
                  //   children: [
                  //     Expanded(child: _buildFirstNameField()),
                  //     SizedBox(width: 15),
                  //     Expanded(child: _buildLastNameField()),
                  //   ],
                  // ),
                  SizedBox(height: 25),

                  // Father's Name field
                  // _buildFatherNameField(),
                  SizedBox(height: 25),

                  // Username and Mobile Number fields
                  // Row(
                  //   children: [
                  //     Expanded(child: _buildUsernameField()),
                  //     SizedBox(width: 15),
                  //     Expanded(child: _buildMobileNumberField()),
                  //   ],
                  // ),
                  SizedBox(height: 25),

                  // Gender and Date of Birth fields
                  // Row(
                  //   children: [
                  //     Expanded(child: _buildGenderField()),
                  //     SizedBox(width: 15),
                  //     Expanded(child: _buildDateOfBirthField()),
                  //   ],
                  // ),
                  SizedBox(height: 25),

                  // Profile Image section
                  // _buildProfileImageSection(),

                  // Password fields
                  // Row(
                  //   children: [
                  //     Expanded(child: _buildPasswordField()),
                  //     SizedBox(width: 15),
                  //     Expanded(child: _buildConfirmPasswordField()),
                  //   ],
                  // ),
                  SizedBox(height: 20),

                  // Education Level field
                  // _buildEducationLevelField(),
                  SizedBox(height: 25),

                  // Submit button
                  // _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
