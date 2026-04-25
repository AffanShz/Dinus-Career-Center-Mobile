import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';

class AppBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  const AppBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: AppColors.navIndicator,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              return GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: AppColors.primary, size: 28);
              }
              return const IconThemeData(
                color: AppColors.navInactive,
                size: 26,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            backgroundColor: AppColors.white,
            elevation: 0,
            height: 75,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations,
          ),
        ),
      ),
    );
  }
}
