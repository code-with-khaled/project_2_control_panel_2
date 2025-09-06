import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';

class SelectStudentDialog extends StatefulWidget {
  final Function(Student?) callback;

  const SelectStudentDialog({super.key, required this.callback});

  @override
  State<SelectStudentDialog> createState() => _SelectStudentDialogState();
}

class _SelectStudentDialogState extends State<SelectStudentDialog> {
  Student? _student;

  _selectStudent(Student? student) {
    setState(() {
      _student = student;
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 25),

                StudentSelection(onMessageChanged: _selectStudent),

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
        "اختر الطالب",
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

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          widget.callback(_student);
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

class StudentSelection extends StatefulWidget {
  final Function(Student?) onMessageChanged;

  const StudentSelection({super.key, required this.onMessageChanged});

  @override
  State<StudentSelection> createState() => _StudentSelectionState();
}

class _StudentSelectionState extends State<StudentSelection> {
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
    print(_students);
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

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

                          widget.onMessageChanged(student);
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
