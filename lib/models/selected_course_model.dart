import 'package:control_panel_2/models/course_model.dart';

class SelectedCourse {
  final int id;
  final String name;
  final CourseTeacher teacher;

  SelectedCourse({required this.id, required this.name, required this.teacher});

  factory SelectedCourse.fromJson(Map<String, dynamic> json) => SelectedCourse(
    id: json['id'],
    name: json['name'],
    teacher: CourseTeacher.fromJson(json['teacher']),
  );
}
