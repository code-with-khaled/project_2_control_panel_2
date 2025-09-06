import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/teacher_service.dart';
import 'package:control_panel_2/models/teacher_stat_mode.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Displays teacher statistics dashboard including:
/// - Enrollment metrics cards (responsive layout)
/// - Enrollment trends visualization
/// - Revenue chart with monthly breakdown
class TeacherStatPanelSection extends StatefulWidget {
  final int id;

  const TeacherStatPanelSection({super.key, required this.id});

  @override
  State<TeacherStatPanelSection> createState() =>
      _TeacherStatPanelSectionState();
}

class _TeacherStatPanelSectionState extends State<TeacherStatPanelSection> {
  bool _isLoading = false;

  late TeacherStat _teacherStat;

  // Calculate confirmed students percentage
  double get _confirmedPercentage {
    if (_teacherStat.totalEnrollments == 0) return 0;
    return (_teacherStat.confirmedEnrollments / _teacherStat.totalEnrollments) *
        100;
  }

  // Calculate withdrawn students percentage
  double get _withdrawnPercentage {
    if (_teacherStat.totalEnrollments == 0) return 0;
    return (_teacherStat.withdrawnEnrollments / _teacherStat.totalEnrollments) *
        100;
  }

  // Calculate month-over-month growth percentage
  double get _monthlyGrowthPercentage {
    if (_teacherStat.lastMonthEnrollments == 0) {
      return _teacherStat.thisMonthEnrollments > 0 ? 100 : 0;
    }
    return ((_teacherStat.thisMonthEnrollments -
                _teacherStat.lastMonthEnrollments) /
            _teacherStat.lastMonthEnrollments) *
        100;
  }

  Future<void> _fetchStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      _teacherStat = await _teacherService.fetchTeacherStatistics(
        token,
        widget.id,
      );
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

    final apiClient = ApiHelper.getClient();
    _teacherService = TeacherService(apiClient: apiClient);

    _fetchStats();
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
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive metrics cards section
              LayoutBuilder(
                builder: (context, constraints) {
                  // Switch between horizontal (wide) and vertical (narrow) layout
                  if (constraints.maxWidth > 600) {
                    return Row(
                      children: [
                        Expanded(child: _buildTotalEnrollments()),
                        SizedBox(width: 15),
                        Expanded(child: _buildRegisteredStudents()),
                        SizedBox(width: 15),
                        Expanded(child: _buildDropoutStudents()),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTotalEnrollments(),
                        SizedBox(height: 10),
                        _buildRegisteredStudents(),
                        SizedBox(height: 10),
                        _buildDropoutStudents(),
                      ],
                    );
                  }
                },
              ),

