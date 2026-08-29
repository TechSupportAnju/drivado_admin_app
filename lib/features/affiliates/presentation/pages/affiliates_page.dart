import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/affiliates/data/mock_affiliates_store.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/pages/affiliate_details_page.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/pages/affiliate_form_page.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/widgets/affiliate_card.dart';
import 'package:flutter/material.dart';

class AffiliatesPage extends StatefulWidget {
  const AffiliatesPage({super.key});

  @override
  State<AffiliatesPage> createState() => _AffiliatesPageState();
}

class _AffiliatesPageState extends State<AffiliatesPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Affiliate> get _filtered =>
      MockAffiliatesStore.instance.search(_search.text);

  Future<void> _openDetails(Affiliate affiliate) async {
    await Navigator.of(context).push(
      AppPageRoute(
        page: AffiliateDetailsPage(affiliateId: affiliate.id),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openAdd() async {
    final result = await Navigator.of(context).push<bool>(
      AppPageRoute(page: const AffiliateFormPage()),
    );
    if (result == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final total = MockAffiliatesStore.instance.all().length;
    final count = _search.text.trim().isEmpty ? total : items.length;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Column(
        children: [
          ListSubpageHeader(
            searchController: _search,
            onSearch: (_) => setState(() {}),
            onBack: () => Navigator.of(context).pop(),
            searchHint: 'Search Affiliate Name',
            footer: Row(
              children: [
                AppText(
                  'All Affiliates',
                  style: AppTextStyles.subtitle,
                  size: 16,
                  color: AppColors.textOnDark,
                  weight: FontWeight.w600,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.headerButton,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    '$count',
                    style: AppTextStyles.chip,
                    size: 11,
                    color: AppColors.textOnDark,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AppRoundedSheet(
              child: items.isEmpty
                  ? Center(
                      child: AppText(
                        'No affiliates found',
                        style: AppTextStyles.body,
                        weight: FontWeight.w500,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final affiliate = items[index];
                        return AffiliateCard(
                          affiliate: affiliate,
                          onTap: () => _openDetails(affiliate),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66FB4156),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: _openAdd,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnDark,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: AppText(
            'Add Affiliate',
            style: AppTextStyles.button,
            size: 14,
            color: AppColors.textOnDark,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
