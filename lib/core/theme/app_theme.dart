import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_system_ui.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.splashBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.required,
      ),
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);
    final primaryTextTheme =
        GoogleFonts.plusJakartaSansTextTheme(base.primaryTextTheme);

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textOnDark,
        systemOverlayStyle: AppSystemUi.darkHeader,
        titleTextStyle: AppTextStyles.subtitle.copyWith(
          color: AppColors.textOnDark,
        ),
        toolbarTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textOnDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: AppTextStyles.plus(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: AppTextStyles.plus(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        extendedTextStyle: AppTextStyles.plus(fontWeight: FontWeight.w600),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black26,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: AppTextStyles.navLabel.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelStyle: AppTextStyles.navLabel,
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStatePropertyAll(AppTextStyles.navLabel),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: AppTextStyles.plus(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.plus(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: AppTextStyles.plus(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: AppTextStyles.body,
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: AppTextStyles.caption,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppTextStyles.subtitle,
        subtitleTextStyle: AppTextStyles.fieldHint,
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.stroke),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppTextStyles.fieldHint,
        labelStyle: AppTextStyles.fieldHint,
        floatingLabelStyle: AppTextStyles.fieldHint.copyWith(
          color: AppColors.primary,
        ),
        errorStyle: AppTextStyles.plus(
          fontSize: 11,
          color: Colors.red,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.stroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.stroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}
