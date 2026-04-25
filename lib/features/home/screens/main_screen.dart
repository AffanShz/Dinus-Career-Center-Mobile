import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/widgets/bottom_navbar.dart';
import 'package:dcc_mobile/features/home/screens/homescreen.dart';
import 'package:dcc_mobile/features/job/screens/jobscreen.dart';
import 'package:dcc_mobile/features/track/screens/trackscreen.dart';

/// Data class for navigation items.
class _NavItem {
  final Widget page;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.page,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Root screen that holds the bottom navigation and switches between tabs.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _items = [
    const _NavItem(
      page: Homescreen(),
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_filled,
      label: 'Beranda',
    ),
    const _NavItem(
      page: JobScreen(),
      icon: Icons.work_outline_rounded,
      selectedIcon: Icons.work_rounded,
      label: 'Loker',
    ),
    const _NavItem(
      page: TrackScreen(),
      icon: Icons.assignment_turned_in_outlined,
      selectedIcon: Icons.assignment_turned_in,
      label: 'Status',
    ),
    const _NavItem(
      page: Scaffold(body: Center(child: Text('Events Screen'))),
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      label: 'Acara',
    ),
    const _NavItem(
      page: Scaffold(body: Center(child: Text('Profile Screen'))),
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _items.map((item) => item.page).toList(),
      ),
      bottomNavigationBar: AppBottomNavbar(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _items.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
