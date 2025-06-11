import 'package:flutter/material.dart';

class SectionWidget extends StatefulWidget {
  final String title;
  final Icon icon;
  final String description;
  final String? routeName;

  const SectionWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    this.routeName,
  });

  @override
  SectionWidgetState createState() => SectionWidgetState();
}

class SectionWidgetState extends State<SectionWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Material(
        child: InkWell(
          onTap: () {
            if (widget.routeName != null) {
              Navigator.pushNamed(context, widget.routeName!);
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            constraints: BoxConstraints(maxWidth: 260),
            padding: EdgeInsets.all(20),
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: Offset(0, 4), // Makes it look elevated
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.icon,
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
