import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/widgets/affiliate_avatar.dart';
import 'package:drivado_admin_app/features/affiliates/domain/repositories/affiliates_repository.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/pages/affiliate_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AffiliateDetailsPage extends StatefulWidget {
  const AffiliateDetailsPage({super.key, required this.affiliateId});

  final String affiliateId;

  @override
  State<AffiliateDetailsPage> createState() => _AffiliateDetailsPageState();
}

class _AffiliateDetailsPageState extends State<AffiliateDetailsPage> {
  Affiliate? get _affiliate =>
      context.read<AffiliatesRepository>().byId(widget.affiliateId);

  Future<void> _openEdit() async {
    final current = _affiliate;
    if (current == null) return;
    final updated = await Navigator.of(context).push<bool>(
      AppPageRoute(page: AffiliateFormPage(affiliate: current)),
    );
    if (updated == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final affiliate = _affiliate;
    if (affiliate == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const AppSvgIcon(AppIcons.summaryBack, size: 40),
          ),
          title: AppText(
            'Affiliate details',
            style: AppTextStyles.subtitle,
            size: 20,
            color: AppColors.textOnDark,
            weight: FontWeight.w600,
          ),
        ),
        body: const Center(child: Text('Affiliate not found')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 72,
        leadingWidth: 64,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const AppSvgIcon(AppIcons.summaryBack, size: 40),
        ),
        title: AppText(
          'Affiliate details',
          style: AppTextStyles.subtitle,
          size: 20,
          color: AppColors.textOnDark,
          weight: FontWeight.w600,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: _openEdit,
              tooltip: 'Edit',
              icon: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.headerButton,
                  shape: BoxShape.circle,
                ),
                child: const AppSvgIcon(
                  AppIcons.summaryEdit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: AppContent(
        maxWidth: AppLayout.of(context).formMaxWidth,
        child: ListView(
          padding: AppLayout.of(context).scrollPadding(top: 16, bottom: 32),
          children: [
            _ProfileSummaryCard(affiliate: affiliate),
            const SizedBox(height: 16),
            _DetailsCard(affiliate: affiliate),
          ],
        ),
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.affiliate});

  final Affiliate affiliate;

  static const _activeBorder = Color(0xFF098C31);
  static const _activeBadgeBg = Color(0xFFE6FFE6);
  static const _activeBadgeBorder = Color(0xFF06B33A);
  static const _activeText = Color(0xFF098C31);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              AffiliateAvatar(
                size: 60,
                photoPath: affiliate.photoPath,
                initials: affiliate.displayInitials,
                backgroundColor: Color(affiliate.logoColor),
                borderColor:
                    affiliate.active ? _activeBorder : AppColors.stroke,
                initialsSize: 22,
              ),
              const SizedBox(height: 6),
              AppText(
                affiliate.name,
                align: TextAlign.center,
                style: AppTextStyles.subtitle,
                size: 14,
                weight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 6),
              MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: affiliate.active
                        ? _activeBadgeBg
                        : const Color(0xFFEEEEF2),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: affiliate.active
                          ? _activeBadgeBorder
                          : const Color(0xFFD7D8E0),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: affiliate.active
                              ? _activeText
                              : AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 2),
                      AppText(
                        affiliate.active
                            ? 'Account Active'
                            : 'Account Inactive',
                        style: AppTextStyles.chip,
                        size: 10,
                        color: affiliate.active
                            ? _activeText
                            : AppColors.textSecondary,
                        weight: FontWeight.w500,
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

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.affiliate});

  final Affiliate affiliate;

  @override
  Widget build(BuildContext context) {
    final emails = affiliate.emails;
    final phones = affiliate.phones;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _DetailRow(
              icon: AppIcons.affiliateUser,
              label: 'Contact Person',
              value: affiliate.contactPerson,
            ),
            _DetailRow(
              icon: AppIcons.affiliateLocation,
              label: 'Address',
              value: affiliate.address,
            ),
            _DetailRow(
              icon: AppIcons.affiliateBuilding,
              label: 'City',
              value: affiliate.city,
            ),
            _DetailRow(
              icon: AppIcons.affiliateCourthouse,
              label: 'Country',
              value: affiliate.country,
            ),
            _DetailRow(
              icon: AppIcons.affiliateSms,
              label: "Email ID's",
              value: emails.isEmpty ? '—' : emails.join('\n'),
            ),
            _DetailRow(
              icon: AppIcons.affiliatePhoneInTalk,
              label: 'Contact number',
              value: phones.isEmpty ? '—' : phones.join('\n'),
            ),
            _DetailRow(
              icon: AppIcons.affiliateCompanyId,
              label: 'Company ID',
              value: affiliate.affiliateId,
              iconWidth: 18,
              iconHeight: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconWidth,
    this.iconHeight,
  });

  final String icon;
  final String label;
  final String value;
  final double? iconWidth;
  final double? iconHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 117,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: AppSvgIcon(
                    icon,
                    size: 14,
                    width: iconWidth,
                    height: iconHeight,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    label,
                    style: AppTextStyles.caption,
                    size: 12,
                    color: const Color(0xFF606060),
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppText(
              value,
              style: AppTextStyles.bodyStrong,
              size: 12,
              color: AppColors.textPrimary,
              weight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
