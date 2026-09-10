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
    this.iconHasBackground = true,
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
    final color = destructive ? const Color(0xFFDC3545) : AppColors.textPrimary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Row(
              children: [
                if (iconHasBackground)
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AppSvgIcon(
                      icon,
                      size: 14,
                      color: destructive
                          ? const Color(0xFFDC3545)
                          : const Color(0xFF606060),
                    ),
                  )
                else
                  AppSvgIcon(icon, size: 30),
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
                        weight: FontWeight.w500,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        AppText(
                          subtitle!,
                          style: AppTextStyles.caption,
                          size: 12,
                          color: const Color(0xFF606060),
                          weight: FontWeight.w400,
                        ),
                      ],
                    ],
                  ),
                ),
                if (showChevron)
                  const AppSvgIcon(
                    AppIcons.moreChevron,
                    size: 12,
                    color: Color(0xFF606060),
                  ),
              ],
            ),
          ),
        ),
        if (showDivider) ...[
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
