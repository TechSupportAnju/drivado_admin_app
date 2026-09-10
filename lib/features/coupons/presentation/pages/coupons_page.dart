import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/coupons/domain/entities/coupon.dart';
import 'package:drivado_admin_app/features/coupons/domain/repositories/coupons_repository.dart';
import 'package:drivado_admin_app/features/coupons/presentation/pages/coupon_form_page.dart';
import 'package:drivado_admin_app/features/coupons/presentation/widgets/coupon_card.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/confirm_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      context.read<CouponsRepository>().byType(_tab, query: _search.text);

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
        context.read<CouponsRepository>().delete(coupon.id);
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
            searchHint: 'Search',
            showSearchPrefix: true,
            footer: _CouponTabs(
              tab: _tab,
              onChanged: (tab) => setState(() {
                _tab = tab;
                _search.clear();
              }),
            ),
          ),
          Expanded(
            child: AppRoundedSheet(
              color: const Color(0xFFF7F7F8),
              child: items.isEmpty
                  ? Center(
                      child: AppText(
                        'No coupons found',
                        style: AppTextStyles.body,
                        weight: FontWeight.w500,
                      ),
                    )
                  : AppContent(
                      child: ResponsiveCardList(
                        padding:
                            AppLayout.of(context).scrollPadding(bottom: 100),
                        itemCount: items.length,
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
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66FB4156),
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: () => _openForm(),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnDark,
            elevation: 0,
            minimumSize: const Size(0, 42),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: AppText(
            isOneTime ? 'Create Coupon By Count +' : 'Create New Coupon +',
            style: AppTextStyles.button,
            size: 16,
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
    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF352828),
        borderRadius: BorderRadius.circular(40),
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
      borderRadius: BorderRadius.circular(40),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          border: selected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: AppText(
          label,
          align: TextAlign.center,
          style: AppTextStyles.bodyStrong,
          size: 14,
          weight: FontWeight.w600,
          color: selected ? AppColors.primary : const Color(0xFFADADAD),
        ),
      ),
    );
  }
}
