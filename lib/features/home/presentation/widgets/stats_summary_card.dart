import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:flutter/material.dart';

class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({
    super.key,
    required this.total,
    required this.confirmed,
    required this.completed,
    required this.cancelled,
  });

  final int total;
  final int confirmed;
  final int completed;
  final int cancelled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29606060),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Booking',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$total',
            style: AppTextStyles.display.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final tiles = [
                _StatTile(
                  value: '$confirmed',
                  label: 'Confirmed',
                  iconBg: AppColors.confirmedIconBg,
                  iconAsset: AppIcons.homeCalendar,
                  shadow: const Color(0x1A606060),
                ),
                _StatTile(
                  value: '$completed',
                  label: 'Completed',
                  iconBg: AppColors.completedIconBg,
                  iconAsset: AppIcons.homeCalendarTick,
                  shadow: const Color(0x3322C55E),
                ),
                _StatTile(
                  value: '$cancelled',
                  label: 'Cancelled',
                  iconBg: AppColors.cancelledIconBg,
                  iconAsset: AppIcons.homeCalendarRemove,
                  shadow: const Color(0x33DC3545),
                ),
              ];
              if (constraints.maxWidth < 340) {
                return Column(
                  children: [
                    for (var i = 0; i < tiles.length; i++) ...[
                      if (i > 0) const SizedBox(height: 8),
                      tiles[i],
                    ],
                  ],
                );
              }
              return Row(
                children: [
                  for (var i = 0; i < tiles.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    Expanded(child: tiles[i]),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.iconBg,
    required this.iconAsset,
    required this.shadow,
  });

  final String value;
  final String label;
  final Color iconBg;
  final String iconAsset;
  final Color shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.stroke.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(40),
            ),
            child: AppSvgIcon(iconAsset, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.bodyStrong.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
