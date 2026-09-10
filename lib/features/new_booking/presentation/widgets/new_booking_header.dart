import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:flutter/material.dart';

enum BookingShortcut { newBooking, flatRate, offlineBooking }

class NewBookingHeader extends StatelessWidget {
  const NewBookingHeader({
    super.key,
    required this.shortcut,
    required this.onShortcutChanged,
    this.onBack,
  });

  final BookingShortcut shortcut;
  final ValueChanged<BookingShortcut> onShortcutChanged;
  final VoidCallback? onBack;

  static String greetingFor(DateTime now) {
    final hour = now.hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryDark,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.45,
              child: Image.asset(
                'assets/images/auth_header_stars.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (onBack != null) ...[
                        IconButton(
                          onPressed: onBack,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          icon: const AppSvgIcon(
                            AppIcons.summaryBack,
                            size: 40,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      const Expanded(child: _ExploreGreeting()),
                      HeaderIconButton(
                        asset: AppIcons.homeNotification,
                        showDot: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _ShortcutRow(
                    selected: shortcut,
                    onChanged: onShortcutChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreGreeting extends StatelessWidget {
  const _ExploreGreeting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          NewBookingHeader.greetingFor(DateTime.now()),
          style: AppTextStyles.bodyStrong,
          size: 14,
          color: AppColors.textOnDark,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            text: 'Let’s Explore ',
            style: AppTextStyles.plus(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textOnDark,
              height: 1.25,
            ),
            children: [
              TextSpan(
                text: 'World',
                style: AppTextStyles.plus(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        AppText(
          'With Us',
          style: AppTextStyles.plus(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textOnDark,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({required this.selected, required this.onChanged});

  final BookingShortcut selected;
  final ValueChanged<BookingShortcut> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF403030),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _ShortcutChip(
            label: 'New Booking',
            icon: AppIcons.moreNewBooking,
            selected: selected == BookingShortcut.newBooking,
            onTap: () => onChanged(BookingShortcut.newBooking),
          ),
          _ShortcutChip(
            label: 'Flat Rate',
            icon: AppIcons.moreFlatRates,
            selected: selected == BookingShortcut.flatRate,
            onTap: () => onChanged(BookingShortcut.flatRate),
          ),
          _ShortcutChip(
            label: 'Offline Booking',
            icon: AppIcons.moreOfflineBooking,
            selected: selected == BookingShortcut.offlineBooking,
            onTap: () => onChanged(BookingShortcut.offlineBooking),
          ),
        ],
      ),
    );
  }
}

class _ShortcutChip extends StatelessWidget {
  const _ShortcutChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: selected
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFB4156),
                        Color(0xFFE0324A),
                      ],
                    )
                  : null,
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSvgIcon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : const Color(0xFF9A8C8C),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: AppText(
                    label,
                    style: AppTextStyles.bodyStrong,
                    size: 12,
                    color: selected ? Colors.white : const Color(0xFF9A8C8C),
                    weight: selected ? FontWeight.w700 : FontWeight.w400,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
