import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  const CustomButton({
    super.key,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.065,
      decoration: BoxDecoration(
          border: Border.all(color: buttonTextColor),
          borderRadius: BorderRadius.circular(22),
          color: buttonColor),
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
              color: buttonTextColor,
              fontSize: 22,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
