import 'package:flutter/material.dart';

class VisitorSignupScreen extends StatefulWidget {
  const VisitorSignupScreen({super.key});

  @override
  State<VisitorSignupScreen> createState() => _VisitorSignupScreenState();
}

class _VisitorSignupScreenState extends State<VisitorSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visitor Signup"),),
    );
  }
}