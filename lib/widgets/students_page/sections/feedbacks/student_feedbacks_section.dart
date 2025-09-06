import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_feedback_model.dart';
import 'package:control_panel_2/widgets/other/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentFeedbacksSection extends StatefulWidget {
  final int id;

  const StudentFeedbacksSection({super.key, required this.id});

  @override
  State<StudentFeedbacksSection> createState() =>
      _StudentFeedbacksSectionState();
}

class _StudentFeedbacksSectionState extends State<StudentFeedbacksSection> {
  bool _isLoading = false;
  int _feedbackCount = 0;
  double _feedbackAverage = 0.0;
  List<StudentFeedback> _feedbacks = [
    StudentFeedback(
      body: "body",
      date: DateTime.now(),
      rating: 3,
      student: FeedbackStudent(
        id: 1,
        firstName: "firstName",
        lastName: "lastName",
      ),
    ),
  ];

  // Date formatter instance
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final result = await _studentService.fetchStudentFeedbacks(
        token,
        widget.id,
      );

      _feedbacks = result['feedbacks'];
      _feedbackCount = result['count'];
      _feedbackAverage = result['average'];
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  late StudentService _studentService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _studentService = StudentService(apiClient: apiClient);

    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue,
              padding: EdgeInsets.all(20),
            ),
          )
        : _feedbacks.isEmpty
        ? Center(child: Text("لا يوجد مراجعات"))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "عدد المراجعات: $_feedbackCount",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 5),
                      Text("متوسط التقييم"),
                      SizedBox(width: 5),
                      Text(_feedbackAverage.toString()),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              Wrap(
                runSpacing: 10,
                children: [
                  for (var feedback in _feedbacks)
                    _buildStudentFeedback(feedback),
                ],
              ),
            ],
          );
  }

  Widget _buildStudentFeedback(StudentFeedback feedback) => Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              feedback.student.fullName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            RatingStars(rating: feedback.rating.toInt()),
          ],
        ),
        SizedBox(height: 10),

        Text(feedback.body),
        SizedBox(height: 9),

        Text(
          _dateFormatter.format(feedback.date),
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    ),
  );
}
