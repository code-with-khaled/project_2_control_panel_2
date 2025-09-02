import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/selected_teacher_model.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/select_teacher_dialog.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

class NewCourseDialog extends StatefulWidget {
  final VoidCallback callback;

  const NewCourseDialog({super.key, required this.callback});

  @override
  State<NewCourseDialog> createState() => _NewCourseDialogState();
}

class _NewCourseDialogState extends State<NewCourseDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _coursePriceController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // State variables
  String? _selectedCategory;
  String? _selectedLevel;
  String? _selectedTeacher;
  int? _selectedTeacherId;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Variables for storing the course image
  String? _imageUrl;
  String? _fileName;

  bool _isSubmitting = false;

  String _getLevelId(String level) {
    switch (level) {
      case "متوسط":
        return "2";
      case "متقدم":
        return "3";
      default:
        return "1";
    }
  }

  void _selectTeacher(SelectedTeacher? teacher) {
    if (teacher != null) {
      setState(() {
        _selectedTeacher = teacher.fullName;
        _selectedTeacherId = teacher.id;
      });
    }
  }

  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file!); // This reads the file as a Base64 string

      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageUrl = reader.result as String;
          _fileName = file.name;
        });
      });
    });
  }

  // Date picker functions
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2, now.month, now.day),
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
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime endDate = DateTime(now.year, now.month, now.day + 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: endDate,
      lastDate: DateTime(endDate.year + 3, endDate.month, endDate.day),
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
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _createCourse() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final name = _courseNameController.text.trim();
    final price = _coursePriceController.text.trim();
    final hours = _hoursController.text.trim();
    final description = _courseDescriptionController.text.trim();
    final levelId = _getLevelId(_selectedLevel!);
    final teacherId = _selectedTeacherId;
    final categoryId = 1;
    final startDate = _startDateController.text.trim();
    final endDate = _endDateController.text.trim();

    final course = {
      'translations[ar][name]': name,
      'translations[ar][description]': description,
      'image': _imageUrl!,
      'price': price,
      'number_of_hours': hours,
      'category_id': categoryId.toString(),
      'teacher_id': teacherId.toString(),
      'level_id': levelId,
      'start_date': startDate,
      'end_date': endDate,
    };

    try {
      final token = TokenHelper.getToken();
      await _courseService.createCourse(token, course, _imageUrl, _fileName);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إنشاء الدورة بنجاح')));
        widget.callback();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في إنشاء الدورة'),
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

  // Variables for API integration
  late CourseService _courseService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _courseService = CourseService(apiClient: apiClient);
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

                  // Course Name field
                  // Category's Name field
                  Row(
                    children: [
                      Expanded(child: _buildCourseNameField()),
                      SizedBox(width: 10),
                      Expanded(child: _buildCategoryField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Level's field
                  // Teacher's field
                  Row(
                    children: [
                      Expanded(child: _buildLevelField()),
                      SizedBox(width: 10),
                      Expanded(child: _buildTeacherField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Hourse.No field
                  // Price field
                  Row(
                    children: [
                      Expanded(child: _buildNumberOfHoursField()),
                      SizedBox(width: 10),
                      Expanded(child: _buildPriceField()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Description field
                  _buildDescriptionField(),
                  SizedBox(height: 25),

                  _buildImageSection(),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: _buildStartDate()),
                      SizedBox(width: 10),
                      Expanded(child: _buildEndDate()),
                    ],
                  ),
                  SizedBox(height: 25),

                  // Submit button
                  _buildSubmitButton(),
                ],
              ),
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
        "إنشاء دورة جديد",
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

  Widget _buildCourseNameField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("اسم دورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل اسم دورة",
        controller: _courseNameController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildCategoryField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("التصنيف *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر التصنيف',
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
        items:
            [
              'الرياضيات',
              'العلوم',
              'البرمجة',
              'اللغات',
              'العلوم الإنسانية',
              'الفنون والإبداع',
              'الأعمال والاقتصاد',
              'التحضير للاختبارات',
            ].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedCategory = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );

  Widget _buildLevelField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("مستوى الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: _selectedLevel,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'اختر المستوى',
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
        items: ['مبتدئ', 'متوسط', 'متقدم'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedLevel = newValue);
        },
        // validator: _validateGender,
      ),
    ],
  );

  Widget _buildTeacherField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المدرس *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      InkWell(
        onTap: () => _selectTeacherDialog(),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedTeacher == null
                  ? Text("اختر المدرس", style: TextStyle(fontSize: 16))
                  : Text(
                      _selectedTeacher!,
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

  void _selectTeacherDialog() => showDialog(
    context: context,
    builder: (context) => SelectTeacherDialog(callback: _selectTeacher),
  );

  Widget _buildNumberOfHoursField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("عدد الساعات *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل ساعات الدورة",
        controller: _hoursController,
        prefixIcon: Icon(Icons.timer_outlined, color: Colors.grey.shade600),
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildPriceField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("سعر التسجيل *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل سعر التسجيل",
        controller: _coursePriceController,
        prefixIcon: Icon(Icons.attach_money, color: Colors.grey.shade600),
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildDescriptionField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("وصف دورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل وصف  قصير دورة",
        maxLines: 3,
        controller: _courseDescriptionController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  /// Builds the image upload section with preview capability
  Widget _buildImageSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("صورة الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
          if (_imageUrl != null)
            InkWell(
              onTap: () {
                setState(() {
                  _imageUrl = null;
                });
              },
              child: Icon(Icons.delete_forever, color: Colors.red),
            ),
        ],
      ),
      SizedBox(height: 5),
      InkWell(
        onTap: _pickImage,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: _imageUrl == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                    Text(
                      "اضغط لتحميل الصورة",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(_fileName!, overflow: TextOverflow.ellipsis),
                  ],
                ),
        ),
      ),
    ],
  );

  Widget _buildStartDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ البدء *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      TextFormField(
        controller: _startDateController,
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
        onTap: () => _selectStartDate(context),
        // validator: _validateStartDate,
      ),
    ],
  );

  Widget _buildEndDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ الإنتهاء *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      TextFormField(
        controller: _endDateController,
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
        onTap: () => _selectEndDate(context),
        // validator: _validateEndDate,
      ),
    ],
  );

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid - process data
            _createCourse();
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
                child: Text("إنشاء دورة جديد"),
              ),
      ),
    ],
  );
}
