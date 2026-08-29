import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/coupons/data/mock_coupons_store.dart';
import 'package:drivado_admin_app/features/coupons/domain/entities/coupon.dart';
import 'package:drivado_admin_app/features/coupons/presentation/pages/coupon_form_page.dart';
import 'package:drivado_admin_app/features/coupons/presentation/widgets/coupon_card.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/confirm_action_dialog.dart';
import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final _search = TextEditingController();
  CouponType _tab = CouponType.oneTime;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Coupon> get _filtered =>
      MockCouponsStore.instance.byType(_tab, query: _search.text);

  Future<void> _openForm({Coupon? coupon}) async {
    final result = await Navigator.of(context).push<bool>(
      AppPageRoute(
        page: CouponFormPage(
          type: coupon?.type ?? _tab,
          coupon: coupon,
        ),
      ),
    );
    if (result == true && mounted) setState(() {});
  }

  void _confirmDelete(Coupon coupon) {
    ConfirmActionDialog.show(
      context,
      icon: AppIcons.profileDelete,
      title: 'Delete this coupon?',
      message:
          '“${coupon.code}” will be removed. This action cannot be undone.',
      primaryLabel: 'Keep coupon',
      secondaryLabel: 'Delete',
      onPrimary: () => Navigator.of(context).pop(),
      onSecondary: () {
        Navigator.of(context).pop();
        MockCouponsStore.instance.delete(coupon.id);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final isOneTime = _tab == CouponType.oneTime;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Column(
        children: [
          ListSubpageHeader(
            searchController: _search,
            onSearch: (_) => setState(() {}),
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: AppRoundedSheet(
              child: Column(
                children: [
                  _CouponTabs(
                    tab: _tab,
                    onChanged: (tab) => setState(() {
                      _tab = tab;
                      _search.clear();
                    }),
                  ),
                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: AppText(
                              'No coupons found',
                              style: AppTextStyles.body,
                              weight: FontWeight.w500,
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final coupon = items[index];
                              return CouponCard(
                                coupon: coupon,
                                onEdit: () => _openForm(coupon: coupon),
                                onDelete: () => _confirmDelete(coupon),
                              );
                            },
                          ),
                  ),
                ],
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
          onPressed: () => _openForm(),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnDark,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: AppText(
            isOneTime ? 'Create Coupon By Count +' : 'Create New Coupon +',
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

class _CouponTabs extends StatelessWidget {
  const _CouponTabs({required this.tab, required this.onChanged});

  final CouponType tab;
  final ValueChanged<CouponType> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              label: 'One Time',
              selected: tab == CouponType.oneTime,
              onTap: () => onChanged(CouponType.oneTime),
            ),
          ),
          Expanded(
            child: _TabItem(
              label: 'Unlimited',
              selected: tab == CouponType.unlimited,
              onTap: () => onChanged(CouponType.unlimited),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: AppText(
              label,
              align: TextAlign.center,
              style: AppTextStyles.bodyStrong,
              size: 15,
              weight: FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2,
            width: double.infinity,
            color: selected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
