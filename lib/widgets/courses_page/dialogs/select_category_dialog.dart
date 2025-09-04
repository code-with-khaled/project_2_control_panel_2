import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/category_service.dart';
import 'package:control_panel_2/models/category_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';

class SelectCategoryDialog extends StatefulWidget {
  final Function(Category?) callback;

  const SelectCategoryDialog({super.key, required this.callback});

  @override
  State<SelectCategoryDialog> createState() => _SelectCategoryDialogState();
}

class _SelectCategoryDialogState extends State<SelectCategoryDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Variables for API integration
  late CategoryService categoryService;
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = true;

  List<Category> get _filteredCategories {
    List<Category> result = _categories;
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = _categories.where((category) {
        final name = category.name.toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query);
      }).toList();
    }

    return result;
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await categoryService.fetchCategories(token);
      setState(() {
        _categories = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    }

    // ignore: avoid_print
    print(_categories);
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    categoryService = CategoryService(apiClient: apiClient);

    _loadCategories();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
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
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.blue))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 25),

                      SearchField(
                        controller: _searchController,
                        hintText: "ابحث عن التصنيفات بالاسم",
                      ),
                      SizedBox(height: 20),

                      // Teachers list
                      if (_filteredCategories.isEmpty)
                        Center(child: Text('لا يوجد تصنيفات'))
                      else
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredCategories.length,
                            itemBuilder: (BuildContext context, int index) {
                              final category = _filteredCategories[index];
                              final isSelected =
                                  _selectedCategory?.id == category.id;

                              return ListTile(
                                title: Text(category.name),

                                leading: isSelected
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : Icon(Icons.category_outlined),
                                tileColor: isSelected ? Colors.blue[50] : null,
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                              );
                            },
                          ),
                        ),

                      if (_selectedCategory != null) SizedBox(height: 16),
                      if (_selectedCategory != null)
                        _buildSelectedTeacherSection(),

                      SizedBox(height: 25),
                      _buildSubmitButton(),
                    ],
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
        "اختر تصنيف الدورة",
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

  Widget _buildSelectedTeacherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التصنيف المحدد:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green),
          ),
          child: Row(
            children: [
              Icon(Icons.category_outlined, color: Colors.green),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCategory!.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          widget.callback(_selectedCategory);
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("تم"),
        ),
      ),
    ],
  );
}
