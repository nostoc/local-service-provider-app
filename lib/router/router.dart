import "package:go_router/go_router.dart";
import "package:flutter/material.dart";

import "package:local_service_provider_app/views/auth_views/handyman/handyman_signin.dart";
import "package:local_service_provider_app/views/auth_views/handyman/handyman_signup.dart";
import "package:local_service_provider_app/views/auth_views/visitor/visitor_signin.dart";
import "package:local_service_provider_app/views/auth_views/visitor/visitor_signup.dart";
import "package:local_service_provider_app/views/handyman/handy_man_profile_view.dart";
import "package:local_service_provider_app/views/main_screen.dart";
import "package:local_service_provider_app/views/onboarding/nav.dart";
import "package:local_service_provider_app/views/onboarding/onboarding_screen.dart";

class RouterClass {
  final router = GoRouter(
    initialLocation: "/splash-screen", // Set SplashScreen as the start page
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Oops ☹️ this page is not found!"),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).go("/handyman-signup");
                  },
                  child: const Text("Go to Signup page"),
                ),
              ],
            ),
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: "/",
        name: "nav_layout",
        builder: (context, state) {
          return const LayoutScreen();
        },
      ),

      // Splash screen route
      GoRoute(
        name: "splash-screen",
        path: "/splash-screen",
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),
      GoRoute(
          path: "/home",
          name: "home",
          builder: (context, state) {
            return const MainScreen(isHandyman: true);
          }),
      // Login page
      GoRoute(
        name: "visitor-login",
        path: "/visitor-login",
        builder: (context, state) {
          return const VisitorSignin();
        },
      ),
      // Register page
      GoRoute(
        name: "visitor-signup",
        path: "/visitor-signup",
        builder: (context, state) {
          return const VisitorSignupScreen();
        },
      ),
      GoRoute(
        name: "handyman-signup",
        path: "/handyman-signup",
        builder: (context, state) {
          return const HandyManSignUpPage();
        },
      ),
      GoRoute(
        name: "handyman-signin",
        path: "/handyman-signin",
        builder: (context, state) {
          return const HandyManSignIn();
        },
      ),
      GoRoute(
        path: "/handyman-profile-view",
        builder: (context, state) {
          return const HandymanProfileView(
            handymanId: '',
          );
        },
      )
    ],
  );
}
