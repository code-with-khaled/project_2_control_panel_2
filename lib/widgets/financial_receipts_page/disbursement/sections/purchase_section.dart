import 'package:control_panel_2/widgets/financial_receipts_page/disbursement/other/setp3.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';

class PurchaseSection extends StatefulWidget {
  const PurchaseSection({super.key});

  @override
  State<PurchaseSection> createState() => _PurchaseSectionState();
}

class _PurchaseSectionState extends State<PurchaseSection> {
  final TextEditingController _descriptionController = TextEditingController();

  // State variables
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_readyToBuildValue);
  }

  void _readyToBuildValue() {
    if (_descriptionController.text.isNotEmpty) {
      setState(() {
        _isReady = true;
      });
    } else {
      setState(() {
        _isReady = false;
      });
    }
  }

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
                "خطوة 2: التفاصيل",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),

              _buildDescriptionField(),
            ],
          ),
        ),
        SizedBox(height: 20),

        if (_isReady) DisbursementSetp3(),
      ],
    );
  }

  Widget _buildDescriptionField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الشرح", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "تفاصيل عن عملية الشراء...",
        controller: _descriptionController,
        maxLines: 2,
      ),
    ],
  );
}
