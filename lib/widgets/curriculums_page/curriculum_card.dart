import 'package:control_panel_2/models/curriculum_model.dart';
import 'package:control_panel_2/widgets/curriculums_page/sections/marks_section/marks_section.dart';
import 'package:control_panel_2/widgets/curriculums_page/sections/students_attendance_section.dart';
import 'package:control_panel_2/widgets/curriculums_page/sections/teachers_attendance_section.dart';
import 'package:control_panel_2/widgets/other/nav_button.dart';
import 'package:flutter/material.dart';

class CurriculumCard extends StatefulWidget {
  final Curriculum curriculum;

  const CurriculumCard({super.key, required this.curriculum});

  @override
  State<CurriculumCard> createState() => _CurriculumCardState();
}

class _CurriculumCardState extends State<CurriculumCard> {
  bool isHovered = false; // Tracks hover state for visual feedback
  bool isPressed = false;

  String _activeFilter = "حضور الطلاب"; // Currently selected section

  /// Updates the active section filter
  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final curriculum = widget.curriculum;
    final subjects = curriculum.subjects;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () => setState(() {
          isPressed = !isPressed;
        }),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
            color: isPressed
                ? const Color.fromARGB(255, 254, 254, 254)
                : Colors.white,
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
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              curriculum.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusBgColor(curriculum.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                curriculum.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: _getStatusColor(curriculum.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${curriculum.startDate} - ${curriculum.endDate}",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 12,
                          runSpacing: 5,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.import_contacts,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 5),
                                Text(subjects.length.toString()),
                                SizedBox(width: 5),
                                Text("مواد"),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.group_outlined,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 5),
                                Text(curriculum.students.toString()),
                                SizedBox(width: 5),
                                Text("طلاب"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Wrap(
                          spacing: 5,
                          runSpacing: 2,
                          children: [
                            for (int i = 0; i < subjects.length; i++)
                              Chip(
                                label: Text(
                                  subjects.elementAt(i),
                                  style: TextStyle(color: Colors.black),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                backgroundColor: Colors.grey.shade200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: BorderSide.none,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isPressed
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
              if (isPressed) _buildRest(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'نشط':
        return Colors.green.shade100;
      case 'مكتمل':
        return Colors.blue.shade100;
      default:
        return Colors.yellow.shade100;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'نشط':
        return Colors.green.shade900;
      case 'مكتمل':
        return Colors.blue.shade900;
      default:
        return Colors.yellow.shade800;
    }
  }

  Widget _buildRest() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 25),
        _buildNavigationTabs(),
        SizedBox(height: 20),
        _buildCurrentSection(),
      ],
    );
  }

  // Builds navigation tabs for sections
  Widget _buildNavigationTabs() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blueGrey[50],
      ),
      child: Row(
        children: [
          // Advertisements tab
          Expanded(
            child: NavButton(
              navkey: "حضور الطلاب",
              isActive: _activeFilter == "حضور الطلاب",
              onTap: () => _setFilter("حضور الطلاب"),
            ),
          ),

          // Discounts tab
          Expanded(
            child: NavButton(
              navkey: "حضور الأساتذة",
              isActive: _activeFilter == "حضور الأساتذة",
              onTap: () => _setFilter("حضور الأساتذة"),
            ),
          ),

          // Notifications tab
          Expanded(
            child: NavButton(
              navkey: "العلامات",
              isActive: _activeFilter == "العلامات",
              onTap: () => _setFilter("العلامات"),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate content section based on active filter
  Widget _buildCurrentSection() {
    switch (_activeFilter) {
      case "حضور الأساتذة":
        return TeachersAttendanceSection();
      // case "العلامات":
      //   return MarksSection(curriculum: widget.curriculum);
      default:
        return StudentsAttendanceSection();
    }
  }
}
