import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:control_panel_2/widgets/search_widgets/search_filter_button.dart';
import 'package:control_panel_2/widgets/students_page/dialogs/add_student_dialog.dart';
import 'package:control_panel_2/widgets/students_page/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

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

  // Pagination variables
  int _currentPage = 1;
  int _totalPages = 1;
  int _perPage = 10;
  int _totalItems = 0;
  final TextEditingController _pageController = TextEditingController();

  // Variables for API integration
  late StudentService _studentService;
  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _studentService = StudentService(apiClient: apiClient);

    _loadStudents();

    // Listen for search query changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _loadStudents({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await _studentService.fetchStudents(token, page: page);
      setState(() {
        _students = response['students'];
        _currentPage = response['pagination']['current_page'];
        _totalPages = response['pagination']['last_page'];
        _perPage = response['pagination']['per_page'];
        _totalItems = response['pagination']['total'];
        _isLoading = false;
        _pageController.text = _currentPage.toString();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تحميل حسابات الطلاب'),
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }

    // ignore: avoid_print
    print(_students);
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      _loadStudents(page: page);
    }
  }

  // Refresh students list (call this after adding/editing or deleting a student)
  void _refreshStudents() {
    _loadStudents(page: _currentPage);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
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

                  if (_isLoading) _buildLoadingState(),

                  if (!_isLoading) ...[
                    // Search and filter section
                    _buildSearchSection(),
                    SizedBox(height: 25),

                    // Student count and pagination info
                    _buildPaginationInfo(),
                    SizedBox(height: 15),

                    // Responsive student grid
                    _buildStudentGrid(),
                    SizedBox(height: 25),

                    // Pagination controls
                    _buildPaginationControls(),
                  ],
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
    showDialog(
      context: context,
      builder: (context) => AddStudentDialog(callback: _refreshStudents),
    );
  }

  // Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      ),
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

  /// Updates the active filter type
  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  // Build pagination info
  Widget _buildPaginationInfo() {
    final startItem = ((_currentPage - 1) * _perPage) + 1;
    final endItem = _currentPage == _totalPages
        ? _totalItems
        : _currentPage * _perPage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "عرض $startItem - $endItem من أصل $_totalItems طالب",
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          "الصفحة $_currentPage من $_totalPages",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  // Builds responsive student grid
  Widget _buildStudentGrid() {
    List<Student> displayedStudents = _students;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      displayedStudents = _students.where((student) {
        final name = student.fullName.toString().toLowerCase();
        final username = student.username.toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || username.contains(query);
      }).toList();
    }

    // Apply sorting
    switch (_activeFilter) {
      case 'الأحدث':
        displayedStudents.sort((a, b) => b.birthDate.compareTo(a.birthDate));
        break;
      case 'أبجدي':
        displayedStudents.sort((a, b) => a.firstName.compareTo(b.firstName));
        break;
      default:
        break;
    }

    if (displayedStudents.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive column count
        const double itemWidth = 270; // Minimum card width
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 4); // Limit between 1-4 columns

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final student in displayedStudents)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: StudentProfile(
                  student: student,
                  callback: _refreshStudents,
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

  // Build pagination controls
  Widget _buildPaginationControls() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // First page button
            IconButton(
              icon: Icon(Icons.first_page),
              onPressed: _currentPage > 1 ? () => _goToPage(1) : null,
            ),
            SizedBox(width: 8),

            // Previous page button
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: _currentPage > 1
                  ? () => _goToPage(_currentPage - 1)
                  : null,
            ),
            SizedBox(width: 16),

            // Page input
            SizedBox(
              width: 40,
              height: 30,
              child: TextField(
                cursorColor: Colors.blue,
                controller: _pageController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  final page = int.tryParse(value) ?? 1;
                  _goToPage(page);
                },
              ),
            ),

            Text(' / $_totalPages', style: TextStyle(fontSize: 16)),
            SizedBox(width: 16),

            // Next page button
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: _currentPage < _totalPages
                  ? () => _goToPage(_currentPage + 1)
                  : null,
            ),
            SizedBox(width: 8),

            // Last page button
            IconButton(
              icon: Icon(Icons.last_page),
              onPressed: _currentPage < _totalPages
                  ? () => _goToPage(_totalPages)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
