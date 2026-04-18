import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final headingLarge = GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final bodySmall = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final bodySmallBold = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  static final bodyMedium = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w200,
    color: AppColors.white,
  );

  static final bodyExtraSmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
  );

  static final bodyExtraSmallBold = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryLight,
  );

  static final bodyExtraSmallLight = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
}
