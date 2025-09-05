import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/category_model.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/models/selected_teacher_model.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/select_category_dialog.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/select_teacher_dialog.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

class EditCourseDialog extends StatefulWidget {
  final VoidCallback callback;
  final Course course;

  const EditCourseDialog({
    super.key,
    required this.course,
    required this.callback,
  });

  @override
  State<EditCourseDialog> createState() => _EditCourseDialogState();
}

class _EditCourseDialogState extends State<EditCourseDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _coursePriceController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // State variables
  String? _selectedCategory;
  // ignore: unused_field
  int? _selectedCategoryId;
  String? _selectedLevel;
  String? _selectedTeacher;
  // ignore: unused_field
  int? _selectedTeacherId;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Variables for storing the course image
  String? _imageUrl;
  String? _fileName;

  bool _isEditing = false;

  // ignore: unused_element
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

  void _selectCategory(Category? category) {
    if (category != null) {
      setState(() {
        _selectedCategory = category.name;
        _selectedCategoryId = category.id;
      });
      _checkCategoryChange(category.name);
    }
  }

  void _selectTeacher(SelectedTeacher? teacher) {
    if (teacher != null) {
      setState(() {
        _selectedTeacher = teacher.fullName;
        _selectedTeacherId = teacher.id;
      });
      _checkTeacherChange(teacher.fullName);
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

  Future<void> _editCourse() async {
    if (_isEditing || !_hasChanges) return;

    setState(() {
      _isEditing = true;
    });

    try {
      final token = TokenHelper.getToken();
      await _courseService.updateCourse(
        token,
        widget.course.id!,
        _changedFields,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تعديل معلومات الدورة بنجاح')),
        );
        widget.callback();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تعديل الدورة'),
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
          _isEditing = false;
        });
      }
    }
  }

  late CourseService _courseService;

  @override
  void initState() {
    super.initState();

    _courseNameController.text = widget.course.name;
    _selectedCategory = widget.course.categoryName;
    _selectedLevel = widget.course.level;
    _selectedTeacher = widget.course.teacher.fullName;
    _hoursController.text = widget.course.numberOfHours.toString();
    _coursePriceController.text = widget.course.price.toString();
    _courseDescriptionController.text = widget.course.description;

    _startDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(widget.course.startDate);
    _endDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(widget.course.endDate);
    _selectedStartDate = widget.course.startDate;
    _selectedEndDate = widget.course.endDate;

    final apiClient = ApiHelper.getClient();
    _courseService = CourseService(apiClient: apiClient);

    _addControllerListeners();
  }

  final Map<String, String> _changedFields = {};
  // ignore: unused_field
  bool _hasChanges = false;

  void _addControllerListeners() {
    _courseNameController.addListener(() {
      if (_courseNameController.text != widget.course.name) {
        _changedFields['translations[ar][name]'] = _courseNameController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('translations[ar][name]');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _courseDescriptionController.addListener(() {
      if (_courseDescriptionController.text != widget.course.description) {
        _changedFields['translations[ar][description]'] =
            _courseDescriptionController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('translations[ar][description]');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _hoursController.addListener(() {
      if (_hoursController.text != widget.course.numberOfHours) {
        _changedFields['number_of_hours'] = _hoursController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('number_of_hours');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _coursePriceController.addListener(() {
      if (_coursePriceController.text != widget.course.price.toString()) {
        _changedFields['price'] = _coursePriceController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('price');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _levelController.addListener(() {
      if (_levelController.text != widget.course.level) {
        _changedFields['level'] = _levelController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('level');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _startDateController.addListener(() {
      final originalStartDate = DateFormat(
        'yyyy-MM-dd',
      ).format(widget.course.startDate);
      if (_startDateController.text != originalStartDate) {
        _changedFields['start_date'] = _startDateController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('start_date');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });

    _endDateController.addListener(() {
      final originalEndDate = DateFormat(
        'yyyy-MM-dd',
      ).format(widget.course.endDate);
      if (_endDateController.text != originalEndDate) {
        _changedFields['end_date'] = _endDateController.text;
        _hasChanges = true;
      } else {
        _changedFields.remove('end_date');
        _hasChanges = _changedFields.isNotEmpty;
      }
    });
  }

  void _checkTeacherChange(String? newTeacher) {
    final originalTeacher = widget.course.teacher.fullName;
    if (newTeacher != originalTeacher) {
      _changedFields['teacher_id'] = _selectedTeacherId.toString();
      _hasChanges = true;
    } else {
      _changedFields.remove('teacher_id');
      _hasChanges = _changedFields.isNotEmpty;
    }
  }

  void _checkCategoryChange(String? newCategory) {
    final originalCategory = widget.course.categoryName;
    if (newCategory != originalCategory) {
      _changedFields['category_id'] = _selectedCategoryId.toString();
      _hasChanges = true;
    } else {
      _changedFields.remove('category_id');
      _hasChanges = _changedFields.isNotEmpty;
    }
  }

  void _checkLevelChange(String? newLevel) {
    final originalLevel = widget.course.level;
    if (newLevel != originalLevel) {
      _changedFields['level'] = _getLevelId(newLevel!);
      _hasChanges = true;
    } else {
      _changedFields.remove('level');
      _hasChanges = _changedFields.isNotEmpty;
    }
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
      Text("اسم الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل اسم الدورة",
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
      InkWell(
        onTap: () => _selectCategoryDialog(),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedCategory == null
                  ? Text("اختر التصنيف", style: TextStyle(fontSize: 16))
                  : Text(
                      _selectedCategory!,
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

  void _selectCategoryDialog() => showDialog(
    context: context,
    builder: (context) => SelectCategoryDialog(callback: _selectCategory),
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
          _checkLevelChange(newValue);
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
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل سعر التسجيل",
        controller: _coursePriceController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildDescriptionField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("وصف الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      CustomTextField(
        hintText: "أدخل وصف  قصير للدورة",
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
      SizedBox(height: 5),
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
      SizedBox(height: 5),
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
            _editCourse();
            // print(_changedFields.toString());
          }
        },
        child: _isEditing
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
                child: Text("حفظ التعديلات"),
              ),
      ),
    ],
  );
}
