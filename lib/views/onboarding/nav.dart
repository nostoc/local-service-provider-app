import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_provider_app/views/main_screen.dart';
import 'package:local_service_provider_app/views/onboarding/onboarding_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // If user is logged in, go to main screen
          return const MainScreen(isHandyman: false);
        } else {
          // If no user, go to onboarding screen
          return const OnboardingScreen();
        }
      },
    );
  }
}
