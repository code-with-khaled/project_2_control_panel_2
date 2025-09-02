import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:control_panel_2/models/selected_teacher_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectTeacherDialog extends StatefulWidget {
  final Function(SelectedTeacher?) callback;

  const SelectTeacherDialog({super.key, required this.callback});

  @override
  State<SelectTeacherDialog> createState() => _SelectTeacherDialogState();
}

class _SelectTeacherDialogState extends State<SelectTeacherDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Variables for API integration
  late TeacherService teachersService;
  List<SelectedTeacher> _teachers = [];
  SelectedTeacher? _selectedTeacher;
  bool _isLoading = true;

  List<SelectedTeacher> get _filteredTeachers {
    List<SelectedTeacher> result = _teachers;
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = _teachers.where((teacher) {
        final name = teacher.fullName.toString().toLowerCase();
        // final username = teacher.username.toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        // return name.contains(query) || username.contains(query);
        return name.contains(query);
      }).toList();
    }

    return result;
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await teachersService.fetchTeachersToSelect(token);
      setState(() {
        _teachers = response;
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
    print(_teachers);
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    teachersService = TeacherService(apiClient: apiClient);

    _loadTeachers();

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
                        hintText: "ابحث عن المعلمين بالاسم أو اسم المستخدم",
                      ),
                      SizedBox(height: 20),

                      // Teachers list
                      if (_filteredTeachers.isEmpty)
                        Center(child: Text('لا يوجد معلمين'))
                      else
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredTeachers.length,
                            itemBuilder: (BuildContext context, int index) {
                              final teacher = _filteredTeachers[index];
                              final isSelected =
                                  _selectedTeacher?.id == teacher.id;

                              return ListTile(
                                title: Text(teacher.fullName),
                                // subtitle: Text(teacher.username),
                                leading: isSelected
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : Icon(Icons.person_outline),
                                tileColor: isSelected ? Colors.blue[50] : null,
                                onTap: () {
                                  setState(() {
                                    _selectedTeacher = teacher;
                                  });

                                  // widget.onMessageChanged(teacher.id);
                                },
                              );
                            },
                          ),
                        ),

                      if (_selectedTeacher != null) SizedBox(height: 16),
                      if (_selectedTeacher != null)
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
        "اختر مدرس الدورة",
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
          'المعلم المحدد:',
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
              Icon(Icons.person, color: Colors.green),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedTeacher!.fullName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    // Text('@${_selectedTeacher!.username}'),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedTeacher = null;
                  });

                  // widget.onMessageChanged(null);
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
          widget.callback(_selectedTeacher);
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
