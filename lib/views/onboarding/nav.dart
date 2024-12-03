import 'package:cloud_firestore/cloud_firestore.dart';
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
          return FutureBuilder<bool>(
            future: _checkUserType(snapshot.data!.uid),
            builder: (context, userTypeSnapshot) {
              if (userTypeSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (userTypeSnapshot.hasData) {
                // Explicitly return false for visitors
                bool isHandyman = userTypeSnapshot.data!;
                return MainScreen(isHandyman: isHandyman);
              }
              
              // If no user data found, sign out and return to onboarding
              FirebaseAuth.instance.signOut();
              return const OnboardingScreen();
            },
          );
        } else {
            // If no user, go to onboarding screen
            return const OnboardingScreen();
          }
        },
      );
    }
  }

  // New method to determine user type
  Future<bool> _checkUserType(String uid) async {
    // Check handymen collection first
    var handymanDoc = 
        await FirebaseFirestore.instance.collection('handymen').doc(uid).get();
    
    // Return true only if the document exists in handymen collection
    return handymanDoc.exists;
  }
