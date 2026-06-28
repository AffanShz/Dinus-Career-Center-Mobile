import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/widgets/bottom_navbar.dart';
import 'package:dcc_mobile/features/home/screens/homescreen.dart';
import 'package:dcc_mobile/features/job/screens/jobscreen.dart';
import 'package:dcc_mobile/features/track/screens/trackscreen.dart';
import 'package:dcc_mobile/features/event/screens/event_screen.dart';
import 'package:dcc_mobile/features/profile/screens/profile_screen.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_bloc.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_event.dart';
import 'package:dcc_mobile/features/home/bloc/home_bloc.dart';
import 'package:dcc_mobile/features/home/bloc/home_event.dart';
import 'package:dcc_mobile/features/job/bloc/job_bloc.dart';
import 'package:dcc_mobile/features/job/bloc/job_event.dart';

/// Data class for navigation items.
class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Root screen that holds the bottom navigation and switches between tabs.
class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late final List<Widget> _pages;

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Beranda',
    ),
    _NavItem(
      icon: Icons.work_outline_rounded,
      selectedIcon: Icons.work_rounded,
      label: 'Loker',
    ),
    _NavItem(
      icon: Icons.assignment_turned_in_outlined,
      selectedIcon: Icons.assignment_turned_in,
      label: 'Status',
    ),
    _NavItem(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      label: 'Acara',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profil',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [
      Homescreen(onSeeAllJobs: () => setState(() => _currentIndex = 1)),
      const JobScreen(),
      const TrackScreen(),
      const EventScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileBloc()..add(LoadProfile())),
        BlocProvider(create: (context) => JobBloc()..add(const LoadJobs())),
        BlocProvider(create: (context) => HomeBloc()..add(LoadHomeData())),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: AppBottomNavbar(
          currentIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: _navItems.map((item) {
            return NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
