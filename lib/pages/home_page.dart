import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/constants/sections_consts.dart';
import 'package:control_panel_2/widgets/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.homepageBg,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_outlined, size: 40),
                  SizedBox(width: 10),
                  Text(
                    "لوحة تحكم مسار التعليم", // "MasarEdu Control Panel"
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Text(
                  "نظام إدارة شامل للمؤسسات التعليمية. راقب الطلاب، وأدر المدرسين، وتتبع التقدم كلها في مكان واحد", // Translated description
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl, // Right-align Arabic text
                ),
              ),
              SizedBox(height: 30),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1120),
                child: Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  children: [
                    for (int i = 0; i < sections.length; i++)
                      SectionWidget(
                        title: sections[i]["title"] as String,
                        icon: sections[i]["icon"] as Icon,
                        description: sections[i]["description"] as String,
                        routeName: sections[i]["route"] as String?,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
