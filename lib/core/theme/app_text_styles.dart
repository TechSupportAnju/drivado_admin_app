import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  static TextStyle plus({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get display => plus(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnDark,
        height: 1.3,
      );

  static TextStyle get title => plus(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColors.textLabel,
      );

  static TextStyle get subtitle => plus(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get body => plus(
        fontSize: 14,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyStrong => plus(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get label => plus(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => plus(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get chip => plus(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get button => plus(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnDark,
        height: 1.4,
      );

  static TextStyle get fieldHint => plus(
        fontSize: 13,
        color: AppColors.textSecondary,
        height: 16 / 13,
      );

  static TextStyle get navLabel => plus(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.1,
        height: 2,
      );
}
