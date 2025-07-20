import 'package:control_panel_2/constants/all_courses.dart';
import 'package:control_panel_2/constants/all_students.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/widgets/classifications_page/tables/categories_table.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassificationsPage extends StatefulWidget {
  const ClassificationsPage({super.key});

  @override
  State<ClassificationsPage> createState() => _ClassificationsPageState();
}

class _ClassificationsPageState extends State<ClassificationsPage> {
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

                  _buildCategories(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds page header with title and create button
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "إدارة التصنيفات",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                // onPressed: () => showDialog(
                //   context: context,
                //   builder: (context) => NewCourseDialog(),
                // ),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("إنشاء تصنيف جديد"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "إدارة تصنيفات الكورسات وعرض إحصائيات مفصلة",
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
        if (constraints.maxWidth >= 800) {
          return Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  "مجمل التصنيفات",
                  "4",
                  Icon(
                    Icons.import_contacts_rounded,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "مجمل الكورسات",
                  courses.length.toString(),
                  Icon(
                    Icons.import_contacts_rounded,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "مجمل الطلاب",
                  allStudents.length.toString(),
                  Icon(Icons.group_outlined, color: Colors.purple, size: 32),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "مجمل العائدات",
                  "\$22000",
                  Icon(Icons.attach_money, color: Colors.yellow, size: 32),
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
                      "مجمل التصنيفات",
                      "4",
                      Icon(
                        Icons.import_contacts_rounded,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildOverviewCard(
                      "مجمل الكورسات",
                      courses.length.toString(),
                      Icon(
                        Icons.import_contacts_rounded,
                        color: Colors.green,
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
                      "مجمل الطلاب",
                      allStudents.length.toString(),
                      Icon(
                        Icons.group_outlined,
                        color: Colors.purple,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildOverviewCard(
                      "مجمل العائدات",
                      "\$22000",
                      Icon(Icons.attach_money, color: Colors.yellow, size: 32),
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

  Widget _buildCategories() {
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
          Text(
            "التصنيفات",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text(
            "إدارة جميع التصنيفات",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: SearchField(
                  controller: _searchController,
                  hintText: "إبحث عن التصنيفات بالاسم...",
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: CategoriesTable(searchQuery: _searchController.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
