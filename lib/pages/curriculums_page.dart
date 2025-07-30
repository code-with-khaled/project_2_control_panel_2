import 'package:control_panel_2/constants/all_curriculums.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/widgets/curriculums_page/curriculum_card.dart';
import 'package:control_panel_2/widgets/curriculums_page/dialogs/new_curriculum_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurriculumsPage extends StatefulWidget {
  const CurriculumsPage({super.key});

  @override
  State<CurriculumsPage> createState() => _CurriculumsPageState();
}

class _CurriculumsPageState extends State<CurriculumsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.homepageBg,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1280), // Max content width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page header with title and create button
                  _buildPageHeader(),
                  SizedBox(height: 25),

                  _buildCurriculumsCourse(),
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
                "إدارة المناهج",
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
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => NewCurriculumDialog(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("إنشاء كورس منهاج"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "إدارة كورسات المناهج، الحضور والغياب، والدرجات",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildCurriculumsCourse() {
    return Wrap(
      runSpacing: 20,
      children: [
        for (int i = 0; i < allCurriculums.length; i++)
          CurriculumCard(curriculum: allCurriculums.elementAt(i)),
      ],
    );
  }
}
