import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpecificStudentSection extends StatefulWidget {
  final Function(int?) onMessageChanged;

  const SpecificStudentSection({super.key, required this.onMessageChanged});

  @override
  State<SpecificStudentSection> createState() => _SpecificStudentSectionState();
}

class _SpecificStudentSectionState extends State<SpecificStudentSection> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Variables for API integration
  late StudentService studentService;
  List<Student> _students = [];
  Student? _selectedStudent;
  bool _isLoading = true;

  List<Student> get _filteredStudents {
    List<Student> result = _students;
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = _students.where((student) {
        final name = student.fullName.toString().toLowerCase();
        final username = student.username.toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || username.contains(query);
      }).toList();
    }

    return result;
  }

  Future<void> _loadStudents({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await studentService.fetchStudents(token, page: page);
      setState(() {
        _students = response['students'];
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
    print(_students);
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    studentService = StudentService(apiClient: apiClient);

    _loadStudents();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchField(
                controller: _searchController,
                hintText: "ابحث عن الطلاب بالاسم أو اسم المستخدم",
              ),
              SizedBox(height: 20),

              // Students list
              if (_filteredStudents.isEmpty)
                Center(child: Text('لا يوجد طلاب'))
              else
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredStudents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final student = _filteredStudents[index];
                      final isSelected = _selectedStudent?.id == student.id;

                      return ListTile(
                        title: Text(student.fullName),
                        subtitle: Text(student.username),
                        leading: isSelected
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.person_outline),
                        tileColor: isSelected ? Colors.blue[50] : null,
                        onTap: () {
                          setState(() {
                            _selectedStudent = student;
                          });

                          widget.onMessageChanged(student.id);
                        },
                      );
                    },
                  ),
                ),

              if (_selectedStudent != null) SizedBox(height: 16),
              if (_selectedStudent != null) _buildSelectedStudentSection(),
            ],
          );
  }

  Widget _buildSelectedStudentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الطالب المحدد:',
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
                      _selectedStudent!.fullName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text('@${_selectedStudent!.username}'),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedStudent = null;
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
