import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
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

  // Pagination variables
  int _currentPage = 1;
  int _totalPages = 1;
  int _perPage = 10;
  int _totalItems = 0;
  final TextEditingController _pageController = TextEditingController();

  // Variables for API integration
  late CourseService _courseService;
  List<Course> _courses = [];
  bool _isLoading = true;

  Future<void> _loadCourses({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await _courseService.fetchCourses(token, page: page);
      setState(() {
        _courses = response['courses'];
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
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    }

    // ignore: avoid_print
    print(_courses);
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      _loadCourses(page: page);
    }
  }

  // Refresh courses list (call this after adding/editing or deleting a course)
  void _refreshCourses() {
    _loadCourses(page: _currentPage);
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

    final apiClient = ApiHelper.getClient();

    _courseService = CourseService(apiClient: apiClient);

    _loadCourses();
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

                  if (_isLoading) _buildLoadingState(),

                  if (!_isLoading) ...[
                    // Search and filter section
                    _buildSearchSection(),
                    SizedBox(height: 25),

                    // Course count and pagination info
                    _buildPaginationInfo(),
                    SizedBox(height: 15),

                    // Responsive courses list
                    _buildCoursesGrid(),
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
                "إدارة الدورات",
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
                  builder: (context) =>
                      NewCourseDialog(callback: _refreshCourses),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("إنشاء دورة جديدة"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "إدارة الدورات ومتابعة تقدم الطلاب",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
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
      child: SearchField(
        controller: _searchController,
        hintText: "ابحث عن الدورة بالاسم أو اسم المدرس أو التصنيف",
      ),
    );
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

  Widget _buildCoursesGrid() {
    List<Course> displayedCourses = _courses;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      displayedCourses = _courses.where((course) {
        final name = course.name.toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query);
      }).toList();
    }

    if (displayedCourses.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const double itemWidth = 350;
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 3);

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final course in displayedCourses)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: CourseCard(course: course, callback: _refreshCourses),
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
          'لا يوجد دورات',
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
