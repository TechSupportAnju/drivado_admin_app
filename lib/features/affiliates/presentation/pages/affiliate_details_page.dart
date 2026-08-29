import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/affiliates/data/mock_affiliates_store.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/pages/affiliate_form_page.dart';
import 'package:flutter/material.dart';

class AffiliateDetailsPage extends StatefulWidget {
  const AffiliateDetailsPage({super.key, required this.affiliateId});

  final String affiliateId;

  @override
  State<AffiliateDetailsPage> createState() => _AffiliateDetailsPageState();
}

class _AffiliateDetailsPageState extends State<AffiliateDetailsPage> {
  Affiliate? get _affiliate =>
      MockAffiliatesStore.instance.byId(widget.affiliateId);

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
        backgroundColor: AppColors.background,
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
            size: 18,
            color: AppColors.textOnDark,
          ),
        ),
        body: const Center(child: Text('Affiliate not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
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
          size: 18,
          color: AppColors.textOnDark,
          weight: FontWeight.w500,
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
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _ProfileSummaryCard(affiliate: affiliate),
          const SizedBox(height: 14),
          _DetailsCard(affiliate: affiliate),
        ],
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.affiliate});

  final Affiliate affiliate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(affiliate.logoColor),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: AppText(
                affiliate.displayInitials,
                style: AppTextStyles.subtitle,
                size: 28,
                color: AppColors.textOnDark,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            AppText(
              affiliate.name,
              align: TextAlign.center,
              style: AppTextStyles.subtitle,
              size: 18,
              weight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: affiliate.active
                    ? AppColors.successSoft
                    : const Color(0xFFEEEEF2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: affiliate.active
                          ? AppColors.successGreen
                          : AppColors.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AppText(
                    affiliate.active ? 'Account Active' : 'Account Inactive',
                    style: AppTextStyles.chip,
                    size: 12,
                    color: affiliate.active
                        ? AppColors.successGreen
                        : AppColors.textSecondary,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          children: [
            _DetailRow(
              icon: Icons.person_outline_rounded,
              label: 'Contact Person',
              value: affiliate.contactPerson,
            ),
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: affiliate.address,
            ),
            _DetailRow(
              icon: Icons.apartment_outlined,
              label: 'City',
              value: affiliate.city,
            ),
            _DetailRow(
              icon: Icons.account_balance_outlined,
              label: 'Country',
              value: affiliate.country,
            ),
            _DetailRow(
              icon: Icons.mail_outline_rounded,
              label: "Email ID's",
              value: emails.isEmpty ? '—' : emails.join('\n'),
            ),
            _DetailRow(
              icon: Icons.phone_outlined,
              label: 'Contact number',
              value: phones.isEmpty ? '—' : phones.join('\n'),
            ),
            _DetailRow(
              icon: Icons.badge_outlined,
              label: 'Company ID',
              value: affiliate.affiliateId,
              showDivider: false,
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
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              SizedBox(
                width: 110,
                child: AppText(
                  label,
                  style: AppTextStyles.caption,
                  size: 12,
                  color: AppColors.textSecondary,
                  weight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppText(
                  value,
                  style: AppTextStyles.bodyStrong,
                  size: 13,
                  color: AppColors.textPrimary,
                  weight: FontWeight.w500,
                  height: 1.4,
                  align: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}
