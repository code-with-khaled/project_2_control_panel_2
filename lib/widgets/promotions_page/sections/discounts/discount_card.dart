import 'package:control_panel_2/models/discount_model.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/edit_discount_dialog.dart';
import 'package:flutter/material.dart';

class DiscountCard extends StatefulWidget {
  final Discount discount;
  final VoidCallback callback;

  const DiscountCard({
    super.key,
    required this.discount,
    required this.callback,
  });

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  bool isHovered = false;

  String _getValueAfterDiscount() {
    if (widget.discount.type == "قيمة مقطوعة") {
      return (widget.discount.course.price - widget.discount.value)
          .toStringAsFixed(2);
    } else {
      return (widget.discount.course.price -
              (widget.discount.value / 100) * widget.discount.course.price)
          .toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(6),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDiscountHeader(),
            SizedBox(height: 10),

            _buildDiscountValueAndUsage(),
            SizedBox(height: 10),

            _buildDiscountInfo(),
            SizedBox(height: 10),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// Builds discount header with title and active status
  Widget _buildDiscountHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.discount.course.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              widget.discount.course.description,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
        Chip(
          label: Text(
            widget.discount.type,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.black12),
          ),
        ),
      ],
    );
  }

  /// Builds discount value and usage statistics
  Widget _buildDiscountValueAndUsage() {
    return Row(
      children: [
        Expanded(
          // Discount value card
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.discount.value.toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "القيمة",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          // Usage stats card
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.discount.course.price.toString(),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "القيمة الأصلية",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds additional discount information
  Widget _buildDiscountInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Expiry date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey),
                SizedBox(width: 5),
                Text("تاريخ الانتهاء:", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text(widget.discount.expirationDate),
          ],
        ),
        SizedBox(height: 5),

        // Revenue generated
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: Colors.grey),
                SizedBox(width: 5),
                Text("القيمة بعد الحسم:", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text(_getValueAfterDiscount()),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  /// Builds action buttons (edit and deactivate)
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_buildEditButton(), SizedBox(width: 5), _buildDeleteButton()],
    );
  }

  /// Builds edit discount button
  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => EditDiscountDialog(
            discount: widget.discount,
            callback: widget.callback,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined),
            SizedBox(width: 3),
            Flexible(child: Text("تعديل")),
          ],
        ),
      ),
    );
  }

  /// Builds deactivate discount button
  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block, color: Colors.red),
            SizedBox(width: 3),

            Flexible(
              child: Text("إلغاء الحسم", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
