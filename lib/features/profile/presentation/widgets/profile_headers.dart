import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class MorePageHeader extends StatelessWidget {
  const MorePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryDark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 23),
          child: Center(
            child: AppText(
              'More',
              style: AppTextStyles.subtitle,
              size: 20,
              color: AppColors.textOnDark,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePageHeader extends StatelessWidget {
  const ProfilePageHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryDark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          child: SizedBox(
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (onBack != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onBack,
                      padding: EdgeInsets.zero,
                      icon: const AppSvgIcon(AppIcons.summaryBack, size: 40),
                    ),
                  ),
                AppText(
                  title,
                  style: AppTextStyles.subtitle,
                  size: 20,
                  color: AppColors.textOnDark,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileIdentityTile extends StatelessWidget {
  const ProfileIdentityTile({
    super.key,
    required this.name,
    required this.email,
    this.onTap,
  });

  final String name;
  final String email;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        const AppSvgIcon(AppIcons.moreAvatar, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                name,
                style: AppTextStyles.subtitle,
                size: 16,
                color: AppColors.textPrimary,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 4),
              AppText(
                email,
                style: AppTextStyles.bodyStrong,
                size: 14,
                color: const Color(0xFF606060),
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: content,
    );
  }
}
