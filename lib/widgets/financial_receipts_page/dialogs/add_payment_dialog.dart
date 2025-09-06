import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/receipt_service.dart';
import 'package:control_panel_2/models/selected_course_model.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/select_student_dialog.dart';
import 'package:control_panel_2/widgets/financial_receipts_page/payment_and_return/other/step3.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/select_course_dialog.dart';
import 'package:flutter/material.dart';

class AddPaymentDialog extends StatefulWidget {
  final VoidCallback callback;

  const AddPaymentDialog({super.key, required this.callback});

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  // State variables
  Student? _selectedStudent;
  String? _selectedCourse;
  int? _selectedCourseId;
  int _paymentAmount = 0;

  bool _isSubmitting = false;

  void _selectStudent(Student? student) {
    if (student != null) {
      setState(() {
        _selectedStudent = student;
      });
    }
  }

  void _selectCourse(SelectedCourse? category) {
    if (category != null) {
      setState(() {
        _selectedCourse = category.name;
        _selectedCourseId = category.id;
      });
    }
  }

  void _onStep3ValueChanged(int amount) {
    setState(() {
      _paymentAmount = amount;
    });
  }

  Future<void> _createReceipt() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = TokenHelper.getToken();
      final receipt = {
        "student_id": _selectedStudent!.id,
        "receiptable_type": "course",
        "receiptable_id": _selectedCourseId,
        "amount": _paymentAmount,
        "type": "payment",
      };

      await _receiptService.createReceipt(token, receipt);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إنشاء الإيصال بنجاح')));
        widget.callback();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في إنشاء الإيصال'),
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

  late ReceiptService _receiptService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _receiptService = ReceiptService(apiClient: apiClient);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with close button
                _buildHeader(),
                SizedBox(height: 25),

                _buildStep1(),
                SizedBox(height: 20),

                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "إنشاء إيصال دفع",
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

  Widget _buildStep1() => Container(
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
          "خطوة 1: المعلومات الأساسية",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 25),

        _buildStudentField(),
        SizedBox(height: 20),

        _buildCourseField(),
        SizedBox(height: 20),

        if (_selectedCourse != null && _selectedStudent != null)
          Step3(onValueChanged: _onStep3ValueChanged),
      ],
    ),
  );

  Widget _buildStudentField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("اختر طالب", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      InkWell(
        onTap: () => _selectStudentDialog(),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedStudent == null
                  ? Text("اضغط لاختيار طالب", style: TextStyle(fontSize: 16))
                  : Text(
                      _selectedStudent!.fullName,
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

  void _selectStudentDialog() => showDialog(
    context: context,
    builder: (context) => SelectStudentDialog(callback: _selectStudent),
  );

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

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("إلغاء"),
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {
          _createReceipt();
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
                child: Text("إنشاء الإيصال"),
              ),
      ),
    ],
  );

  // Widget _buildStep2() {
  //   switch (_selectedType) {
  //     case 'شهادة':
  //       return CertificateSection(isReturn: false);
  //     case 'كورس':
  //       return CourseSection(isReturn: false);
  //     case 'رحلة':
  //       return TripSection(isReturn: false);
  //     case 'كتاب':
  //       return BookSection(isReturn: false);
  //     case 'مناهج':
  //       return CurriculumSection(isReturn: false);
  //     default:
  //       return Text("");
  //   }
  // }
}
