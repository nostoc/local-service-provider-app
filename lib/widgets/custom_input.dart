import 'package:flutter/material.dart';
import 'package:local_service_provider_app/utils/colors.dart';

class ReusableInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?) validator;

  const ReusableInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.obscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: mainTextColor),
      borderRadius: BorderRadius.circular(22),
    );
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 20,
          color: mainTextColor,
          fontWeight: FontWeight.w500,
        ),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        prefixIcon: Icon(
          icon,
          color: mainTextColor,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
