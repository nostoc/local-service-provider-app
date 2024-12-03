import 'package:flutter/material.dart';
import 'package:local_service_provider_app/views/main_views/home_screen.dart';
import 'package:local_service_provider_app/views/handyman/profile_screen.dart';
import 'package:local_service_provider_app/views/main_views/search_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isHandyman;
  const MainScreen({super.key, required this.isHandyman});

  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> get _pages {
    return [
      const HomeScreen(),
      const SearchPage(),
      // Only add profile page if isHandyman is true
      if (widget.isHandyman) const HandymanProfileScreen(),
    ];
  }

  List<BottomNavigationBarItem> get _bottomNavItems {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: "Search",
      ),
      // Only add profile nav item if isHandyman is true
      if (widget.isHandyman)
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profile",
        ),
    ];
  }

  void _onIconTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _currentIndex,
        // Adjust type to fixed to prevent shifting
        type: BottomNavigationBarType.fixed,
        onTap: _onIconTap,
      ),
      body: _pages[_currentIndex], // Note the correction here
    );
  }
}
