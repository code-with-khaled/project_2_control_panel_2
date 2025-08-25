import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final dynamic initialValue;
  final int? maxLines;
  final bool? obsecure;
  final Icon? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.initialValue,
    this.maxLines,
    this.obsecure,
    this.prefixIcon,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      maxLines: maxLines,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(6),
        ),
        errorBorder: OutlineInputBorder(
          // Add error border
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // Add focused error border
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(6),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
      obscureText: obsecure ?? false,
      validator: validator,
    );
  }
}
