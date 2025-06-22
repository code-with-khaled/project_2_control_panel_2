import 'package:control_panel_2/widgets/dialogs/student_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentProfile extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final DateTime joinDate;

  const StudentProfile({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.joinDate,
  });

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(widget.joinDate);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => StudentProfileDialog(
            name: widget.name,
            username: widget.username,
          ),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 22, child: Icon(Icons.person)),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.username,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_outlined, color: Colors.black87, size: 17),
                  SizedBox(width: 7),
                  Text(
                    "Field of Study",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "university/school",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book, color: Colors.blue, size: 17),
                      SizedBox(width: 8),
                      Text("Courses"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "4/8",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "50% complete",
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 7),
              EvaluationBar(),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_border, size: 17, color: Colors.yellow),
                      SizedBox(width: 8),
                      Text("Avg Rating"),
                    ],
                  ),
                  Text("4.6", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Divider(color: Colors.black12),
              SizedBox(height: 10),
              Text(
                "Joined: $formattedDate",
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EvaluationBar extends StatefulWidget {
  const EvaluationBar({super.key});

  @override
  EvaluationBarState createState() => EvaluationBarState();
}

class EvaluationBarState extends State<EvaluationBar> {
  double rating = 4;
  double maxRating = 8;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(5),
      value: rating / maxRating,
      minHeight: 8,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
