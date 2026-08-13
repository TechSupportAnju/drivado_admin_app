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
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(onBack == null ? 20 : 8, 16, 20, 16),
          child: Row(
            children: [
              if (onBack != null) ...[
                IconButton(
                  onPressed: onBack,
                  tooltip: 'Back',
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: AppText(
                  title,
                  style: AppTextStyles.subtitle,
                  size: onBack == null ? 24 : 20,
                ),
              ),
            ],
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
  });

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppSvgIcon(AppIcons.moreAvatar, size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                name,
                style: AppTextStyles.subtitle,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 4),
              AppText(
                email,
                style: AppTextStyles.bodyStrong,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
