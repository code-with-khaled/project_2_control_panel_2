import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/course_service.dart';
import 'package:control_panel_2/models/mark_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamsSection extends StatefulWidget {
  final int id;

  const ExamsSection({super.key, required this.id});

  @override
  State<ExamsSection> createState() => _ExamsSectionState();
}

class _ExamsSectionState extends State<ExamsSection> {
  bool _isLoading = true;

  List<Mark> _marks = [
    Mark(
      id: 1,
      title: "title",
      type: "type",
      date: DateTime.now(),
      maxScore: 60.00,
      studentsGrades: [
        StudentGrades(
          id: 1,
          student: AStudent(
            id: 1,
            firstName: "firstName",
            middleName: "middleName",
            lastName: "lastName",
          ),
          score: 55,
          notes: "ممتاز",
        ),
        StudentGrades(
          id: 2,
          student: AStudent(
            id: 2,
            firstName: "firstName2",
            middleName: "middleName2",
            lastName: "lastName2",
          ),
          score: 12,
          notes: "زفت",
        ),
        StudentGrades(
          id: 3,
          student: AStudent(
            id: 3,
            firstName: "firstName3",
            middleName: "middleName3",
            lastName: "lastName3",
          ),
          score: 38,
          notes: null,
        ),
      ],
    ),
    Mark(
      id: 2,
      title: "title2",
      type: "type2",
      date: DateTime.now(),
      maxScore: 90.00,
      studentsGrades: [],
    ),
  ];

  Future<void> _loadLectures() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await _courseService.fetchCourseGrades(token, widget.id);

      if (mounted) {
        setState(() {
          _marks += response;
        });
      }
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

  late CourseService _courseService;

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
            children: [_buildMarksGrid()],
          );
  }

  Widget _buildMarksGrid() {
    if (_marks.isEmpty) {
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
            for (final mark in _marks)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: MarkCard(mark: mark),
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
          'لا يوجد علامات',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

class MarkCard extends StatefulWidget {
  final Mark mark;

  const MarkCard({super.key, required this.mark});

  @override
  State<MarkCard> createState() => _MarkCardState();
}

class _MarkCardState extends State<MarkCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () => _showCourseMarksDialog(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          padding: EdgeInsets.all(20),
          decoration: _buildBoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.mark.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.mark.type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey.shade700,
                    size: 18,
                  ),
                  SizedBox(width: 5),

                  Text(
                    DateFormat('yyyy-MM-dd').format(widget.mark.date),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "العلامة القصوى:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(widget.mark.maxScore.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Decoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(6),
    boxShadow: isHovered
        ? [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ]
        : [],
  );

  void _showCourseMarksDialog() {
    showDialog(
      context: context,
      builder: (context) => GradesDialog(mark: widget.mark),
    );
  }
}

class GradesDialog extends StatefulWidget {
  final Mark mark;

  const GradesDialog({super.key, required this.mark});

  @override
  State<GradesDialog> createState() => _GradesDialogState();
}

class _GradesDialogState extends State<GradesDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 25),

                _buildAttendanceTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "نتائج - ${widget.mark.title}",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Spacer(),
      IconButton(
        icon: Icon(Icons.close, size: 20),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      ),
    ],
  );

  Widget _buildAttendanceTable() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("التاريخ: ${DateFormat('yyyy-MM-dd').format(widget.mark.date)}"),
          Text("النوع: ${widget.mark.type}"),
          Text("العلامة القصوى: ${widget.mark.maxScore}"),
        ],
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: StudentsGradesTable(
              mark: widget.mark,
              grades: widget.mark.studentsGrades,
            ),
          ),
        ],
      ),
    ],
  );
}

class StudentsGradesTable extends StatefulWidget {
  final Mark mark;
  final List<StudentGrades> grades;

  const StudentsGradesTable({
    super.key,
    required this.mark,
    required this.grades,
  });

  @override
  State<StudentsGradesTable> createState() => _StudentsGradesTableState();
}

class _StudentsGradesTableState extends State<StudentsGradesTable> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return widget.grades.isEmpty
        ? _buildEmptyState()
        : LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DataTable(
                      columnSpacing: 20,
                      horizontalMargin: 20,
                      columns: [
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 150),
                            child: Text(
                              'اسم الطالب',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: Text(
                              'العلامة',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: Text(
                              'النسبة',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: Text(
                              'ملاحظات',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                      rows: widget.grades.map((grade) {
                        final percentage =
                            (grade.score * 100) / widget.mark.maxScore;

                        return DataRow(
                          cells: [
                            DataCell(Text(grade.student.fullName)),

                            DataCell(
                              Text("${grade.score}/${widget.mark.maxScore}"),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusBgColor(percentage),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${percentage.toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              grade.notes != null
                                  ? Text(grade.notes!)
                                  : Text('-'),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'لا يوجد جدول حضور',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }

  Color _getStatusBgColor(double percentage) {
    switch (percentage) {
      case < 50:
        return Colors.red.shade200;
      case >= 50 && < 75:
        return Colors.yellow.shade200;
      case >= 75 && < 90:
        return Colors.blue.shade200;
      default:
        return Colors.green.shade200;
    }
  }
}
