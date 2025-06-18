import 'package:flutter/material.dart';

class OverviewRow extends StatelessWidget {
  final String left;
  final String right;

  const OverviewRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.25, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: TextStyle(color: Colors.grey)),
          Text(right, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
