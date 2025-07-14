import 'package:control_panel_2/constants/all_courses.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/widgets/courses_page/course_card.dart';
import 'package:control_panel_2/widgets/courses_page/dialogs/new_course_dialog.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  List<Course> get _filteredCourses {
    // Initial filtering by search query
    List<Course> results = courses.where((course) {
      final name = course.name.toString().toLowerCase();
      final categorization = course.categorization.toString().toLowerCase();
      final teacher = course.teacher.toString().toLowerCase();

      final query = _searchQuery.toLowerCase();
      return name.contains(query) ||
          categorization.contains(query) ||
          teacher.contains(query);
    }).toList();
    return results;
  }

  @override
  void initState() {
    super.initState();
    // Listen for search query changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.homepageBg,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1280), // Max content width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page header with title and create button
                  _buildPageHeader(),
                  SizedBox(height: 25),

                  // Search and filter section
                  _buildSearchSection(),
                  SizedBox(height: 25),

                  // Responsive courses list
                  _buildStudentGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds page header with title and create button
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "إدارة الكورسات",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => NewCourseDialog(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("إنشاء كورس جديد"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "إدارة الكورسات ومتابعة تقدم الطلاب",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  // Builds search and filter controls
  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Expanded(
        child: SearchField(
          controller: _searchController,
          hintText: "ابحث عن الكورس بالاسم أو اسم المدرس أو التصنيف",
        ),
      ),
    );
  }

  Widget _buildStudentGrid() {
    if (_filteredCourses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text('لا توجد كورسات مطابقة للبحث'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: CourseCard(course: _filteredCourses[index]),
        );
      },
    );
  }
}
