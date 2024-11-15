import 'package:flutter/material.dart';
import 'package:local_service_provider_app/views/main_views/home_screen.dart';
import 'package:local_service_provider_app/views/main_views/profile_screen.dart';
import 'package:local_service_provider_app/views/main_views/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;
  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    HandymanProfileScreen(),
  ];

  void _onIconTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onIconTap,
      ),
      body: _pages[_currentIndex],
    );
  }
}
