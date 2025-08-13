import 'package:control_panel_2/constants/all_teachers.dart';
import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/financial_reports/dialogs/edit_method_dialog.dart';
import 'package:flutter/material.dart';

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
                    label: Flexible(
                      child: Text(
                        "عدد الكورسات",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                    label: Flexible(
                      child: Text(
                        "الراتب على الحصة",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text("60%"),
                            ),
                          ),
                          DataCell(Text("N/A")),
                          DataCell(
                            Text(
                              "1200\$",
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            ElevatedButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) =>
                                    EditMethodDialog(teacher: teacher),
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
}
