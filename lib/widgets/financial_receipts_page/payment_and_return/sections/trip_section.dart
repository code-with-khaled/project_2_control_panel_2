import 'package:control_panel_2/widgets/financial_receipts_page/payment_and_return/other/step3.dart';
import 'package:flutter/material.dart';

class TripSection extends StatefulWidget {
  final bool isReturn;

  const TripSection({super.key, required this.isReturn});

  @override
  State<TripSection> createState() => _TripSectionState();
}

class _TripSectionState extends State<TripSection> {
  // State variables
  String? _selectedTrip;

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
                "خطوة 2: تحديد الرحلة",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),

              _buildTripField(),
            ],
          ),
        ),
        SizedBox(height: 20),

        if (_selectedTrip != null) Step3(isReturn: widget.isReturn),
      ],
    );
  }

  Widget _buildTripField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الرحلة", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedTrip,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر الرحلة',
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
        items: [''].map((value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedTrip = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );
}
