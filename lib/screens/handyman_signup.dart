import 'package:flutter/material.dart';

class HandymanSignupScreen extends StatefulWidget {
  const HandymanSignupScreen({super.key});

  @override
  State<HandymanSignupScreen> createState() => _HandymanSignupScreenState();
}

class _HandymanSignupScreenState extends State<HandymanSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hnady Man Signup"),
      ),
    );
  }
}
