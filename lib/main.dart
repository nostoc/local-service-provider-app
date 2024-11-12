import 'package:flutter/material.dart';
import 'package:local_service_provider_app/pages/home_page.dart';
import 'package:local_service_provider_app/pages/onboarding_page_2.dart';
import 'package:local_service_provider_app/pages/onboarding_page_3.dart';
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
      
      home: const HomePage(),
    );
  }
}
