import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final double width;
  final VoidCallback onPressed;

  const ReusableButton(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      required this.buttonTextColor,
      required this.width,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        color: buttonColor,
        border: Border.all(color: buttonTextColor),
        borderRadius: BorderRadius.circular(22),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20,
            color: buttonTextColor,
          ),
        ),
      ),
    );
  }
}
