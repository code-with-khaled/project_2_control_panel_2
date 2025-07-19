import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/widgets/courses_page/tables/students_enrollments_table.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';

class CourseEnrollmentsDialog extends StatefulWidget {
  final Course course;

  const CourseEnrollmentsDialog({super.key, required this.course});

  @override
  State<CourseEnrollmentsDialog> createState() =>
      _CourseEnrollmentsDialogState();
}

class _CourseEnrollmentsDialogState extends State<CourseEnrollmentsDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchEnrollmentsController =
      TextEditingController();

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
          padding: EdgeInsets.only(left: 2),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Header section with close button
                _buildHeader(),
                SizedBox(height: 20),

                _buildSearchSection(),
                SizedBox(height: 25),

                _buildSearchSection2(),
                SizedBox(height: 25),

                Expanded(
                  child: StudentsEnrollmentsTable(
                    searchQuery: _searchEnrollmentsController.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the dialog header with title and close button
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            "إدارة التسجيل - ${widget.course.name}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.close, size: 20),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }

  // Builds search and filter controls
  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              controller: _searchController,
              hintText: "ابحث عن الطالب بالاسم أو المعرف",
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.person_add_alt),
                  SizedBox(width: 10),
                  Text("إضافة طالب"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection2() {
    return SearchField(
      controller: _searchEnrollmentsController,
      hintText: "ابحث عن الطلاب المنتسبين ",
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}
