import 'package:control_panel_2/widgets/other/nav_button.dart';
import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDiscountDialog extends StatefulWidget {
  const AddDiscountDialog({super.key});

  @override
  State<AddDiscountDialog> createState() => _AddDiscountDialogState();
}

class _AddDiscountDialogState extends State<AddDiscountDialog> {
  // Form key for validation and form state management
  final _formKey = GlobalKey<FormState>();

  // Controllers for managing text input fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // State variables
  DateTime? _selectedDate;
  String _activeFilter = 'جميع المستخدمين'; // Currently selected section

  // Tracks whether the discount applys on all courses
  bool _isChecked = true; // Default value is true (apply on all courses)

  final List<String> _allCourses = [
    'React Fundamentals',
    'JavaScript Advanced',
    'Physics Fundamentals',
    'Data Science',
    'Computer Graphics',
    'Python Basics',
    'Mathematics 101',
    'Web Development',
    'Machine Learning',
    'Database Design',
  ];

  final List<String> _selectedCourses = [
    'Python Basics',
    'Data Science',
    'Database Design',
  ];

  void _toggleCourseSelection(String course) {
    setState(() {
      if (_selectedCourses.contains(course)) {
        _selectedCourses.remove(course);
      } else {
        _selectedCourses.add(course);
      }
    });
  }

  /// Updates the active section filter
  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
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

                  // Discount details section
                  _buildDiscountDetails(),
                  SizedBox(height: 25),

                  _buildApplicableCourses(),
                  SizedBox(height: 25),

                  // Target audience selection section
                  _buildTargetAudience(),
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
          _buildTitleField(),
          SizedBox(height: 25),
          _buildDescriptionField(),
          SizedBox(height: 25),
          _buildDetailsRow(),
        ],
      ),
    );
  }

  /// Builds the title input field
  Widget _buildTitleField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("عنوان الحسم *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل عنوان الحسم",
        controller: _titleController,
        // validator: (value) => _validateNotEmpty(value, "اسم الأب"),
      ),
    ],
  );

  Widget _buildDescriptionField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("شرح عن الحسم *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل شرح بسيط عن الحسم",
        controller: _titleController,
        // validator: (value) => _validateNotEmpty(value, "اسم الأب"),
      ),
    ],
  );

  Widget _buildDetailsRow() => Row(
    children: [
      Expanded(child: _buildFinancialValue()),
      SizedBox(width: 10),
      Expanded(child: _buildAvailabelQuality()),
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
        controller: _titleController,
        // validator: (value) => _validateNotEmpty(value, "اسم الأب"),
      ),
    ],
  );

  Widget _buildAvailabelQuality() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("الكمية المتاحة *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "100",
        controller: _titleController,
        // validator: (value) => _validateNotEmpty(value, "اسم الأب"),
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

  Widget _buildApplicableCourses() {
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
            "الكورسات المطبق عليها *",
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
                                value: _selectedCourses.contains(course),
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

  /// Builds the target audience selection section
  Widget _buildTargetAudience() {
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
            "الفئة المستهدفة",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // Navigation tabs for different sections
          _buildNavigationTabs(),
          SizedBox(height: 20),

          // Dynamic content section
          _buildCurrentSection(),
        ],
      ),
    );
  }

  // Builds navigation tabs for profile sections
  Widget _buildNavigationTabs() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blueGrey[50],
      ),
      child: Row(
        children: [
          // Overview tab
          Expanded(
            child: NavButton(
              navkey: "جميع المستخدمين",
              isActive: _activeFilter == "جميع المستخدمين",
              onTap: () => _setFilter("جميع المستخدمين"),
            ),
          ),

          // Receipts tab
          Expanded(
            child: NavButton(
              navkey: "فلاتر أساسية",
              isActive: _activeFilter == "فلاتر أساسية",
              onTap: () => _setFilter("فلاتر أساسية"),
            ),
          ),

          // Discounts tab
          Expanded(
            child: NavButton(
              navkey: "تحليل بيانات",
              isActive: _activeFilter == "تحليل بيانات",
              onTap: () => _setFilter("تحليل بيانات"),
            ),
          ),

          // Reviews tab
          Expanded(
            child: NavButton(
              navkey: "اختيار يدوي",
              isActive: _activeFilter == "اختيار يدوي",
              onTap: () => _setFilter("اختيار يدوي"),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate content section based on active filter
  Widget _buildCurrentSection() {
    switch (_activeFilter) {
      // case : "فلاتر أساسية"
      //   return ;
      // case : "تحليل بيانات"
      //   return ;
      // case : "اختيار يدوي"
      //   return ;
      default:
        return Text(
          "هذا الحسم سيكون متاحاً لجميع المستخدمين",
          style: TextStyle(color: Colors.grey),
        );
    }
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
          child: Text("إنشاء الحسم"),
        ),
      ),
    ],
  );
}
