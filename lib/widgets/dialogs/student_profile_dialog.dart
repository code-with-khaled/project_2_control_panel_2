import 'package:control_panel_2/widgets/students_section/nav_button.dart';
import 'package:control_panel_2/widgets/students_section/overview_left.dart';
import 'package:control_panel_2/widgets/students_section/overview_right.dart';
import 'package:control_panel_2/widgets/students_section/statistic_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentProfileDialog extends StatefulWidget {
  final String name;
  final String username;

  const StudentProfileDialog({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  State<StudentProfileDialog> createState() => _StudentProfileDialogState();
}

class _StudentProfileDialogState extends State<StudentProfileDialog> {
  String _activeFilter = 'Overview';

  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

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
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Student Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Profile Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 42),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.username,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Divider(height: 1),
                SizedBox(height: 16),

                // Navigation Tabs
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blueGrey[50],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: NavButton(
                          navkey: "Overview",
                          isActive: _activeFilter == "Overview",
                          onTap: () => _setFilter("Overview"),
                        ),
                      ),
                      Expanded(
                        child: NavButton(
                          navkey: "Academic",
                          isActive: _activeFilter == "Academic",
                          onTap: () => _setFilter("Academic"),
                        ),
                      ),
                      Expanded(
                        child: NavButton(
                          navkey: "Financial",
                          isActive: _activeFilter == "Financial",
                          onTap: () => _setFilter("Financial"),
                        ),
                      ),
                      Expanded(
                        child: NavButton(
                          navkey: "Activity",
                          isActive: _activeFilter == "Activity",
                          onTap: () => _setFilter("Activity"),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Content Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: OverviewLeft(
                              name: widget.name,
                              username: widget.username,
                              phone: '+963-994-387-970',
                              gender: 'Male',
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: OverviewRight(
                              university: "MIT",
                              specialization: "Data Science",
                              level: "Master Degree",
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          OverviewLeft(
                            name: widget.name,
                            username: widget.username,
                            phone: '+963-994-387-970',
                            gender: 'Male',
                          ),
                          SizedBox(height: 20),
                          OverviewRight(
                            university: "MIT",
                            specialization: "Data Science",
                            level: "Master Degree",
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constrains) {
                    if (constrains.maxWidth > 700) {
                      return Row(
                        children: [
                          Expanded(
                            child: StatisticCard(
                              icon: Icon(
                                Icons.import_contacts,
                                color: Colors.blue[700],
                                size: 27,
                              ),
                              number: "9",
                              text: "Completed Courses",
                              backgoundColor: Colors.blue.withValues(
                                alpha: 0.1,
                              ),
                              color: Colors.blue.shade700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: StatisticCard(
                              icon: Icon(
                                Icons.star_border,
                                color: Colors.orange[700],
                                size: 27,
                              ),
                              number: "4.9",
                              text: "Average Rating",
                              backgoundColor: Colors.orange.withValues(
                                alpha: 0.1,
                              ),
                              color: Colors.orange.shade700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: StatisticCard(
                              icon: Icon(
                                Icons.import_contacts,
                                color: Colors.green[700],
                                size: 27,
                              ),
                              number: "28",
                              text: "Reviews Given",
                              backgoundColor: Colors.green.withValues(
                                alpha: 0.1,
                              ),
                              color: Colors.green.shade700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: StatisticCard(
                              icon: Icon(
                                Icons.import_contacts,
                                color: Colors.purple[700],
                                size: 27,
                              ),
                              number: "45",
                              text: "Contributions",
                              backgoundColor: Colors.purple.withValues(
                                alpha: 0.1,
                              ),
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: StatisticCard(
                                  icon: Icon(
                                    Icons.import_contacts,
                                    color: Colors.blue[700],
                                    size: 27,
                                  ),
                                  number: "9",
                                  text: "Completed Courses",
                                  backgoundColor: Colors.blue.withValues(
                                    alpha: 0.1,
                                  ),
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: StatisticCard(
                                  icon: Icon(
                                    Icons.star_border,
                                    color: Colors.orange[700],
                                    size: 27,
                                  ),
                                  number: "4.9",
                                  text: "Average Rating",
                                  backgoundColor: Colors.orange.withValues(
                                    alpha: 0.1,
                                  ),
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: StatisticCard(
                                  icon: Icon(
                                    Icons.import_contacts,
                                    color: Colors.green[700],
                                    size: 27,
                                  ),
                                  number: "28",
                                  text: "Reviews Given",
                                  backgoundColor: Colors.green.withValues(
                                    alpha: 0.1,
                                  ),
                                  color: Colors.green.shade700,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: StatisticCard(
                                  icon: Icon(
                                    Icons.import_contacts,
                                    color: Colors.purple[700],
                                    size: 27,
                                  ),
                                  number: "45",
                                  text: "Contributions",
                                  backgoundColor: Colors.purple.withValues(
                                    alpha: 0.1,
                                  ),
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
