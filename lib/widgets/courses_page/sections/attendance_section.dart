import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/models/lecture_model.dart';
import 'package:control_panel_2/widgets/courses_page/sections/attendance/lecture_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceSection extends StatefulWidget {
  final Course course;

  const AttendanceSection({super.key, required this.course});

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  // Variables for API integration
  late CourseService _courseService;

  List<Lecture> _lectures = [
    Lecture(
      id: 1,
      name: "name_1",
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      status: "قائمة",
    ),
    Lecture(
      id: 2,
      name: "name_2",
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      status: "ملغاة",
      reason: "عدم حضور المدرس",
    ),
  ];
  bool _isLoading = true;

  Future<void> _loadLectures() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await _courseService.fetchLectures(
        token,
        widget.course.id!,
      );
      setState(() {
        _lectures += response;
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
    print(_lectures.toString());
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _courseService = CourseService(apiClient: apiClient);

    _loadLectures();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              padding: EdgeInsets.all(20),
              color: Colors.blue,
              strokeWidth: 2,
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildLecturesGrid()],
          );
  }

  Widget _buildLecturesGrid() {
    if (_lectures.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on available width
        const double itemWidth = 270; // Minimum card width
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 2); // Limit between 1-2 columns

        // Build responsive grid of account cards
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final lecture in _lectures)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: LectureCard(lecture: lecture),
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
          'لا يوجد محاضرات',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
