import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/widgets/affiliate_avatar.dart';
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
  static const _inactiveBadgeBg = Color(0xFFEEEEF2);
  static const _inactiveBadgeBorder = Color(0xFFD7D8E0);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AffiliateAvatar(
                      size: 48,
                      photoPath: affiliate.photoPath,
                      initials: affiliate.displayInitials,
                      backgroundColor: Color(affiliate.logoColor),
                      borderColor: affiliate.active
                          ? _activeBorder
                          : AppColors.stroke,
                      initialsSize: 16,
                    ),
                    const SizedBox(height: 12),
                    _StatusBadge(active: affiliate.active),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const AppSvgIcon(
                            AppIcons.affiliateArrowSquareRight,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _IconLine(
                        icon: AppIcons.affiliateCall,
                        text: affiliate.primaryPhone,
                        iconSize: 12,
                        center: true,
                      ),
                      const SizedBox(height: 4),
                      _IconLine(
                        icon: AppIcons.affiliateBuilding,
                        text: affiliate.locationsLabel.isEmpty
                            ? '—'
                            : affiliate.locationsLabel,
                        iconSize: 12,
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
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.15,
      child: SizedBox(
        width: 48,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            constraints: const BoxConstraints(minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active
                  ? AffiliateCard._activeBadgeBg
                  : AffiliateCard._inactiveBadgeBg,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: active
                    ? AffiliateCard._activeBadgeBorder
                    : AffiliateCard._inactiveBadgeBorder,
                width: 0.5,
              ),
            ),
            child: Text(
              active ? 'Active' : 'Inactive',
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: AppTextStyles.plus(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: active
                    ? AffiliateCard._activeBadgeText
                    : AppColors.textSecondary,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.text,
    required this.icon,
    this.iconSize = 12,
    this.center = false,
  });

  final String text;
  final String icon;
  final double iconSize;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        AppSvgIcon(icon, size: iconSize),
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
