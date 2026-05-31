import 'package:flutter/material.dart';

/// Centralized color palette for the DCC Mobile app.
/// Use these constants instead of hardcoding Color values throughout the app.
class AppColors {
  AppColors._();

  // Brand colors
  static const Color primary = Color(0xFF003A75);
  static const Color primaryLight = Color(0xFF003A75);
  static const Color secondary = Color(0xFF4C56AF);
  static const Color tertiary = Color(0xFF652900);
  static const Color accent = Color(0xFF1E5BBF);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F9FB);
  static const Color textMuted = Color(0xFF718096);

  // Surface colors (Material 3 style)
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);

  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF424751);
  static const Color onPrimaryFixed = Color(0xFF001B3D);
  static const Color outline = Color(0xFF727782);
  static const Color outlineVariant = Color(0xFFC2C6D3);

  static const Color error = Color(0xFFBA1A1A);

  // Navigation
  static const Color navIndicator = Color(0xFFE5EBF5);
  static const Color navInactive = Color(0xFF718096);

  // Card & Surface
  static const Color cardShadow = Color(0x0A000000); // black 4%
  static const Color divider = Color(0xFFF1F5F9);
}
