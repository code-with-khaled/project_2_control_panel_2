import 'package:control_panel_2/constants/all_students.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseEnrollmentsDialog extends StatefulWidget {
  final Course course;

  const CourseEnrollmentsDialog({super.key, required this.course});

  @override
  State<CourseEnrollmentsDialog> createState() =>
      _CourseEnrollmentsDialogState();
}

class _CourseEnrollmentsDialogState extends State<CourseEnrollmentsDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();

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
            // child: SingleChildScrollView(
            //   padding: EdgeInsets.all(20),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Header section with close button
            //       _buildHeader(),
            //       SizedBox(height: 20),

            //       _buildSearchSection(),
            //       SizedBox(height: 25),

            //       _buildSearchSection2(),
            //       SizedBox(height: 25),

            //       Flexible(child: StudentsTable()),
            //     ],
            //   ),
            // ),
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Header section with close button
                _buildHeader(),
                SizedBox(height: 20),

                _buildSearchSection(),
                SizedBox(height: 25),

                _buildSearchSection2(),
                SizedBox(height: 25),

                Expanded(child: StudentsTable()),
              ],
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
        Flexible(
          child: Text(
            "إدارة التسجيل - ${widget.course.name}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
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

  // Builds search and filter controls
  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              controller: _searchController,
              hintText: "ابحث عن الطالب بالاسم أو المعرف",
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.person_add_alt),
                  SizedBox(width: 10),
                  Text("إضافة طالب"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection2() {
    return SearchField(
      controller: _searchController,
      hintText: "ابحث عن الطلاب المنتسبين ",
    );
  }
}

class StudentsTable extends StatefulWidget {
  const StudentsTable({super.key});

  @override
  State<StudentsTable> createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable> {
  // State variables
  String? _selectedStatus;

  final ScrollController _horizontalScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _horizontalScroll,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalScroll,
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DataTable(
            columnSpacing: 20.0,
            columns: [
              DataColumn(
                label: Text(
                  'اسم الطالب',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'معرف الطالب',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'البريد',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'الحالة',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'تاريخ التسجيل',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(label: Text('')),
            ],
            rows: allStudents.map((student) {
              _selectedStatus = student['status'];
              return DataRow(
                cells: [
                  DataCell(Text(student['name'])),
                  DataCell(Text("${student['id']}")),
                  DataCell(Text(student['email'])),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(student['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        student['status'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      DateFormat(
                        'MMM dd, yyyy',
                        'ar',
                      ).format(student['joinDate']),
                    ),
                  ),
                  DataCell(
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      items: ['تثبيت', 'تسجيل', 'انسحاب'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() => _selectedStatus = newValue);
                      },
                      // validator: _validateStatus,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'تثبيت':
        return Colors.green;
      case 'تسجيل':
        return Colors.blue;
      case 'انسحاب':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
