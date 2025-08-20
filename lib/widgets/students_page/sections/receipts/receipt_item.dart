import 'package:flutter/material.dart';

class ReceiptItem extends StatefulWidget {
  final Icon icon;
  final String title;
  final String content;

  const ReceiptItem({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  State<ReceiptItem> createState() => _ReceiptItemState();
}

class _ReceiptItemState extends State<ReceiptItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [widget.icon, SizedBox(width: 10), Text(widget.title)]),
          SizedBox(height: 10),
          Text(
            widget.content,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
