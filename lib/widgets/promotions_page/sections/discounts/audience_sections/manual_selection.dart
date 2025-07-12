import 'package:flutter/material.dart';

class ManualSelection extends StatefulWidget {
  const ManualSelection({super.key});

  @override
  State<ManualSelection> createState() => _ManualSelectionState();
}

class _ManualSelectionState extends State<ManualSelection> {
  final List<String> _allStudents = [
    'محمد',
    'محمد',
    'محمد',
    'محمد',
    'محمد',
    'محمد',
    'محمد',
  ];

  final List<String> _selectedStudents = [];

  void _toggleStudentSelection(String course) {
    setState(() {
      if (_selectedStudents.contains(course)) {
        _selectedStudents.remove(course);
      } else {
        _selectedStudents.add(course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("اختر الطلاب"),
        SizedBox(height: 10),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              childAspectRatio: 8, // Width/height ratio for each item
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _allStudents.length,
            itemBuilder: (context, index) {
              final course = _allStudents[index];
              return Row(
                children: [
                  Checkbox(
                    value: _selectedStudents.contains(course),
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      _toggleStudentSelection(course);
                    },
                  ),
                  Expanded(
                    child: Text(course, overflow: TextOverflow.ellipsis),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
