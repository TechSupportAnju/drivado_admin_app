import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/features/dashboard/domain/entities/dashboard_entities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingListTile extends StatelessWidget {
  const BookingListTile({
    super.key,
    required this.booking,
    this.onTap,
  });

  final BookingSummary booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy').format(booking.scheduledAt);
    final (label, bg, border, fg) = switch (booking.status) {
      BookingStatus.confirmed => (
          'Upcoming',
          AppColors.successBg,
          AppColors.successBorder,
          AppColors.success,
        ),
      BookingStatus.completed => (
          'Completed',
          AppColors.infoBg,
          AppColors.infoBorder,
          AppColors.info,
        ),
      BookingStatus.cancelled => (
          'Cancelled',
          AppColors.dangerBg,
          AppColors.dangerBorder,
          AppColors.danger,
        ),
      BookingStatus.pending => (
          'Upcoming',
          AppColors.successBg,
          AppColors.successBorder,
          AppColors.success,
        ),
    };

    final iconAsset = switch (booking.status) {
      BookingStatus.completed => AppIcons.homeCalendarTick,
      BookingStatus.cancelled => AppIcons.homeCalendarRemove,
      _ => AppIcons.homeCalendar,
    };

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.stroke, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.bookingIconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: AppSvgIcon(iconAsset, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.id, style: AppTextStyles.bodyStrong),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const AppSvgIcon(
                          AppIcons.homeCalendar,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: border, width: 0.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: AppTextStyles.caption.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const AppSvgIcon(
                AppIcons.homeChevronRight,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
