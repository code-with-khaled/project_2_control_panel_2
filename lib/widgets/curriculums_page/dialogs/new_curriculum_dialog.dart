import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewCurriculumDialog extends StatefulWidget {
  const NewCurriculumDialog({super.key});

  @override
  State<NewCurriculumDialog> createState() => _NewCurriculumDialogState();
}

class _NewCurriculumDialogState extends State<NewCurriculumDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _curriculumNameController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // State variables
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  bool _isChecked = true; // Default value is true (apply on all subjects)

  final List<String> _allCourses = [
    'الرياضيات',
    'الفيزياء',
    'الكيمياء',
    'علم الأحياء',
    'اللغة العربية',
    'اللغة الإنجليزية',
    'اللغة الفرنسية',
    'الوطنية',
    'الديانة',
  ];
  final List<String> _selectedSubjects = [];

  // Date picker function
  Future<void> _selectDate(
    BuildContext context,
    bool isStartDate,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          controller.text = DateFormat(
            'MM/dd/yyyy',
          ).format(_selectedStartDate!);
        } else {
          _selectedEndDate = picked;
          controller.text = DateFormat('MM/dd/yyyy').format(_selectedEndDate!);
        }
      });
    }
  }

  void _toggleCourseSelection(String course) {
    setState(() {
      if (_selectedSubjects.contains(course)) {
        _selectedSubjects.remove(course);
      } else {
        _selectedSubjects.add(course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
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

                  // Curriculum Name field
                  _buildCurriculumNameField(),
                  SizedBox(height: 25),

                  _buildDateRow(),
                  SizedBox(height: 25),

                  _buildChosenSubjects(),
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

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "إنشاء كورس جديد",
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

  Widget _buildCurriculumNameField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الاسم الدورة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل اسم الدورة",
        controller: _curriculumNameController,
        // validator: (value) => _validateNotEmpty(value, "الاسم الأول"),
      ),
    ],
  );

  Widget _buildDateRow() => Row(
    children: [
      Expanded(child: _buildStartDate()),
      SizedBox(width: 10),
      Expanded(child: _buildEndDate()),
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
        onTap: () => _selectDate(context, true, _startDateController),
        // validator: _validateDate,
      ),
    ],
  );

  Widget _buildEndDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ الانتهاء *", style: TextStyle(fontWeight: FontWeight.bold)),
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
        onTap: () => _selectDate(context, false, _endDateController),
        // validator: _validateDate,
      ),
    ],
  );

  Widget _buildChosenSubjects() {
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
            "المواد*",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Checkbox(
                value: _isChecked,
                checkColor: Colors.white,
                activeColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                },
              ),
              Text("جميع الكورسات"),
            ],
          ),

          ?_isChecked == false
              ? Column(
                  children: [
                    Divider(),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          childAspectRatio:
                              8, // Width/height ratio for each item
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: _allCourses.length,
                        itemBuilder: (context, index) {
                          final course = _allCourses[index];
                          return Row(
                            children: [
                              Checkbox(
                                value: _selectedSubjects.contains(course),
                                checkColor: Colors.white,
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  _toggleCourseSelection(course);
                                },
                              ),
                              Expanded(
                                child: Text(
                                  course,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                )
              : null,
        ],
      ),
    );
  }

  /// Builds the form submission button
  Widget _buildCreateButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Add form submission logic here
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("إنشاء الدورة"),
        ),
      ),
    ],
  );
}
