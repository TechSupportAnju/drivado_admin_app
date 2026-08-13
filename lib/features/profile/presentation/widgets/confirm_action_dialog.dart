import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ConfirmActionDialog extends StatelessWidget {
  const ConfirmActionDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
  });

  final String icon;
  final String title;
  final String message;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  static Future<void> show(
    BuildContext context, {
    required String icon,
    required String title,
    required String message,
    required String primaryLabel,
    required String secondaryLabel,
    required VoidCallback onPrimary,
    required VoidCallback onSecondary,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => ConfirmActionDialog(
        icon: icon,
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        secondaryLabel: secondaryLabel,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgIcon(icon, size: 48),
            const SizedBox(height: 16),
            AppText(
              title,
              align: TextAlign.center,
              style: AppTextStyles.body,
              color: AppColors.textPrimary,
              weight: FontWeight.w600,
              height: 1.4,
            ),
            const SizedBox(height: 8),
            AppText(
              message,
              align: TextAlign.center,
              style: AppTextStyles.caption,
              weight: FontWeight.w400,
              height: 1.4,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onPrimary,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: AppText(
                      primaryLabel,
                      style: AppTextStyles.body,
                      color: Colors.white,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSecondary,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      minimumSize: const Size.fromHeight(42),
                      side: const BorderSide(color: AppColors.textSecondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: AppText(
                      secondaryLabel,
                      style: AppTextStyles.body,
                      weight: FontWeight.w500,
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
