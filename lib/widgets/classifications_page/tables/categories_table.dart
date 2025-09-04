import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/category_service.dart';
import 'package:control_panel_2/models/category_model.dart';
import 'package:control_panel_2/widgets/classifications_page/dialogs/edit_category_dialog.dart';
import 'package:flutter/material.dart';

class CategoriesTable extends StatefulWidget {
  final String searchQuery;
  final Function(int, int, int) callback;

  const CategoriesTable({
    super.key,
    required this.searchQuery,
    required this.callback,
  });

  @override
  State<CategoriesTable> createState() => _CategoriesTableState();
}

class _CategoriesTableState extends State<CategoriesTable> {
  final ScrollController _horizontalScrollController = ScrollController();

  bool _isLoading = false;
  bool _isDeleting = false;
  List<Category> _categories = [];

  List<Category> get _filteredCategories {
    if (widget.searchQuery.isEmpty) return _categories;
    final query = widget.searchQuery.toLowerCase();
    return _categories.where((category) {
      return category.name.toString().toLowerCase().contains(query) ||
          category.id.toString().toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await _categoryService.fetchCategories(token);

      setState(() {
        _categories = response;
      });

      int totalCourses = _categories.fold(
        0,
        (sum, category) => sum + category.courses,
      );
      int totalStudents = _categories.fold(
        0,
        (sum, category) => sum + category.students,
      );

      widget.callback(_categories.length, totalCourses, totalStudents);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _refreshCategories() {
    _loadCategories();
  }

  Future<void> _deleteCategory(int id) async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من رغبتك في حذف التصنيف'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final token = TokenHelper.getToken();
      await _categoryService.deleteCategory(token, id);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حذف التصنيف بنجاح')));
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }

    _loadCategories();
  }

  late CategoryService _categoryService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _categoryService = CategoryService(apiClient: apiClient);

    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? _buildLoadingState()
        : _categories.isEmpty
        ? _buildEmptyState()
        : LayoutBuilder(
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
                              'التقييم',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                      rows: _filteredCategories.map((category) {
                        return DataRow(
                          cells: [
                            DataCell(Text(category.name)),

                            DataCell(Text(category.courses.toString())),
                            DataCell(Text(category.students.toString())),

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
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => EditCategoryDialog(
                                        category: category,
                                        callback: _refreshCategories,
                                      ),
                                    ),
                                    icon: Icon(Icons.edit, color: Colors.green),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _deleteCategory(category.id),
                                    icon: _isDeleting
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.red,
                                            ),
                                          )
                                        : Icon(
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

  // Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'لا يوجد تصنيفات',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
