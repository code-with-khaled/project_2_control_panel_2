import 'package:control_panel_2/constants/all_teachers.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:control_panel_2/widgets/search_widgets/search_filter_button.dart';
import 'package:control_panel_2/widgets/teachers_page/dialogs/add_teacher_dialog.dart';
import 'package:control_panel_2/widgets/teachers_page/teacher_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'جميع المعلمين';

  /// Filters and sorts teachers based on search query and active filter
  List<Teacher> get _filteredTeachers {
    // Initial filtering by search query
    List<Teacher> results = allTeachers.where((teacher) {
      final name = teacher.fullName.toLowerCase();
      final username = teacher.username.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || username.contains(query);
    }).toList();

    // Apply additional sorting based on active filter
    switch (_activeFilter) {
      case 'الأحدث':
        results.sort((a, b) => b.joinDate.compareTo(a.joinDate));
        break;
      case 'أبجدي':
        results.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      default: // 'جميع المعلمين' - no additional sorting
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.homepageBg,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPageHeader(),
                    const SizedBox(height: 25),
                    _buildSearchSection(),
                    const SizedBox(height: 25),
                    _buildTeacherGrid(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "إدارة المعلمين",
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
                onPressed: _showAddTeacherDialog,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("إنشاء حساب معلم"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "إدارة حسابات وملفات المعلمين",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  void _showAddTeacherDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddTeacherDialog(),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _searchController,
                    hintText: "ابحث عن المعلمين بالاسم أو اسم المستخدم",
                  ),
                ),
                const SizedBox(width: 20),
                _buildFilterButtons(),
              ],
            );
          } else {
            return Column(
              children: [
                SearchField(
                  controller: _searchController,
                  hintText: "ابحث عن المعلمين بالاسم أو اسم المستخدم",
                ),
                const SizedBox(height: 15),
                _buildFilterButtons(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SearchFilterButton(
          text: "جميع المعلمين",
          isActive: _activeFilter == "جميع المعلمين",
          onPressed: () => _setFilter("جميع المعلمين"),
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

  Widget _buildTeacherGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double itemWidth = 270;
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 4);

        final teachers = _filteredTeachers;

        if (teachers.isEmpty) {
          return _buildEmptyState();
        }

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final teacher in teachers)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: TeacherProfile(teacher: teacher),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'لا يوجد معلمون',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
