import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';

class SpecificTeacherSection extends StatefulWidget {
  final Function(int?) onMessageChanged;

  const SpecificTeacherSection({super.key, required this.onMessageChanged});

  @override
  State<SpecificTeacherSection> createState() => _SpecificTeacherSectionState();
}

class _SpecificTeacherSectionState extends State<SpecificTeacherSection> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Variables for API integration
  late TeacherService teachersService;
  List<Teacher> _teachers = [];
  Teacher? _selectedTeacher;
  bool _isLoading = true;

  List<Teacher> get _filteredTeachers {
    List<Teacher> result = _teachers;
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = _teachers.where((teacher) {
        final name = teacher.fullName.toString().toLowerCase();
        final username = teacher.username.toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || username.contains(query);
      }).toList();
    }

    return result;
  }

  Future<void> _loadTeachers({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await teachersService.fetchTeachers(token, page: page);
      setState(() {
        _teachers = response['teachers'];
        _isLoading = false;
      });
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

    // ignore: avoid_print
    print(_teachers);
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

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
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue,
              padding: EdgeInsets.all(20),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      final isSelected = _selectedTeacher?.id == teacher.id;

                      return ListTile(
                        title: Text(teacher.fullName),
                        subtitle: Text(teacher.username),
                        leading: isSelected
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.person_outline),
                        tileColor: isSelected ? Colors.blue[50] : null,
                        onTap: () {
                          setState(() {
                            _selectedTeacher = teacher;
                          });

                          widget.onMessageChanged(teacher.id);
                        },
                      );
                    },
                  ),
                ),

              if (_selectedTeacher != null) SizedBox(height: 16),
              if (_selectedTeacher != null) _buildSelectedTeacherSection(),
            ],
          );
  }

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

                    Text('@${_selectedTeacher!.username}'),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedTeacher = null;
                  });

                  widget.onMessageChanged(null);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
