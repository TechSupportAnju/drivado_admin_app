import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:flutter/material.dart';

class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 72,
      padding: EdgeInsets.zero,
      color: AppColors.surface,
      elevation: 12,
      shadowColor: Colors.black26,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              label: 'Home',
              activeAsset: AppIcons.navHomeActive,
              inactiveAsset: AppIcons.navHomeInactive,
              selected: currentIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _NavItem(
              label: 'Bookings',
              activeAsset: AppIcons.navBookingsActive,
              inactiveAsset: AppIcons.navBookingsInactive,
              selected: currentIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
          const SizedBox(width: 56),
          Expanded(
            child: _NavItem(
              label: 'Manage',
              activeAsset: AppIcons.navManageActive,
              inactiveAsset: AppIcons.navManageInactive,
              selected: currentIndex == 2,
              onTap: () => onChanged(2),
            ),
          ),
          Expanded(
            child: _NavItem(
              label: 'More',
              activeAsset: AppIcons.navMoreActive,
              inactiveAsset: AppIcons.navMoreInactive,
              selected: currentIndex == 3,
              onTap: () => onChanged(3),
            ),
          ),
        ],
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
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSvgIcon(
            selected ? activeAsset : inactiveAsset,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.navLabel.copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
