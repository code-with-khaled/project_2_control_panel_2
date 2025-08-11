import 'package:control_panel_2/constants/all_teachers.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FinancialReportsPage extends StatefulWidget {
  const FinancialReportsPage({super.key});

  @override
  State<FinancialReportsPage> createState() => _FinancialReportsPageState();
}

class _FinancialReportsPageState extends State<FinancialReportsPage> {
  // Controllers for all form fields
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // State variables
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

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

  @override
  void initState() {
    super.initState();

    // Initialize end date (today)
    _selectedEndDate = DateTime.now();
    _endDateController.text = DateFormat(
      'MM/dd/yyyy',
    ).format(_selectedEndDate!);

    // Initialize start date (Jan 1 of current year)
    _selectedStartDate = DateTime(DateTime.now().year, 1, 1);
    _startDateController.text = DateFormat(
      'MM/dd/yyyy',
    ).format(_selectedStartDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.homepageBg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page header with title and create button
                _buildPageHeader(),
                SizedBox(height: 25),

                _buildReportPeriod(),
                SizedBox(height: 25),

                _buildCertificates(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds page header
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "التقارير المالية",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "إدارة نسب المدرسين وروابهم، حساب الذمم المالية، وعرض تقارير مالية",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildReportPeriod() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_outlined),
                      SizedBox(width: 5),
                      Text(
                        "حساب الفترة للذمة",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "اختر مجال بين تاريخين لحساب الذمم",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 20,
            children: [
              Text("من:"),
              SizedBox(width: 10),
              SizedBox(width: 160, child: _buildStartDate()),
              SizedBox(width: 20),
              Text("إلى:"),
              SizedBox(width: 10),
              SizedBox(width: 160, child: _buildEndDate()),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calculate_outlined),
                    SizedBox(width: 10),
                    Text("حساب"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartDate() => TextFormField(
    controller: _startDateController,
    decoration: InputDecoration(
      hintText: 'mm/dd/yyyy',
      suffixIcon: Icon(Icons.calendar_month_outlined, size: 18),
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
  );

  Widget _buildEndDate() => TextFormField(
    controller: _endDateController,
    decoration: InputDecoration(
      hintText: 'mm/dd/yyyy',
      suffixIcon: Icon(Icons.calendar_month_outlined, size: 18),
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
  );

  Widget _buildCertificates() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.description_outlined),
                      SizedBox(width: 5),
                      Text(
                        "جدول النسب والرواتب",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "إدارة نسب المدرسين ورواتبهم على الحصة الواحدة",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          SearchField(
            controller: _searchController,
            hintText: "إبحث عن المدرس بالاسم...",
            onChanged: (value) => setState(() {}),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TeacherCommissionTable(
                  searchQuery: _searchController.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TeacherCommissionTable extends StatefulWidget {
  final String searchQuery;

  const TeacherCommissionTable({super.key, required this.searchQuery});

  @override
  State<TeacherCommissionTable> createState() => _TeacherCommissionTableState();
}

class _TeacherCommissionTableState extends State<TeacherCommissionTable> {
  final ScrollController _horizontalScrollController = ScrollController();

  List<Teacher> get _filteredTeachers {
    if (widget.searchQuery.isEmpty) return allTeachers;
    final query = widget.searchQuery.toLowerCase();
    return allTeachers.where((teacher) {
      return teacher.fullName.toString().toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DataTable(
                // ignore: deprecated_member_use
                dataRowHeight: 60,
                columnSpacing: 20,
                horizontalMargin: 20,
                columns: [
                  DataColumn(
                    label: Text(
                      "اسم المدرس",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "عدد الكورسات",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "طريقة الدفع",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "نسبة العمولة",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "الراتب على الحصة",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "الذمة المالية",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "الإجراء",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
                rows: _filteredTeachers
                    .map(
                      (teacher) => DataRow(
                        cells: [
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  teacher.fullName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  teacher.username,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text("5")),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _getTypeColor("عمولة"),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "عمولة",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: "عمولة" == "عمولة"
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text("60%")),
                          DataCell(Text("N/A")),
                          DataCell(Text("1200\$")),
                          DataCell(
                            ElevatedButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) =>
                                    _buildEditMethodDialog(teacher),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                backgroundColor: Colors.white,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(
                                "تعديل الطريقة",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getTypeColor(String status) {
    return status == 'عمولة' ? Colors.black : Colors.grey.shade200;
  }

  Widget _buildEditMethodDialog(Teacher teacher) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    backgroundColor: Colors.white,
    insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 600,
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

              _buildTeacherInfo(teacher),

              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),

              _buildPaymentMethod(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "تحديد طريقة الدفع",
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

  Widget _buildTeacherInfo(Teacher teacher) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "معلومات المدرس",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teacher.fullName,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              teacher.username,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Row(children: [Text("2 كورسات"), Text("  •  "), Text("43 طالب")]),
          ],
        ),
      ),
    ],
  );

  Widget _buildPaymentMethod() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [],
  );
}
