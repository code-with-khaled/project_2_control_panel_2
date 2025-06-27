import 'package:control_panel_2/widgets/other/rating_stars.dart';
import 'package:flutter/material.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.reviews_outlined),
            SizedBox(width: 6),
            Text(
              "تقييمات الدورات", // "Courses Reviews"
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          runSpacing: 10,
          children: [
            for (int i = 0; i < 5; i++)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "رياكت المتقدم", // "React Advanced"
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "٦/٥/٢٠٢٥", // "6/5/2025" (Arabic numerals)
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "دورة ممتازة مع أمثلة رائعة!", // "Excellent course with great examples!"
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    RatingStars(),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
