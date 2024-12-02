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
    List<Widget> basePages = [
      const HomeScreen(),
      const SearchPage(),
    ];

    // Add handyman profile page only if user is a handyman
    if (widget.isHandyman) {
      basePages.add(const HandymanProfileScreen());
    }

    return basePages;
  }

  List<BottomNavigationBarItem> get _bottomNavItems {
    List<BottomNavigationBarItem> baseItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: "Search",
      ),
    ];

    // Add profile nav item only if user is a handyman
    if (widget.isHandyman) {
      baseItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profile",
        ),
      );
    }

    return baseItems;
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
        onTap: _onIconTap,
      ),
      body: _pages[_currentIndex],
    );
  }
}
