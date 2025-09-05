import 'package:control_panel_2/models/course_model.dart';

class Discount {
  final int id;
  final double value;
  final String type;
  final int discountableId;
  final Course course;
  final String expirationDate;

  const Discount({
    required this.id,
    required this.value,
    required this.type,
    required this.discountableId,
    required this.course,
    required this.expirationDate,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
    id: json['id'],
    value: double.parse(json['value']),
    type: json['type'],
    discountableId: json['discountable_id'],
    course: Course.fromJson(json['discountable']),
    expirationDate: json['expiration_date'],
  );
}
