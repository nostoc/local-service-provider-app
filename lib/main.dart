import 'package:flutter/material.dart';
import 'package:local_service_provider_app/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Local Service Provider App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Outfit",),
      
      home: const OnboardingScreen(),
    );
  }
}
