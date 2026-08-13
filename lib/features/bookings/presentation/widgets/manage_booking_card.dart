import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_status_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageBookingCard extends StatelessWidget {
  const ManageBookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  final ManagedBooking booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, MMM d').format(booking.scheduledAt);
    final time = DateFormat('HH:mm').format(booking.scheduledAt);
    final status = BookingStatusStyle.of(booking.status);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1.5,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppSvgIcon(AppIcons.bookingsPassenger, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: AppText(
                          booking.customer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label,
                          weight: FontWeight.w700,
                        ),
                      ),
                      AppPill(
                        label: status.label,
                        background: status.background,
                        foreground: status.foreground,
                        borderColor: status.borderColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 88,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              booking.id,
                              style: AppTextStyles.caption,
                              weight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              date,
                              style: AppTextStyles.chip,
                              weight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              time,
                              size: 22,
                              weight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (booking.tripType.toLowerCase() != 'hourly')
                              _RouteLine(
                                asset: AppIcons.bookingsSource,
                                text: booking.pickup,
                                isLast: false,
                              ),
                            _RouteLine(
                              asset: AppIcons.bookingsDestination,
                              text: booking.tripType.toLowerCase() == 'hourly'
                                  ? booking.pickup
                                  : booking.dropoff,
                              isLast: true,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                AppPill(
                                  label: booking.tripType,
                                  background: AppColors.chipPrimaryFill,
                                  foreground: AppColors.primary,
                                ),
                                AppPill(
                                  label: booking.metaLabel,
                                  background: AppColors.chipPrimaryFill,
                                  foreground: AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ColoredBox(
              color: AppColors.inkBar,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    const AppSvgIcon(
                      AppIcons.bookingsDriver,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppText(
                        booking.driverName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                        color: Colors.white,
                      ),
                    ),
                    const AppSvgIcon(
                      AppIcons.bookingsPhone,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    AppText(
                      booking.driverPhone,
                      style: AppTextStyles.caption,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      booking.vehicle.toUpperCase(),
                      style: AppTextStyles.caption,
                      weight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                    height: 16,
                    child: ColoredBox(color: AppColors.stroke),
                  ),
                  Expanded(
                    child: AppText(
                      booking.amount,
                      align: TextAlign.right,
                      style: AppTextStyles.label,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine({
    required this.asset,
    required this.text,
    required this.isLast,
  });

  final String asset;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 16,
            child: Column(
              children: [
                AppSvgIcon(asset, size: 14),
                if (!isLast)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: SizedBox(
                        width: 1.2,
                        child: CustomPaint(painter: _DashPainter()),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
              child: AppText(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.chip,
                weight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF585858)
      ..strokeWidth = 1.2;
    const dash = 3.0;
    const gap = 2.0;
    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dash), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
