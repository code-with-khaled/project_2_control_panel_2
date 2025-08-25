import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:control_panel_2/widgets/search_widgets/search_filter_button.dart';
import 'package:control_panel_2/widgets/teachers_page/dialogs/add_teacher_dialog.dart';
import 'package:control_panel_2/widgets/teachers_page/teacher_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'جميع المعلمين';

  // Pagination variables
  int _currentPage = 1;
  int _totalPages = 1;
  int _perPage = 10;
  int _totalItems = 0;
  final TextEditingController _pageController = TextEditingController();

  // Variables for API integration
  late TeacherService teachersService;
  List<Teacher> _teachers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    teachersService = TeacherService(apiClient: apiClient);

    _loadTeachers();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _loadTeachers({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await teachersService.fetchTeachers(token, page: page);
      setState(() {
        _teachers = response['teachers'];
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
    print(_teachers);
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      _loadTeachers(page: page);
    }
  }

  // Refresh students list (call this after adding/editing or deleting a student)
  void _refreshTeachers() {
    _loadTeachers(page: _currentPage);
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
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(),
                  const SizedBox(height: 25),

                  if (_isLoading) _buildLoadingState(),

                  if (!_isLoading) ...[
                    _buildSearchSection(),
                    const SizedBox(height: 25),

                    // Student count and pagination info
                    _buildPaginationInfo(),
                    SizedBox(height: 15),

                    // Responsive teacher grid
                    _buildTeacherGrid(),
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
      builder: (context) => AddTeacherDialog(callback: _refreshTeachers),
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

  Widget _buildTeacherGrid() {
    List<Teacher> displayedTeachers = _teachers;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      displayedTeachers = _teachers.where((teacher) {
        final name = teacher.fullName.toString().toLowerCase();
        final username = teacher.username.toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || username.contains(query);
      }).toList();
    }

    // Apply sorting
    switch (_activeFilter) {
      case 'أبجدي':
        displayedTeachers.sort((a, b) => a.firstName.compareTo(b.firstName));
        break;
      default:
        break;
    }

    if (displayedTeachers.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const double itemWidth = 270;
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 4);

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final teacher in displayedTeachers)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: TeacherProfile(
                  teacher: teacher,
                  callback: _refreshTeachers,
                ),
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
