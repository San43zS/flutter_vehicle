import 'package:first_project/design/colors.dart';
import 'package:first_project/design/dimensions.dart';
import 'package:flutter/material.dart';

class AccentButton extends StatelessWidget {
  final String title;
  final Function() onTap;

  const AccentButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius20))
      ),
      child: Text(
        title,
        style: TextStyle(
          color: surfaceColor,
          fontSize: fontSize14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
