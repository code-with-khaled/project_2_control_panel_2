import 'package:control_panel_2/constants/all_certificates.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/other/step3.dart';
import 'package:flutter/material.dart';

class CertificateSection extends StatefulWidget {
  const CertificateSection({super.key});

  @override
  State<CertificateSection> createState() => _CertificateSectionState();
}

class _CertificateSectionState extends State<CertificateSection> {
  // State variables
  String? _selectedCertificate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "خطوة 2: تحديد الشهادة",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),

              _buildCertificateField(),
            ],
          ),
        ),
        SizedBox(height: 20),

        if (_selectedCertificate != null) Step3(),
      ],
    );
  }

  Widget _buildCertificateField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الشهادة", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedCertificate,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر الشهادة',
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
        items: certificates.map((value) {
          return DropdownMenuItem<String>(
            value: value.course,
            child: Text(value.course),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedCertificate = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );
}
