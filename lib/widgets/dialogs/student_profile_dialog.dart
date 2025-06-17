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
    return SingleChildScrollView(
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Student Profile", style: TextStyle()),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, size: 18),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 38, child: Icon(Icons.person, size: 40)),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.name,
                      style: GoogleFonts.roboto(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.username,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blueGrey[50],
              ),
              child: Row(
                children: [
                  NavButton(
                    navkey: "Overview",
                    isActive: _activeFilter == "Overview",
                    onTap: () => _setFilter("Overview"),
                  ),
                  NavButton(
                    navkey: "Academic",
                    isActive: _activeFilter == "Academic",
                    onTap: () => _setFilter("Academic"),
                  ),
                  NavButton(
                    navkey: "Financial",
                    isActive: _activeFilter == "Financial",
                    onTap: () => _setFilter("Financial"),
                  ),
                  NavButton(
                    navkey: "Activity",
                    isActive: _activeFilter == "Activity",
                    onTap: () => _setFilter("Activity"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            OverviewLeft(
              name: widget.name,
              username: widget.username,
              phone: '+963-994-387-970',
              gender: 'Male',
            ),
            OverviewRight(
              university: "MIT",
              specialization: "Data Science",
              level: "Master Degree",
            ),
          ],
        ),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final String navkey;
  final bool isActive;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.navkey,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 75, vertical: 7.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: isActive ? Colors.white : Colors.transparent,
        ),

        child: Text(
          navkey,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OverviewLeft extends StatelessWidget {
  final String name;
  final String username;
  final String phone;
  final String gender;

  const OverviewLeft({
    super.key,
    required this.name,
    required this.username,
    required this.phone,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 6),
              Text(
                "Personal Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          OverviewRow(left: "Full Name:", right: name),
          OverviewRow(left: "Username:", right: username),
          OverviewRow(left: "phone:", right: phone),
          OverviewRow(left: "Gender:", right: gender),
        ],
      ),
    );
  }
}

class OverviewRight extends StatelessWidget {
  final String university;
  final String specialization;
  final String level;

  const OverviewRight({
    super.key,
    required this.university,
    required this.specialization,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined),
              SizedBox(width: 6),
              Text(
                "Education",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          OverviewRow(left: "University:", right: university),
          OverviewRow(left: "Specialization:", right: specialization),
          OverviewRow(left: "Education level:", right: level),
        ],
      ),
    );
  }
}

class OverviewRow extends StatelessWidget {
  final String left;
  final String right;

  const OverviewRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.25, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: TextStyle(color: Colors.grey)),
          Text(right, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
