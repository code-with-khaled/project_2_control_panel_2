import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final Icon icon;
  final String number;
  final String text;
  final Color backgoundColor;
  final Color color;

  const StatisticCard({
    super.key,
    required this.icon,
    required this.number,
    required this.text,
    required this.backgoundColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: backgoundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 7),
          Text(
            number,
            style: TextStyle(
              fontSize: 21,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(text, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}
