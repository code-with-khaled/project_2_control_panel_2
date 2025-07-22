import 'package:control_panel_2/constants/all_caregories.dart';
import 'package:control_panel_2/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoriesTable extends StatefulWidget {
  final String searchQuery;
  const CategoriesTable({super.key, required this.searchQuery});

  @override
  State<CategoriesTable> createState() => _CategoriesTableState();
}

class _CategoriesTableState extends State<CategoriesTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  String? _selectedStatus;

  List<Category> get _filteredCategories {
    if (widget.searchQuery.isEmpty) return categories;
    final query = widget.searchQuery.toLowerCase();
    return categories.where((category) {
      return category.name.toString().toLowerCase().contains(query) ||
          category.id.toString().toLowerCase().contains(query);
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
                        'التصنيف',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        'الحالة',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        'الكورسات',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 120),
                      child: Text(
                        'عدد الطلاب',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        'العائدات',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        'التقييم',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(label: Text("")),
                ],
                rows: _filteredCategories.map((category) {
                  _selectedStatus = category.status;
                  return DataRow(
                    cells: [
                      DataCell(Text(category.name)),
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
                              color: _selectedStatus == "فعال"
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(category.courses.toString())),
                      DataCell(Text(category.students.toString())),
                      DataCell(Text("\$${category.revenue}")),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(category.rating.toString()),
                            SizedBox(width: 5),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.yellow.shade700,
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.pie_chart),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.edit, color: Colors.green),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
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

  Color _getStatusColor(String status) {
    return status == 'فعال' ? Colors.black : Colors.grey.shade200;
  }
}
