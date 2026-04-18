import 'package:flutter/material.dart';
import 'package:dcc_mobile/features/home/screens/homescreen.dart';
import 'package:dcc_mobile/features/job/screen/jobscreen.dart';
import 'package:dcc_mobile/features/track/screen/trackscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class _NavItem {
  final Widget page;
  final IconData icon;
  final String label;

  const _NavItem({required this.page, required this.icon, required this.label});
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _items = [
    const _NavItem(page: Homescreen(), icon: Icons.home_filled, label: 'Home'),
    const _NavItem(
      page: JobScreen(),
      icon: Icons.work_outline_rounded,
      label: 'Jobs',
    ),
    const _NavItem(
      page: TrackScreen(),
      icon: Icons.assignment_turned_in_outlined,
      label: 'Track',
    ),
    const _NavItem(
      page: Scaffold(body: Center(child: Text('Events Screen'))),
      icon: Icons.calendar_today_outlined,
      label: 'Events',
    ),
    const _NavItem(
      page: Scaffold(body: Center(child: Text('Profile Screen'))),
      icon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _items.map((item) => item.page).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: const Color(0xFFE5EBF5),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF032D60),
                  );
                }
                return GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF032D60),
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(
                    color: Color(0xFF032D60),
                    size: 28,
                  );
                }
                return const IconThemeData(color: Color(0xFF718096), size: 26);
              }),
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              backgroundColor: Colors.white,
              elevation: 0,
              height: 75,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: _items.map((item) {
                return NavigationDestination(
                  icon: Icon(item.icon),
                  label: item.label,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
