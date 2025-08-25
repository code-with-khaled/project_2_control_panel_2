import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;

  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < rating; i++)
            Icon(Icons.star, color: Colors.yellow, size: 20),
          for (int i = 0; i < 5 - rating; i++)
            Icon(Icons.star_border, color: Colors.black54, size: 20),
        ],
      ),
    );
  }
}
