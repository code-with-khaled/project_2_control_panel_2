import 'package:control_panel_2/constants/all_courses.dart';
import 'package:control_panel_2/constants/all_students.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/widgets/certificates_page/tables/certificates_table.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({super.key});

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.homepageBg,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page header with title and create button
                  _buildPageHeader(),
                  SizedBox(height: 25),

                  _buildOverviewCards(),
                  SizedBox(height: 20),

                  _buildCertificates(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds page header
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إدارة الشهادات",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "تصدير الشهادات لمن أنهى الكورسات والطباعة",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildOverviewCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  "مجمل الشهادات",
                  "4",
                  Icon(
                    Icons.description_outlined,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "قيد الانتظار",
                  courses.length.toString(),
                  Icon(Icons.print_outlined, color: Colors.orange, size: 32),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "تمت طباعته",
                  allStudents.length.toString(),
                  Icon(Icons.check, color: Colors.green, size: 32),
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
                    child: _buildOverviewCard(
                      "مجمل الشهادات",
                      "4",
                      Icon(
                        Icons.description_outlined,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewCard(
                      "قيد الانتظار",
                      courses.length.toString(),
                      Icon(
                        Icons.print_outlined,
                        color: Colors.orange,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewCard(
                      "تمت طباعته",
                      allStudents.length.toString(),
                      Icon(Icons.check, color: Colors.green, size: 32),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildOverviewCard(String title, String number, Icon icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black87)),
              Text(
                number,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          icon,
        ],
      ),
    );
  }

  Widget _buildCertificates() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.description_outlined),
                      SizedBox(width: 5),
                      Text(
                        "الشهادات",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "إدارة وتصدير الشهادات",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          SearchField(
            controller: _searchController,
            hintText: "إبحث عن التصنيفات بالاسم...",
            onChanged: (value) => setState(() {}),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CertificatesTable(searchQuery: _searchController.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
