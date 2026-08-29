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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      elevation: 1.5,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 58,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(affiliate.logoColor),
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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      affiliate.name,
                      style: AppTextStyles.subtitle,
                      size: 15,
                      weight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 8),
                    _IconLine(
                      icon: AppIcons.bookingsPhone,
                      text: affiliate.primaryPhone,
                    ),
                    const SizedBox(height: 6),
                    _IconLine(
                      materialIcon: Icons.apartment_outlined,
                      text: affiliate.locationsLabel.isEmpty
                          ? '—'
                          : affiliate.locationsLabel,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: const AppSvgIcon(
                  AppIcons.homeChevronRight,
                  size: 12,
                  color: AppColors.textSecondary,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: active ? AppColors.successSoft : const Color(0xFFEEEEF2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        active ? 'Active' : 'Inactive',
        style: AppTextStyles.chip,
        size: 10,
        color: active ? AppColors.successGreen : AppColors.textSecondary,
        weight: FontWeight.w600,
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.text,
    this.icon,
    this.materialIcon,
  });

  final String text;
  final String? icon;
  final IconData? materialIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: materialIcon != null
              ? Icon(materialIcon, size: 14, color: AppColors.textSecondary)
              : AppSvgIcon(icon!, size: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: AppText(
            text,
            style: AppTextStyles.caption,
            size: 12,
            color: AppColors.textSecondary,
            weight: FontWeight.w400,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
