import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_ops_status.dart';
import 'package:flutter/material.dart';

class BookingStatusMenu extends StatelessWidget {
  const BookingStatusMenu({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierColor: const Color(0x99000000),
      builder: (_) => const BookingStatusMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 72),
      backgroundColor: AppColors.surface,
      elevation: 12,
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < BookingOpsStatus.values.length; i++) ...[
              if (i > 0)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider,
                ),
              _StatusRow(label: BookingOpsStatus.values[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(label),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              label,
              style: BookingOpsStatus.textStyle(label),
            ),
          ),
        ),
      ),
    );
  }
}
