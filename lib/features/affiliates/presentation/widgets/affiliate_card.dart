import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:flutter/material.dart';

class AffiliateCard extends StatelessWidget {
  const AffiliateCard({
    super.key,
    required this.affiliate,
    required this.onTap,
  });

  final Affiliate affiliate;
  final VoidCallback onTap;

  static const _activeBorder = Color(0xFF098C31);
  static const _activeBadgeBg = Color(0xFFE6FFE6);
  static const _activeBadgeBorder = Color(0xFF06B33A);
  static const _activeBadgeText = Color(0xFF098C31);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 48,
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(affiliate.logoColor),
                        border: Border.all(
                          color: affiliate.active
                              ? _activeBorder
                              : AppColors.stroke,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        affiliate.displayInitials,
                        style: AppTextStyles.subtitle,
                        size: 16,
                        color: AppColors.textOnDark,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _StatusBadge(active: affiliate.active),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              affiliate.name,
                              style: AppTextStyles.subtitle,
                              size: 12,
                              weight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const AppSvgIcon(
                            AppIcons.homeChevronRight,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _IconLine(
                        icon: AppIcons.bookingsPhone,
                        text: affiliate.primaryPhone,
                      ),
                      const SizedBox(height: 4),
                      _IconLine(
                        icon: AppIcons.moreAffiliate,
                        text: affiliate.locationsLabel.isEmpty
                            ? '—'
                            : affiliate.locationsLabel,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: active
            ? AffiliateCard._activeBadgeBg
            : const Color(0xFFEEEEF2),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: active
              ? AffiliateCard._activeBadgeBorder
              : AppColors.stroke,
          width: 0.5,
        ),
      ),
      child: AppText(
        active ? 'Active' : 'Inactive',
        align: TextAlign.center,
        style: AppTextStyles.chip,
        size: 10,
        color: active
            ? AffiliateCard._activeBadgeText
            : AppColors.textSecondary,
        weight: FontWeight.w500,
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.text,
    required this.icon,
  });

  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: AppSvgIcon(icon, size: 12, color: const Color(0xFF606060)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppText(
            text,
            style: AppTextStyles.caption,
            size: 10,
            color: const Color(0xFF606060),
            weight: FontWeight.w500,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
