import 'package:control_panel_2/widgets/other/rating_stars.dart';
import 'package:flutter/material.dart';

class TeacherReviewsSection extends StatelessWidget {
  const TeacherReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildReview(), SizedBox(height: 10), _buildReview()],
    );
  }

  Widget _buildReview() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "عبد الحكيم رمضان",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              RatingStars(),
            ],
          ),
          SizedBox(height: 1),
          Text("الفيزياء للمهندسين", style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 10),
          Text("كورس ممتاز! شرح وافي وواضح حل تمارين كثيرة."),
          SizedBox(height: 9),
          Text("11/6/2025", style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}
