import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/features/dashboard/domain/entities/dashboard_entities.dart';
import 'package:flutter/material.dart';

class BookingStatusStyle {
  const BookingStatusStyle({
    required this.label,
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color? borderColor;

  static BookingStatusStyle of(BookingStatus status) => switch (status) {
        BookingStatus.confirmed => const BookingStatusStyle(
            label: 'Confirmed',
            background: Color(0xFFFFFFFF),
            foreground: AppColors.successGreen,
            borderColor: AppColors.successGreen,
          ),
        BookingStatus.pending => const BookingStatusStyle(
            label: 'Pending',
            background: AppColors.warningSoft,
            foreground: AppColors.warning,
          ),
        BookingStatus.completed => const BookingStatusStyle(
            label: 'Completed',
            background: AppColors.successSoft,
            foreground: AppColors.successGreen,
          ),
        BookingStatus.cancelled => const BookingStatusStyle(
            label: 'Cancelled',
            background: AppColors.dangerSoft,
            foreground: AppColors.required,
          ),
      };
}
