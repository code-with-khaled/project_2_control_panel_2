import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/discount_service.dart';
import 'package:control_panel_2/models/selected_course_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/select_course_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDiscountDialog extends StatefulWidget {
  final VoidCallback callback;

  const AddDiscountDialog({super.key, required this.callback});

  @override
  State<AddDiscountDialog> createState() => _AddDiscountDialogState();
}

class _AddDiscountDialogState extends State<AddDiscountDialog> {
  // Form key for validation and form state management
  final _formKey = GlobalKey<FormState>();

  // Controllers for managing text input fields
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // State variables
  String? _selectedCourse;
  int? _selectedCourseId;
  DateTime? _selectedDate;
  bool _isSubmitting = false;
  String _discountType = 'percent';

  void _selectCourse(SelectedCourse? category) {
    if (category != null) {
      setState(() {
        _selectedCourse = category.name;
        _selectedCourseId = category.id;
      });
    }
  }

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, now.month, now.day),
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
    }
  }

  Future<void> _createDiscount() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = TokenHelper.getToken();

      final discount = {
        'discountable_id': _selectedCourseId,
        'discountable_type': 'course',
        'type': _discountType,
        'value': _valueController.text.trim(),
        'expiration_date': _selectedDate!.toIso8601String(),
      };

      await _discountService.createDiscount(token, discount);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إنشاء الحسم بنجاح')));
        widget.callback();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في إنشاء الحسم'),
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

  late DiscountService _discountService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();
    _discountService = DiscountService(apiClient: apiClient);
  }

  // Validator for discount value based on type
  String? _validateDiscountValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال القيمة';
    }

    final numericValue = double.tryParse(value);
    if (numericValue == null) {
      return 'يرجى إدخال رقم صحيح';
    }

    if (_discountType == 'percentage' &&
        (numericValue <= 0 || numericValue > 100)) {
      return 'النسبة يجب أن تكون بين 1 و 100';
    }

    if (_discountType == 'fixed' && numericValue <= 0) {
      return 'القيمة يجب أن تكون أكبر من الصفر';
    }

    return null;
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
                  _buildHeader(),
                  SizedBox(height: 25),

                  // Discount details section
                  _buildDiscountDetails(),
                  SizedBox(height: 25),

                  // Form submission button
                  _buildCreateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the dialog header with title and close button
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إنشاء حسم جديد",
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
  }

  /// Builds the advertisement details section containing:
  Widget _buildDiscountDetails() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تفاصيل الحسم",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),

          _buildCourseField(),
          SizedBox(height: 25),

          _buildDiscountTypeSelector(),
          SizedBox(height: 25),

          _buildDetailsRow(),
        ],
      ),
    );
  }

  Widget _buildCourseField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      InkWell(
        onTap: () => _selectCourseDialog(),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedCourse == null
                  ? Text("اختر الدورة", style: TextStyle(fontSize: 16))
                  : Text(
                      _selectedCourse!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
              Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        ),
      ),
    ],
  );

  void _selectCourseDialog() => showDialog(
    context: context,
    builder: (context) => SelectCourseDialog(callback: _selectCourse),
  );

  // Build discount type selector
  Widget _buildDiscountTypeSelector() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("نوع الحسم *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: RadioListTile<String>(
              title: Text("نسبة مئوية (%)"),
              value: 'percent',
              activeColor: Colors.green,
              groupValue: _discountType,
              onChanged: (value) {
                setState(() {
                  _discountType = value!;
                  _formKey.currentState?.validate();
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),
          SizedBox(width: 5),

          Expanded(
            child: RadioListTile<String>(
              title: Text("قيمة مقطوعة"),
              value: 'amount',
              activeColor: Colors.blue,
              groupValue: _discountType,
              onChanged: (value) {
                setState(() {
                  _discountType = value!;
                  _formKey.currentState?.validate();
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildDetailsRow() => Row(
    children: [
      Expanded(child: _buildFinancialValue()),
      SizedBox(width: 10),

      Expanded(child: _buildExpirationDate()),
    ],
  );

  Widget _buildFinancialValue() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        _discountType == 'percent' ? "النسبة المئوية %" : "القيمة المقطوعة \$",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 2),
      CustomTextField(
        hintText: _discountType == 'percent' ? "مثال: 30" : "مثال: 5000",
        controller: _valueController,
        validator: _validateDiscountValue,
      ),
    ],
  );

  Widget _buildExpirationDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ الإنتهاء *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          hintText: 'yyyy-mm-dd',
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى اختيار تاريخ';
          }
          return null;
        },
      ),
    ],
  );

  /// Builds the form submission button
  Widget _buildCreateButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Add form submission logic here
            if (_selectedCourse != null) {
              if (_selectedCourse!.isNotEmpty) {
                _createDiscount();
              }
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  title: Text('خطأ في إنشاء الحسم'),
                  content: Text('يرجى اخيار دورة'),
                  actions: [
                    TextButton(
                      child: Text(
                        'موافق',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            }
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
                child: Text("إنشاء الحسم"),
              ),
      ),
    ],
  );
}
