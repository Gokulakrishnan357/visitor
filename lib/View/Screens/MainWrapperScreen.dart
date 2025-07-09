import 'package:flutter/material.dart';

import 'HomeScreen/BottomScreens/LogScreen.dart';
import 'HomeScreen/BottomScreens/MemberScreen.dart';
import 'HomeScreen/BottomScreens/ProfileScreen.dart';
import 'HomeScreen/BottomScreens/VisitorScreen/AddVisitorScreen.dart';
import 'HomeScreen/HomeScreen.dart';
import 'HomeScreen/SubScreens/BottomNavBar.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();

}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LogScreen(),
    MemberScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVisitorForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTap,
        backgroundColor: const Color(0xFF0C448E),
        elevation: 8,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        onAddTap: _onAddTap,
      ),
    );
  }
}

