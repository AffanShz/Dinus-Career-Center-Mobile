import 'package:flutter/material.dart';

/// Centralized color palette for the DCC Mobile app.
/// Use these constants instead of hardcoding Color values throughout the app.
class AppColors {
  AppColors._();

  // Brand colors
  static const Color primary = Color(0xFF032D60);
  static const Color primaryLight = Color(0xFF003A75);
  static const Color accent = Color(0xFF1E5BBF);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color secondary = Color(0xFF424751);
  static const Color textMuted = Color(0xFF718096);

  // Navigation
  static const Color navIndicator = Color(0xFFE5EBF5);
  static const Color navInactive = Color(0xFF718096);

  // Card & Surface
  static const Color cardShadow = Color(0x0A000000); // black 4%
  static const Color divider = Color(0xFFF1F5F9);
}
