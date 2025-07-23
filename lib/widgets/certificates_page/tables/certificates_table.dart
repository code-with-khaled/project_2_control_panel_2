import 'package:control_panel_2/constants/all_certificates.dart';
import 'package:control_panel_2/models/certificate_model.dart';
import 'package:flutter/material.dart';

class CertificatesTable extends StatefulWidget {
  final String searchQuery;

  const CertificatesTable({super.key, required this.searchQuery});

  @override
  State<CertificatesTable> createState() => _CertificatesTableState();
}

class _CertificatesTableState extends State<CertificatesTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  String? _selectedStatus;
  String? _selectedType;

  List<Certificate> get _filteredCertificates {
    if (widget.searchQuery.isEmpty) return certificates;
    final query = widget.searchQuery.toLowerCase();
    return certificates.where((certificate) {
      return certificate.student.toString().toLowerCase().contains(query);
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
                columnSpacing: 20,
                horizontalMargin: 20,
                columns: [
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 150),
                      child: Text(
                        'اسم الطالب',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        'الكورس',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        'المعلم',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 120),
                      child: Text(
                        'تاريخ الانتهاء',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        'نوع الشهادة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        'الحالة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "الإجرائات",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
                rows: _filteredCertificates.map((certificate) {
                  _selectedStatus = certificate.status;
                  _selectedType = certificate.type;
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          certificate.student,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(Text(certificate.course)),
                      DataCell(Text(certificate.teacher)),
                      DataCell(Text(certificate.date)),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(_selectedType!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _selectedType!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: _selectedType == "عربية"
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
                            color: _getStatusColor(_selectedStatus!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _selectedStatus!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              certificate.status == 'قيد الانتظار'
                                  ? ElevatedButton(
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.print_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 5),
                                          Text("تمت طباعتها"),
                                        ],
                                      ),
                                    )
                                  : Text(""),
                            ],
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
      },
    );
  }

  Color _getTypeColor(String status) {
    return status == 'عربية' ? Colors.black : Colors.grey.shade200;
  }

  Color _getStatusColor(String status) {
    return status == 'قيد الانتظار' ? Colors.red : Colors.green;
  }
}
