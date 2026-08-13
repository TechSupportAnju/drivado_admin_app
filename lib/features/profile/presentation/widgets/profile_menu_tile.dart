import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.subtitle,
    this.destructive = false,
    this.iconHasBackground = false,
    this.showDivider = false,
    this.showChevron = true,
  });

  final String label;
  final String icon;
  final VoidCallback? onTap;
  final String? subtitle;
  final bool destructive;
  final bool iconHasBackground;
  final bool showDivider;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.primary : AppColors.textPrimary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                if (iconHasBackground)
                  AppSvgIcon(icon, size: 32)
                else
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: AppSvgIcon(
                      icon,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        label,
                        style: AppTextStyles.bodyStrong,
                        size: 14,
                        color: color,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        AppText(
                          subtitle!,
                          style: AppTextStyles.caption,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ],
                  ),
                ),
                if (showChevron)
                  const AppSvgIcon(AppIcons.moreChevron, size: 12),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 0.6, color: AppColors.divider),
      ],
    );
  }
}
