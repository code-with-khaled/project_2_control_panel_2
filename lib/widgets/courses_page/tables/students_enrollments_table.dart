import 'package:flutter/material.dart';
import 'package:control_panel_2/constants/all_students.dart';
import 'package:intl/intl.dart';

class StudentsEnrollmentsTable extends StatefulWidget {
  final String searchQuery;
  const StudentsEnrollmentsTable({super.key, required this.searchQuery});

  @override
  State<StudentsEnrollmentsTable> createState() =>
      _StudentsEnrollmentsTableState();
}

class _StudentsEnrollmentsTableState extends State<StudentsEnrollmentsTable> {
  // State variables
  String? _selectedStatus;

  final ScrollController _horizontalScroll = ScrollController();

  List<Map<String, dynamic>> get _filteredStudents {
    if (widget.searchQuery.isEmpty) {
      return allStudents;
    }

    final query = widget.searchQuery;

    return allStudents.where((student) {
      final name = student['name'].toString().toLowerCase();
      final id = student['id'].toString().toLowerCase();

      return name.contains(query) || id.contains(query);
    }).toList();
  }

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
            rows: _filteredStudents.map((student) {
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
                    SizedBox(
                      width: 114,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
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
                          items: ['تثبيت', 'تسجيل', 'انسحاب'].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue;
                              student['status'] = newValue;
                            });
                          },
                          // validator: _validateStatus,
                        ),
                      ),
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
