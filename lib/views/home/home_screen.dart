import 'package:flutter/material.dart';
import 'package:local_service_provider_app/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            await AuthService().signOut();
          },
          child: const Text("Sign Out"),
        ),
      ),
    );
  }
}
