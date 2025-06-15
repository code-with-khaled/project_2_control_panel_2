import 'package:flutter/material.dart';

class SearchFilterButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  const SearchFilterButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.black26,
          ),
          borderRadius: BorderRadius.circular(6),
          color: isActive ? Colors.blue : null,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
