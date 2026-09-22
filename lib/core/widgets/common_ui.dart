import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
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
            decoration: const BoxDecoration(
              color: AppColors.headerButton,
              shape: BoxShape.circle,
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

class ListSubpageHeader extends StatelessWidget {
  const ListSubpageHeader({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onBack,
    this.searchHint = 'Search',
    this.showSearchPrefix = true,
    this.searchFieldHeight = 48,
    this.hideSearchPrefixWhenFilled = false,
    this.footer,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final VoidCallback onBack;
  final String searchHint;
  final bool showSearchPrefix;
  final double searchFieldHeight;
  final bool hideSearchPrefixWhenFilled;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: AppLayout.of(context).headerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: onBack,
                  customBorder: const CircleBorder(),
                  child: const AppSvgIcon(AppIcons.summaryBack, size: 40),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      'Hello Sanjay',
                      align: TextAlign.right,
                      style: AppTextStyles.bodyStrong,
                      size: 14,
                      color: AppColors.textOnDark,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      'test@drivado.com',
                      align: TextAlign.right,
                      style: AppTextStyles.caption,
                      size: 14,
                      color: const Color(0xFFF5F6FA),
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                const AppAvatar(radius: 20),
              ],
            ),
            const SizedBox(height: 14),
            AppSearchField(
              controller: searchController,
              onChanged: onSearch,
              hint: searchHint,
              showPrefixIcon: showSearchPrefix,
              height: searchFieldHeight,
              hidePrefixWhenFilled: hideSearchPrefixWhenFilled,
            ),
            if (footer != null) ...[
              const SizedBox(height: 16),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

class AppRoundedSheet extends StatelessWidget {
  const AppRoundedSheet({
    super.key,
    required this.child,
    this.color = AppColors.background,
    this.topRadius = 20,
  });

  final Widget child;
  final Color color;
  final double topRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius)),
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
    this.showPrefixIcon = true,
    this.height = 48,
    this.hidePrefixWhenFilled = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final bool showPrefixIcon;
  final double height;
  final bool hidePrefixWhenFilled;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;
        final showPrefix =
            showPrefixIcon && !(hidePrefixWhenFilled && hasText);
        return SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: AppTextStyles.plus(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: AppTextStyles.plus(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              prefixIcon: showPrefix
                  ? const Padding(
                      padding: EdgeInsets.only(left: 16, right: 10),
                      child: AppSvgIcon(
                        AppIcons.bookingsSearch,
                        size: 18,
                      ),
                    )
                  : null,
              prefixIconConstraints: showPrefix
                  ? const BoxConstraints(minWidth: 44, minHeight: 18)
                  : null,
              suffixIcon: hasText
                  ? IconButton(
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                      },
                      icon: const Icon(
                        Icons.cancel,
                        size: 16,
                        color: Color(0xFF606060),
                      ),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        );
      },
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
  const _Dot({required this.color, this.size = 8});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class AppBadgeButton extends StatelessWidget {
  const AppBadgeButton({
    super.key,
    required this.asset,
    required this.label,
    required this.accent,
    required this.softColor,
    this.selected = false,
    this.onTap,
    this.onClear,
  });

  final String asset;
  final String label;
  final Color accent;
  final Color softColor;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : accent;

    return GestureDetector(
      onTap: selected ? null : onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: selected ? accent : softColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSvgIcon(asset, size: 24, color: foreground),
                const SizedBox(width: 2),
                AppText(
                  label,
                  style: AppTextStyles.caption,
                  weight: FontWeight.w500,
                  color: foreground,
                ),
                if (selected) ...[
                  const SizedBox(width: 7),
                  GestureDetector(
                    onTap: onClear,
                    behavior: HitTestBehavior.opaque,
                    child: const AppSvgIcon(
                      AppIcons.bookingsCloseX,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            right: selected ? -1 : -3,
            top: selected ? -4 : -3,
            child: _Dot(color: accent, size: 10),
          ),
        ],
      ),
    );
  }
}
