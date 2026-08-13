import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.radius = 22});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.headerMuted,
      child: AppSvgIcon(AppIcons.homeAvatar, size: radius + 6),
    );
  }
}

class UserGreeting extends StatelessWidget {
  const UserGreeting({
    super.key,
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Hello $name',
          style: AppTextStyles.bodyStrong,
          color: AppColors.textOnDark,
          weight: FontWeight.w700,
        ),
        const SizedBox(height: 2),
        AppText(
          email,
          style: AppTextStyles.caption,
          color: AppColors.textOnDark.withValues(alpha: 0.7),
          weight: FontWeight.w400,
        ),
      ],
    );
  }
}

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    super.key,
    required this.asset,
    required this.onTap,
    this.showDot = false,
  });

  final String asset;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.headerIconBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.headerMuted),
            ),
            child: AppSvgIcon(asset, size: 20, color: Colors.white),
          ),
        ),
        if (showDot)
          const Positioned(
            right: 8,
            top: 8,
            child: _Dot(color: AppColors.primary),
          ),
      ],
    );
  }
}

class AppRoundedSheet extends StatelessWidget {
  const AppRoundedSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: child,
    );
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.fieldHint,
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12),
          child: AppSvgIcon(
            AppIcons.bookingsSearch,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 1),
      ),
      child: AppText(
        label,
        style: AppTextStyles.chip,
        color: foreground,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, this.bordered = false});

  final Color color;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: bordered ? Border.all(color: Colors.white) : null,
      ),
    );
  }
}

class AppBadgeButton extends StatelessWidget {
  const AppBadgeButton({
    super.key,
    required this.color,
    required this.asset,
    required this.iconColor,
    required this.label,
  });

  final Color color;
  final String asset;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              AppSvgIcon(asset, color: iconColor),
              const SizedBox(width: 4),
              AppText(
                label,
                style: AppTextStyles.caption,
                weight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
        Positioned(
          right: -2,
          top: -2,
          child: _Dot(color: iconColor, bordered: true),
        ),
      ],
    );
  }
}
