import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TeacherStatPanelSection extends StatelessWidget {
  const TeacherStatPanelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout switching
            if (constraints.maxWidth > 600) {
              // Wide layout - horizontal arrangement
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
        _buildEnrollmentTrends(),

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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_money),
                  SizedBox(width: 3),
                  Text(
                    "الإيرادات المحققة",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "\$5000",
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
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    // 1. Add axis bounds
                    minY: 0,
                    maxY: 2500,
                    // 2. Configure titles properly
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
                            final moths = ['شباط', 'آذار', 'نيسان', 'أيار'];
                            return Text(moths[value.toInt()]);
                          },
                        ),
                      ),
                    ),

                    // 3. Add border/grid config
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey[300]!),
                    ),

                    // 4. Bar groups with proper spacing
                    barGroups: [
                      for (int i = 0; i < 4; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: 500 * (i + 1) as double,
                              width: 66,
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.blue,
                            ),
                          ],
                          barsSpace: 4,
                        ),
                    ],
                    // 5. Add baseline (optional)
                    baselineY: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
            "286",
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            "+12% منذ الشهر الماضي",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

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
            "244",
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            "88% نسبة المثبتين",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

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
                "الطلاب المثبتة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "22",
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            "12% نسبة المنسحبين",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

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
            children: [Text("هذا الشهر"), Text("89 تسجيل")],
          ),
          SizedBox(height: 3),
          EvaluationBar(rating: 7),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("الشهر السابق"), Text("67 تسجيل")],
          ),
          SizedBox(height: 3),
          EvaluationBar(rating: 5),
        ],
      ),
    );
  }
}

class EvaluationBar extends StatefulWidget {
  final double? rating;

  const EvaluationBar({super.key, this.rating});

  @override
  EvaluationBarState createState() => EvaluationBarState();
}

class EvaluationBarState extends State<EvaluationBar> {
  double maxRating = 8; // Maximum possible value

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(5),
      value: widget.rating! / maxRating, // Convert to 0-1 range
      minHeight: 8,
      backgroundColor: Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
    );
  }
}
