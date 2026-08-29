import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

abstract final class BookingOpsStatus {
  static const enroute = 'Enroute';
  static const arrived = 'Arrived';
  static const pob = 'POB';
  static const completed = 'Completed';
  static const noShow = 'No Show';

  static const values = [enroute, arrived, pob, completed, noShow];

  static Color colorOf(String status) {
    final key = status.trim().toLowerCase();
    if (key == 'enroute' || key == 'en-route' || key == 'en route') {
      return AppColors.statusEnroute;
    }
    if (key == 'arrived') return AppColors.statusArrived;
    if (key == 'pob') return AppColors.statusPob;
    if (key == 'completed') return AppColors.statusCompleted;
    if (key == 'no show' || key == 'noshow' || key == 'no-show') {
      return AppColors.statusNoShow;
    }
    if (key == 'confirmed') return AppColors.successGreen;
    if (key.contains('cancel')) return AppColors.required;
    return AppColors.textSecondary;
  }

  static TextStyle textStyle(String status, {double fontSize = 14}) {
    return AppTextStyles.plus(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: colorOf(status),
    );
  }
}
