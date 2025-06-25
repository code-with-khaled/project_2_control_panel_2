import 'package:control_panel_2/constants/all_teachers.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:control_panel_2/widgets/search_widgets/search_filter_button.dart';
import 'package:control_panel_2/widgets/students_page/student_profile.dart';
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
  String _activeFilter = 'All Teachers'; // Current active filter type

  /// Filters and sorts teachers based on search query and active filter
  List<Map<String, dynamic>> get _filteredTeachers {
    // Initial filtering by search query
    List<Map<String, dynamic>> results = allTeachers.where((teacher) {
      final name = teacher['name'].toString().toLowerCase();
      final username = teacher['username'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || username.contains(query);
    }).toList();

    // Apply additional sorting based on active filter
    switch (_activeFilter) {
      case 'Newest':
        results.sort((a, b) => b['joinDate'].compareTo(a['joinDate']));
        break;
      case 'Alphabetical':
        results.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      default: // 'All Teachers' - no additional sorting
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
    // Listen for search query changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                  // Responsive teacher grid
                  _buildTeacherGrid(),
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
                "Teachers Management",
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
                // onPressed: () => _showAddTeacherDialog(),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("Create Teacher Account"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "Manage teachers accounts and profiles",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  // Shows the add teacher dialog
  // void _showAddTeacherDialog() {
  //   showDialog(context: context, builder: (context) => AddTeacherDialog());
  // }

  // Builds search and filter controls
  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
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
                    hintText: "Search teachers by name, or username",
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
                  hintText: "Search teachers by name, or username",
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
          text: "All Teachers",
          isActive: _activeFilter == "All Teachers",
          onPressed: () => _setFilter("All Teachers"),
        ),
        SearchFilterButton(
          text: "Newest",
          isActive: _activeFilter == "Newest",
          onPressed: () => _setFilter("Newest"),
        ),
        SearchFilterButton(
          text: "Alphabetical",
          isActive: _activeFilter == "Alphabetical",
          onPressed: () => _setFilter("Alphabetical"),
        ),
      ],
    );
  }

  // Builds responsive teacher grid
  Widget _buildTeacherGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive column count
        const double itemWidth = 270; // Minimum card width
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 4); // Limit between 1-4 columns

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
                child: StudentProfile(
                  name: teacher['name'],
                  username: teacher['username'],
                  email: teacher['email'],
                  joinDate: teacher['joinDate'],
                ),
              ),
          ],
        );
      },
    );
  }

  // Builds responsive teacher grid
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'No Teachers found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
