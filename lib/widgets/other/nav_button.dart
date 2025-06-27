import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String navkey;
  final bool isActive;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.navkey,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isActive ? Colors.white : Colors.transparent,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            navkey,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? Colors.black : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
