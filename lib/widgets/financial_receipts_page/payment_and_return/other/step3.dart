import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';

class Step3 extends StatefulWidget {
  final bool isReturn;

  const Step3({super.key, required this.isReturn});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  late TextEditingController _valueController;
  final TextEditingController _reasonController = TextEditingController();

  // State variables
  late int _value;

  // Value functions
  void _increaseValue() {
    setState(() {
      _value += 500;
      _valueController.text = _value.toString();
    });
  }

  void _decreaseValue() {
    if (_value >= 500) {
      setState(() {
        _value -= 500;
        _valueController.text = _value.toString();
      });
    }
  }

  // Validation function
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _value = 0;
    _valueController = TextEditingController(text: _value.toString());
    _valueController.addListener(_updateValueFromController);
  }

  void _updateValueFromController() {
    final text = _valueController.text;
    if (text.isNotEmpty) {
      final newValue = int.tryParse(text) ?? _value;
      if (newValue != _value) {
        setState(() {
          _value = newValue;
        });
      }
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            "خطوة 3: القيمة المالية",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 25),

          _buildFinancialValueField(),

          if (widget.isReturn) _buildReasonField(),
        ],
      ),
    );
  }

  Widget _buildFinancialValueField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "القيمة المالية (\$)",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل القيمة",
        controller: _valueController,
        suffix: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _increaseValue(),
              child: Icon(Icons.arrow_drop_up, size: 20),
            ),
            InkWell(
              onTap: () => _decreaseValue(),
              child: Icon(Icons.arrow_drop_down, size: 20),
            ),
          ],
        ),
        validator: (value) => _validateNotEmpty(value, "القيمة المالية"),
      ),
    ],
  );

  Widget _buildReasonField() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 20),
      Text("سبب الارتجاع", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "اشرح سبب الارتجاع...",
        controller: _reasonController,
        maxLines: 2,
        validator: (value) => _validateNotEmpty(value, "القيمة المالية"),
      ),
    ],
  );
}
