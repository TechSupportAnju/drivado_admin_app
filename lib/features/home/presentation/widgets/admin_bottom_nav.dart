import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Figma `Admin Bottom Navbar` (393×92): custom concave bar + 58px add button.
class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.onAdd,
    this.addButtonScale,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;
  final VoidCallback onAdd;
  final Animation<double>? addButtonScale;

  static const _barHeight = 92.0;
  static const _fabSize = 58.0;
  static const _fabOverhang = 29.0;
  static const _actionsTop = 18.0;
  static const _actionsHeight = 56.0;
  static const _actionsInset = 19.5;
  static const _itemWidth = 56.0;
  static const _itemGap = 10.0;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final extraBottom = (bottomInset - 24).clamp(0.0, bottomInset);

    Widget fab = _AddFab(onTap: onAdd);
    final scale = addButtonScale;
    if (scale != null) {
      fab = ScaleTransition(scale: scale, child: fab);
    }

    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _fabOverhang + _barHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: _fabOverhang,
                  left: 0,
                  right: 0,
                  height: _barHeight,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 9,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      AppIcons.navBarShape,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: _barHeight,
                    ),
                  ),
                ),
                Positioned(
                  top: _fabOverhang + _actionsTop,
                  left: _actionsInset,
                  right: _actionsInset,
                  height: _actionsHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _NavItem(
                            label: 'Home',
                            activeAsset: AppIcons.navHomeActive,
                            inactiveAsset: AppIcons.navHomeInactive,
                            selected: currentIndex == 0,
                            onTap: () => onChanged(0),
                          ),
                          const SizedBox(width: _itemGap),
                          _NavItem(
                            label: 'Bookings',
                            activeAsset: AppIcons.navBookingsActive,
                            inactiveAsset: AppIcons.navBookingsInactive,
                            selected: currentIndex == 1,
                            onTap: () => onChanged(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _NavItem(
                            label: 'Manage',
                            activeAsset: AppIcons.navManageActive,
                            inactiveAsset: AppIcons.navManageInactive,
                            selected: currentIndex == 2,
                            onTap: () => onChanged(2),
                          ),
                          const SizedBox(width: _itemGap),
                          _NavItem(
                            label: 'More',
                            activeAsset: AppIcons.navMoreActive,
                            inactiveAsset: AppIcons.navMoreInactive,
                            selected: currentIndex == 3,
                            onTap: () => onChanged(3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(child: fab),
                ),
              ],
            ),
          ),
          if (extraBottom > 0)
            ColoredBox(
              color: AppColors.surface,
              child: SizedBox(height: extraBottom, width: double.infinity),
            ),
        ],
      ),
    );
  }
}

class _AddFab extends StatelessWidget {
  const _AddFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AdminBottomNav._fabSize,
      height: AdminBottomNav._fabSize,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x40FB4156),
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const Center(
            child: AppSvgIcon(
              AppIcons.bookingsAdd,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.activeAsset,
    required this.inactiveAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String activeAsset;
  final String inactiveAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return SizedBox(
      width: AdminBottomNav._itemWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgIcon(
              selected ? activeAsset : inactiveAsset,
              size: 20,
            ),
            Text(
              label,
              style: AppTextStyles.navLabel.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
