import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/discount_service.dart';
import 'package:control_panel_2/models/discount_model.dart';
import 'package:control_panel_2/models/selected_course_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/select_course_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDiscountDialog extends StatefulWidget {
  final Discount discount;
  final VoidCallback callback;

  const EditDiscountDialog({
    super.key,
    required this.discount,
    required this.callback,
  });

  @override
  State<EditDiscountDialog> createState() => _EditDiscountDialogState();
}

class _EditDiscountDialogState extends State<EditDiscountDialog> {
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
  late String _discountType;

  void _selectCourse(SelectedCourse? course) {
    if (course != null) {
      setState(() {
        _selectedCourse = course.name;

        if (course.id != widget.discount.course.id) {
          _changedFields['course_id'] = course.id;
        } else {
          _changedFields.remove('course_id');
        }

        _selectedCourseId = course.id;

        _updateHasChanges();
      });
    }
  }

  void _setDiscountType(String? newType) {
    if (newType != null && newType != _discountType) {
      setState(() {
        _discountType = newType;
        _changedFields['type'] = newType;
        _updateHasChanges();

        // Trigger validation when type changes
        _formKey.currentState?.validate();
      });
    } else if (newType == widget.discount.type) {
      _changedFields.remove('type');
      _updateHasChanges();
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

  // Validator for discount value based on type
  String? _validateDiscountValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال القيمة';
    }

    final numericValue = double.tryParse(value);
    if (numericValue == null) {
      return 'يرجى إدخال رقم صحيح';
    }

    if (_discountType == 'percent' &&
        (numericValue <= 0 || numericValue > 100)) {
      return 'النسبة يجب أن تكون بين 1 و 100';
    }

    if (_discountType == 'amount' && numericValue <= 0) {
      return 'القيمة يجب أن تكون أكبر من الصفر';
    }

    return null;
  }

  Future<void> _editDiscount() async {
    if (_isSubmitting || !_hasChanges) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = TokenHelper.getToken();

      final Map<String, dynamic> payload = {};

      if (_changedFields.containsKey('value')) {
        payload['value'] = double.parse(_changedFields['value']);
      }

      if (_changedFields.containsKey('expiration_date')) {
        payload['expiration_date'] = _changedFields['expiration_date'];
      }

      if (_changedFields.containsKey('course_id')) {
        payload['course_id'] = _changedFields['course_id'];
      }

      if (_changedFields.containsKey('type')) {
        payload['type'] = _changedFields['type'];
      }

      await _discountService.editDiscount(token, _selectedCourseId!, payload);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم تعديل معلومات الحسم بنجاح')));
        widget.callback();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تعديل الحسم'),
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

    _discountType = widget.discount.type == "نسبة مئوية" ? "percent" : "amount";
    _valueController.text = widget.discount.value.toString();
    _dateController.text = widget.discount.expirationDate;
    _selectedDate = DateTime.parse(widget.discount.expirationDate);

    _selectedCourse = widget.discount.course.name;
    _selectedCourseId = widget.discount.course.id!;

    _addControllerListeners();

    final apiClient = ApiHelper.getClient();
    _discountService = DiscountService(apiClient: apiClient);
  }

  final Map<String, dynamic> _changedFields = {};
  bool _hasChanges = false;

  void _addControllerListeners() {
    // Listener for value field
    _valueController.addListener(() {
      if (_valueController.text != widget.discount.value.toString()) {
        _changedFields['value'] = _valueController.text;
      } else {
        _changedFields.remove('value');
      }
      _updateHasChanges();
    });

    // Listener for date field
    _dateController.addListener(() {
      final newDateStr = _dateController.text;
      final originalDateStr = widget.discount.expirationDate;

      if (newDateStr != originalDateStr) {
        _changedFields['expiration_date'] = newDateStr;
      } else {
        _changedFields.remove('expiration_date');
      }
      _updateHasChanges();
    });
  }

  // Helper method to update the _hasChanges flag
  void _updateHasChanges() {
    setState(() {
      _hasChanges = _changedFields.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();

    super.dispose();
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
              onChanged: _setDiscountType,
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
              onChanged: _setDiscountType,
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
      Text("القيمة المالية *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "50",
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
          hintText: 'mm/dd/yyyy',
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
        // validator: _validateDate,
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
            _editDiscount();
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
                child: Text("تعديل الحسم"),
              ),
      ),
    ],
  );
}
