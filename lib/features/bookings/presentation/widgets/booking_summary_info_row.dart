import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class BookingSummaryInfoRow extends StatelessWidget {
  const BookingSummaryInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.badge,
  });

  final String icon;
  final String label;
  final String value;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 132,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: AppSvgIcon(icon, size: 14),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: AppText(
                  label,
                  style: AppTextStyles.caption,
                  color: AppColors.textSecondary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: AppText(
                  value,
                  style: AppTextStyles.caption,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              if (badge != null && badge!.isNotEmpty) ...[
                const SizedBox(width: 6),
                AppText(
                  badge!,
                  style: AppTextStyles.chip,
                  color: AppColors.successGreen,
                  weight: FontWeight.w700,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
