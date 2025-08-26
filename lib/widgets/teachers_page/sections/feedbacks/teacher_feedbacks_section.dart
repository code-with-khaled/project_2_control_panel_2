import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:control_panel_2/models/teacher_feedback_model.dart';
import 'package:control_panel_2/widgets/other/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TeacherReviewsSection extends StatefulWidget {
  final int id;

  const TeacherReviewsSection({super.key, required this.id});

  @override
  State<TeacherReviewsSection> createState() => _TeacherReviewsSectionState();
}

class _TeacherReviewsSectionState extends State<TeacherReviewsSection> {
  bool _isLoading = false;
  int _feedbackCount = 0;
  double _feedbackAverage = 0.0;
  List<TeacherFeedback> _feedbacks = [];

  // Date formatter instance
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy', 'ar');

  Future<void> _fetchFeedbacks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final result = await _teacherService.fetchTeacherFeedbacks(
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

  late TeacherService _teacherService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _teacherService = TeacherService(apiClient: apiClient);

    _fetchFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _feedbacks.isEmpty
        ? Center(child: Text("لا يوجد مراجعات"))
        : Column(
            mainAxisSize: MainAxisSize.min,
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
              for (var feedback in _feedbacks) _buildReview(feedback),
            ],
          );
  }

  Widget _buildReview(TeacherFeedback feedback) {
    return Container(
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
              RatingStars(rating: feedback.rating),
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
}
