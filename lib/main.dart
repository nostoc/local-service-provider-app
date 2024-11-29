import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Local Service Provider App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: whiteColor,
          selectedItemColor: mainTextColor,
          unselectedItemColor: Color(0xFF8C8C8C),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: whiteColor,
          contentTextStyle: TextStyle(color: blackColor, fontSize: 16),
        ),
      ),
      routerConfig: RouterClass().router,
    );
  }
}
