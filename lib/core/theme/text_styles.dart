import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';

/// Centralized text styles for the DCC Mobile app.
/// Use these constants for consistent typography across screens.
class AppTextStyles {
  AppTextStyles._();

  // Headline - Plus Jakarta Sans
  static final headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimaryFixed,
    letterSpacing: -0.5,
  );

  static final headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimaryFixed,
  );

  static final headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimaryFixed,
  );

  // Body - Manrope
  static final bodyLarge = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  static final bodyMedium = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  static final bodySmall = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );

  static final labelLarge = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final labelSmall = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurfaceVariant,
  );

  // Legacy/Compatibility (to be phased out or updated)
  static final headingLargeLegacy = GoogleFonts.plusJakartaSans(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final bodySmallLegacy = GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}
