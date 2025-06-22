import 'package:control_panel_2/widgets/students_page/nav_button.dart';
import 'package:control_panel_2/widgets/students_page/sections/discounts/discounts_section.dart';
import 'package:control_panel_2/widgets/students_page/sections/overview/overview_section.dart';
import 'package:control_panel_2/widgets/students_page/sections/receipts/receipts_section.dart';
import 'package:control_panel_2/widgets/students_page/sections/reviews/reviews_section.dart';
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
                          navkey: "Receipts",
                          isActive: _activeFilter == "Receipts",
                          onTap: () => _setFilter("Receipts"),
                        ),
                      ),
                      Expanded(
                        child: NavButton(
                          navkey: "Discounts",
                          isActive: _activeFilter == "Discounts",
                          onTap: () => _setFilter("Discounts"),
                        ),
                      ),
                      Expanded(
                        child: NavButton(
                          navkey: "Reviews",
                          isActive: _activeFilter == "Reviews",
                          onTap: () => _setFilter("Reviews"),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Content Section:
                _buildCurrentSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSection() {
    switch (_activeFilter) {
      case "Receipts":
        return ReceiptsSection();
      case "Discounts":
        return DiscountsSection();
      case "Reviews":
        return ReviewsSection();
      default:
        return OverviewSection(name: widget.name, username: widget.username);
    }
  }
}
