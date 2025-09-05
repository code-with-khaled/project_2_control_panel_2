import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/selected_course_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';

class SelectCourseDialog extends StatefulWidget {
  final Function(SelectedCourse?) callback;

  const SelectCourseDialog({super.key, required this.callback});

  @override
  State<SelectCourseDialog> createState() => _SelectCourseDialogState();
}

class _SelectCourseDialogState extends State<SelectCourseDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Variables for API integration
  late CourseService courseService;
  List<SelectedCourse> _courses = [];
  SelectedCourse? _selectedCourse;
  bool _isLoading = true;

  List<SelectedCourse> get _filteredCourses {
    List<SelectedCourse> result = _courses;
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = _courses.where((course) {
        final name = course.name.toString().toLowerCase();
        final teacherName = course.teacher.fullName.toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || teacherName.contains(query);
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
      final response = await courseService.fetchCoursesToSelect(token);
      setState(() {
        _courses = response;
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
    print(_courses);
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    courseService = CourseService(apiClient: apiClient);

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
                        hintText: "ابحث عن الدورات بالاسم أو اسم المدرس",
                      ),
                      SizedBox(height: 20),

                      // Teachers list
                      if (_filteredCourses.isEmpty)
                        Center(child: Text('لا يوجد دورات'))
                      else
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredCourses.length,
                            itemBuilder: (BuildContext context, int index) {
                              final course = _filteredCourses[index];
                              final isSelected =
                                  _selectedCourse?.id == course.id;

                              return ListTile(
                                title: Text(course.name),
                                subtitle: Text(course.teacher.fullName),
                                leading: isSelected
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : Icon(Icons.person_outline),
                                tileColor: isSelected ? Colors.blue[50] : null,
                                onTap: () {
                                  setState(() {
                                    _selectedCourse = course;
                                  });
                                },
                              );
                            },
                          ),
                        ),

                      if (_selectedCourse != null) SizedBox(height: 16),
                      if (_selectedCourse != null)
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
        "اختر الدورة",
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
          'الدورة المحددة:',
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
                      _selectedCourse!.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text('${_selectedCourse!.teacher.fullName}'),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedCourse = null;
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
          widget.callback(_selectedCourse);
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
