import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_ops_status.dart';
import 'package:flutter/material.dart';

class ChangeBookingStatusDialog extends StatelessWidget {
  const ChangeBookingStatusDialog({
    super.key,
    required this.fromStatus,
    required this.toStatus,
  });

  final String fromStatus;
  final String toStatus;

  static Future<bool> confirm(
    BuildContext context, {
    required String fromStatus,
    required String toStatus,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x99000000),
      builder: (_) => ChangeBookingStatusDialog(
        fromStatus: fromStatus,
        toStatus: toStatus,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _AlertBadge(),
            const SizedBox(height: 16),
            AppText(
              'Change Booking Status !',
              align: TextAlign.center,
              style: AppTextStyles.subtitle,
              size: 18,
              weight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  const TextSpan(
                    text: 'Are you sure you want to change the booking status from ',
                  ),
                  TextSpan(
                    text: fromStatus,
                    style: BookingOpsStatus.textStyle(fromStatus),
                  ),
                  const TextSpan(text: ' to '),
                  TextSpan(
                    text: toStatus,
                    style: BookingOpsStatus.textStyle(toStatus),
                  ),
                  const TextSpan(text: ' ?'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      minimumSize: const Size.fromHeight(44),
                      side: const BorderSide(color: Color(0xFFD0D0D0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AppText(
                      'No, Cancel',
                      style: AppTextStyles.body,
                      color: AppColors.textSecondary,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AppText(
                      'Yes, Confirm',
                      style: AppTextStyles.body,
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F1F5),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
