import 'package:control_panel_2/constants/all_students.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:control_panel_2/widgets/search_widgets/search_filter_button.dart';
import 'package:control_panel_2/widgets/students_page/dialogs/add_student_dialog.dart';
import 'package:control_panel_2/widgets/students_page/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Main page for student management system
///
/// Features:
/// - Search and filter student list
/// - Responsive grid layout
/// - Add new student functionality
class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'كل الطلاب'; // Current active filter type

  /// Filters and sorts students based on search query and active filter
  List<Map<String, dynamic>> get _filteredStudents {
    // Initial filtering by search query
    List<Map<String, dynamic>> results = allStudents.where((student) {
      final name = student['name'].toString().toLowerCase();
      final username = student['username'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || username.contains(query);
    }).toList();

    // Apply additional sorting based on active filter
    switch (_activeFilter) {
      case 'الأحدث':
        results.sort((a, b) => b['joinDate'].compareTo(a['joinDate']));
        break;
      case 'أبجدي':
        results.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      default: // 'كل الطلاب' - no additional sorting
        break;
    }

    return results;
  }

  /// Updates the active filter type
  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
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

                  // Responsive student grid
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
                "إدارة الطلاب",
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
                onPressed: () => _showAddStudentDialog(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("إنشاء حساب طالب"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "إدارة ومتابعة تقدم ومعلومات الطلاب",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  // Shows the add student dialog
  void _showAddStudentDialog() {
    showDialog(context: context, builder: (context) => AddStudentDialog());
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout switching
          if (constraints.maxWidth > 600) {
            // Wide layout - horizontal arrangement
            return Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _searchController,
                    hintText: "ابحث عن الطلاب بالاسم أو اسم المستخدم",
                  ),
                ),
                SizedBox(width: 20),
                _buildFilterButtons(),
              ],
            );
          } else {
            // Narrow layout - vertical arrangement
            return Column(
              children: [
                SearchField(
                  controller: _searchController,
                  hintText: "ابحث عن الطلاب بالاسم أو اسم المستخدم",
                ),
                SizedBox(height: 15),
                _buildFilterButtons(),
              ],
            );
          }
        },
      ),
    );
  }

  // Builds filter button set
  Widget _buildFilterButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SearchFilterButton(
          text: "كل الطلاب",
          isActive: _activeFilter == "كل الطلاب",
          onPressed: () => _setFilter("كل الطلاب"),
        ),
        SearchFilterButton(
          text: "الأحدث",
          isActive: _activeFilter == "الأحدث",
          onPressed: () => _setFilter("الأحدث"),
        ),
        SearchFilterButton(
          text: "أبجدي",
          isActive: _activeFilter == "أبجدي",
          onPressed: () => _setFilter("أبجدي"),
        ),
      ],
    );
  }

  // Builds responsive student grid
  Widget _buildStudentGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive column count
        const double itemWidth = 270; // Minimum card width
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 4); // Limit between 1-4 columns

        final students = _filteredStudents;

        if (students.isEmpty) {
          return _buildEmptyState();
        }

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final student in students)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: StudentProfile(
                  name: student['name'],
                  username: student['username'],
                  email: student['email'],
                  joinDate: student['joinDate'],
                ),
              ),
          ],
        );
      },
    );
  }

  // Builds empty state message
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'لا توجد نتائج',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
