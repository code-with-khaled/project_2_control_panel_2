import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/student_service.dart';
import 'package:control_panel_2/models/student_feedback_model.dart';
import 'package:control_panel_2/widgets/other/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FeedbacksSection extends StatefulWidget {
  final int id;

  const FeedbacksSection({super.key, required this.id});

  @override
  State<FeedbacksSection> createState() => _FeedbacksSectionState();
}

class _FeedbacksSectionState extends State<FeedbacksSection> {
  bool _isLoading = false;
  int _feedbackCount = 0;
  double _feedbackAverage = 0.0;
  List<StudentFeedback> _feedbacks = [];

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

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _studentService = StudentService(apiClient: apiClient);

    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "رياكت المتقدم", // "React Advanced"
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat('').format(
                                  feedback.date,
                                ), // "6/5/2025" (Arabic numerals)
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                feedback
                                    .body, // "Excellent course with great examples!"
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          RatingStars(rating: feedback.rating),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          );
  }
}
