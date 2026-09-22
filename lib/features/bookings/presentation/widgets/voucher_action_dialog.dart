import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class VoucherActionDialog extends StatelessWidget {
  const VoucherActionDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final String icon;
  final String title;
  final String message;

  static Future<bool> confirm(
    BuildContext context, {
    required String icon,
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierColor: const Color(0x66000000),
      builder: (_) => VoucherActionDialog(
        icon: icon,
        title: title,
        message: message,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgIcon(icon, size: 56),
            const SizedBox(height: 16),
            AppText(
              title,
              align: TextAlign.center,
              style: AppTextStyles.subtitle,
              size: 16,
              weight: FontWeight.w700,
            ),
            const SizedBox(height: 8),
            AppText(
              message,
              align: TextAlign.center,
              style: AppTextStyles.body,
              size: 13,
              weight: FontWeight.w400,
              height: 1.4,
              color: AppColors.textSecondary,
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