              SizedBox(height: 10),
              _buildEnrollmentTrends(), // Enrollment trends visualization
              // Revenue chart section
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Revenue header
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.attach_money),
                        SizedBox(width: 3),
                        Text(
                          "الإيرادات المحققة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Revenue summary
                    // Revenue summary
                    Text(
                      '${_teacherStat.totalRevenue.toStringAsFixed(0)} ر.س', // ← New formatted text
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "إجمالي الإيرادات المحققة خلال الشهر",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    SizedBox(height: 10),

                    // Monthly revenue bar chart
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: _getMaxRevenue() + 100,
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() < _monthKeys.length) {
                                    final monthKey = _monthKeys[value.toInt()];
                                    final monthNumber = int.parse(
                                      monthKey.split('-')[1],
                                    );
                                    final monthNames = [
                                      '',
                                      'يناير',
                                      'فبراير',
                                      'مارس',
                                      'أبريل',
                                      'مايو',
                                      'يونيو',
                                      'يوليو',
                                      'أغسطس',
                                      'سبتمبر',
                                      'أكتوبر',
                                      'نوفمبر',
                                      'ديسمبر',
                                    ];
                                    return Text(monthNames[monthNumber]);
                                  }
                                  return Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(_monthKeys.length, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY:
                                      _teacherStat
                                          .monthlyRevenues[_monthKeys[index]] ??
                                      0,
                                  width: 30,
                                  color: Colors.blue[400]!,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  // Helper method to get the available month keys (always 4)
  List<String> get _monthKeys {
    final allKeys = _teacherStat.monthlyRevenues.keys.toList();
    // Sort to ensure chronological order
    allKeys.sort();
    return allKeys;
  }

  double _getMaxRevenue() {
    if (_teacherStat.monthlyRevenues.isEmpty) return 1000;

    final maxValue = _teacherStat.monthlyRevenues.values.reduce(
      (a, b) => a > b ? a : b,
    );
    return maxValue > 0 ? maxValue * 1.2 : 1000; // Add 20% padding
  }

  /// Builds total enrollments metric card
  Widget _buildTotalEnrollments() {
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.group_outlined, size: 20, color: Colors.green),
              SizedBox(width: 7),
              Text(
                "إجمالي التسجيلات",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            _teacherStat.totalEnrollments.toString(),
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            _monthlyGrowthPercentage >= 0
                ? "+${_monthlyGrowthPercentage.toStringAsFixed(0)}% منذ الشهر الماضي"
                : "${_monthlyGrowthPercentage.toStringAsFixed(0)}% منذ الشهر الماضي",
            style: TextStyle(
              color: _monthlyGrowthPercentage >= 0 ? Colors.green : Colors.red,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds registered students metric card
  Widget _buildRegisteredStudents() {
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.push_pin_outlined, size: 20, color: Colors.blue),
              SizedBox(width: 7),
              Text(
                "الطلاب المثبتة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            _teacherStat.confirmedEnrollments.toString(),
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            "${_confirmedPercentage.toStringAsFixed(0)}% نسبة المثبتين",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// Builds dropout students metric card
  Widget _buildDropoutStudents() {
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.person_remove_outlined, size: 20, color: Colors.red),
              SizedBox(width: 7),
              Text(
                "الطلاب المنسحبين",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            _teacherStat.withdrawnEnrollments.toString(),
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            "${_withdrawnPercentage.toStringAsFixed(0)}% نسبة المنسحبين",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// Builds enrollment trends visualization
  Widget _buildEnrollmentTrends() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up),
              SizedBox(width: 7),
              Text(
                "اتجاهات التسجيل",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("هذا الشهر"),
              Text(_teacherStat.thisMonthEnrollments.toString()),
            ],
          ),
          SizedBox(height: 3),
          EvaluationBar(
            rating: _teacherStat.thisMonthEnrollments.toDouble(),
            maxRating: _getMaxEnrollmentValue(),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("الشهر السابق"),
              Text(_teacherStat.lastMonthEnrollments.toString()),
            ],
          ),
          SizedBox(height: 3),
          EvaluationBar(
            rating: _teacherStat.lastMonthEnrollments.toDouble(),
            maxRating: _getMaxEnrollmentValue(),
          ),
        ],
      ),
    );
  }

  double _getMaxEnrollmentValue() {
    final maxValue =
        _teacherStat.thisMonthEnrollments > _teacherStat.lastMonthEnrollments
        ? _teacherStat.thisMonthEnrollments
        : _teacherStat.lastMonthEnrollments;
    return maxValue > 0 ? maxValue.toDouble() * 1.2 : 10.0;
  }
}

/// Custom progress bar for visualizing enrollment trends
class EvaluationBar extends StatefulWidget {
  final double? rating;
  final double? maxRating;

  const EvaluationBar({super.key, this.rating, this.maxRating});

  @override
  EvaluationBarState createState() => EvaluationBarState();
}

class EvaluationBarState extends State<EvaluationBar> {
  double maxRating = 8; // Maximum possible value for normalization

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(5),
      value: widget.maxRating != null && widget.maxRating! > 0
          ? widget.rating! / widget.maxRating!
          : 0,
      minHeight: 8,
      backgroundColor: Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
    );
  }
}
