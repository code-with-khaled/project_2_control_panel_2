import 'package:control_panel_2/constants/all_students.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:control_panel_2/widgets/search_widgets/search_filter_button.dart';
import 'package:control_panel_2/widgets/students_page/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All Students';

  List<Map<String, dynamic>> get _filteredStudents {
    List<Map<String, dynamic>> results = allStudents.where((student) {
      final name = student['name'].toString().toLowerCase();
      final username = student['username'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || username.contains(query);
    }).toList();

    // Apply additional filters
    switch (_activeFilter) {
      case 'Newest':
        results.sort((a, b) => b['joinDate'].compareTo(a['joinDate']));
        break;
      case 'Alphabetical':
        results.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      default: // 'All Students' - no additional sorting
        break;
    }

    return results;
  }

  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and button row (unchanged)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Students Management",
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 10),
                                Text("Create Student Account"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Manage and monitor students progress and information",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  // Updated responsive search container
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Switch between row and column layout based on available width
                        if (constraints.maxWidth > 600) {
                          // Wide layout - everything in one row
                          return Row(
                            children: [
                              Expanded(
                                child: SearchField(
                                  controller: _searchController,
                                  hintText:
                                      "Search students by name, or username",
                                ),
                              ),
                              SizedBox(width: 20),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  SearchFilterButton(
                                    text: "All Students",
                                    isActive: _activeFilter == "All Students",
                                    onPressed: () => _setFilter("All Students"),
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
                              ),
                            ],
                          );
                        } else {
                          // Narrow layout - search field above filters
                          return Column(
                            children: [
                              SearchField(
                                controller: _searchController,
                                hintText:
                                    "Search students by name, or username",
                              ),
                              SizedBox(height: 15),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  SearchFilterButton(
                                    text: "All Students",
                                    isActive: _activeFilter == "All Students",
                                    onPressed: () => _setFilter("All Students"),
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
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate the number of items per row based on available width
                      double itemWidth =
                          270; // Your desired minimum width for each item
                      int itemsPerRow = (constraints.maxWidth / itemWidth)
                          .floor();
                      itemsPerRow = itemsPerRow.clamp(
                        1,
                        4,
                      ); // Set min 1, max 4 items per row

                      final students = _filteredStudents;

                      if (students.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              'No students found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }

                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          for (final student in students)
                            SizedBox(
                              width:
                                  (constraints.maxWidth -
                                      (20 * (itemsPerRow - 1))) /
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
