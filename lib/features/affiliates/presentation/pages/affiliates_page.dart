import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:drivado_admin_app/features/affiliates/domain/repositories/affiliates_repository.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/pages/affiliate_details_page.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/pages/affiliate_form_page.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/widgets/affiliate_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      context.read<AffiliatesRepository>().search(_search.text);

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
    final total = context.read<AffiliatesRepository>().all().length;
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
            showSearchPrefix: true,
            searchFieldHeight: 52,
            hideSearchPrefixWhenFilled: true,
            footer: Row(
              children: [
                AppText(
                  'All Affiliates',
                  style: AppTextStyles.subtitle,
                  size: 14,
                  color: const Color(0xFFADADAD),
                  weight: FontWeight.w500,
                ),
                const SizedBox(width: 10),
                Container(
                  constraints: const BoxConstraints(minWidth: 38),
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F3737),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: AppText(
                    '$count',
                    style: AppTextStyles.chip,
                    size: 12,
                    color: AppColors.textOnDark,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AppRoundedSheet(
              color: const Color(0xFFF7F7F8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  items.isEmpty
                      ? Center(
                          child: AppText(
                            'No affiliates found',
                            style: AppTextStyles.body,
                            weight: FontWeight.w500,
                          ),
                        )
                      : AppContent(
                          child: ResponsiveCardList(
                            padding: AppLayout.of(context)
                                .scrollPadding(bottom: 100),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final affiliate = items[index];
                              return AffiliateCard(
                                affiliate: affiliate,
                                onTap: () => _openDetails(affiliate),
                              );
                            },
                          ),
                        ),
                  Positioned(
                    right: 16,
                    bottom: MediaQuery.paddingOf(context).bottom + 16,
                    child: _AddAffiliateButton(onPressed: _openAdd),
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

class _AddAffiliateButton extends StatelessWidget {
  const _AddAffiliateButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFB4156),
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          minimumSize: const Size(0, 42),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: AppText(
          'Add Affiliate',
          style: AppTextStyles.button,
          size: 16,
          height: 18 / 16,
          color: AppColors.textOnDark,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}
