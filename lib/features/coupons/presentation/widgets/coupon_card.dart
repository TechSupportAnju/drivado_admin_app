import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/coupons/domain/entities/coupon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({
    super.key,
    required this.coupon,
    required this.onEdit,
    required this.onDelete,
  });

  final Coupon coupon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static final _dateFormat = DateFormat('dd/MM/yyyy');

  bool get _isOneTime => coupon.type == CouponType.oneTime;

  @override
  Widget build(BuildContext context) {
    final start = _dateFormat.format(coupon.startDate);
    final end = _dateFormat.format(coupon.expiryDate);

    final rows = _isOneTime
        ? [
            (
              left: _CellData(
                icon: Icons.percent_rounded,
                label: 'Discount',
                value: coupon.discount,
                emphasis: true,
              ),
              right: _CellData(
                icon: Icons.account_balance_outlined,
                label: 'Bank Name',
                value: coupon.bankName,
              ),
            ),
            (
              left: _CellData(
                icon: Icons.credit_card_outlined,
                label: 'Card',
                value: coupon.card,
              ),
              right: _CellData(
                icon: Icons.language_rounded,
                label: 'microsite',
                value: coupon.microsite,
              ),
            ),
            (
              left: _CellData(
                icon: Icons.hub_outlined,
                label: 'Network',
                value: coupon.network,
              ),
              right: _CellData(
                icon: Icons.payments_outlined,
                label: 'Threshold Price',
                value: coupon.thresholdPrice,
                emphasis: true,
              ),
            ),
            (
              left: _CellData(
                icon: Icons.calendar_today_outlined,
                label: 'Start date',
                value: start,
              ),
              right: _CellData(
                icon: Icons.event_outlined,
                label: 'End date',
                value: end,
              ),
            ),
          ]
        : [
            (
              left: _CellData(
                icon: Icons.calendar_today_outlined,
                label: 'Start date',
                value: start,
              ),
              right: _CellData(
                icon: Icons.event_outlined,
                label: 'End date',
                value: end,
              ),
            ),
            (
              left: _CellData(
                icon: Icons.account_balance_outlined,
                label: 'Bank Name',
                value: coupon.bankName,
              ),
              right: _CellData(
                icon: Icons.language_rounded,
                label: 'microsite',
                value: coupon.microsite,
              ),
            ),
            (
              left: _CellData(
                icon: Icons.credit_card_outlined,
                label: 'Card',
                value: coupon.card,
              ),
              right: _CellData(
                icon: Icons.hub_outlined,
                label: 'Network',
                value: coupon.network,
              ),
            ),
            (
              left: _CellData(
                icon: Icons.percent_rounded,
                label: 'Discount',
                value: coupon.discount,
                emphasis: true,
              ),
              right: _CellData(
                icon: Icons.payments_outlined,
                label: 'Threshold Price',
                value: coupon.thresholdPrice,
                emphasis: true,
              ),
            ),
          ];

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    _isOneTime ? 'Group Code' : 'Coupon Code',
                    style: AppTextStyles.caption,
                    size: 12,
                    color: AppColors.textSecondary,
                    weight: FontWeight.w500,
                  ),
                ),
                _IconAction(
                  icon: AppIcons.summaryEdit,
                  tooltip: 'Edit',
                  onTap: onEdit,
                ),
                _IconAction(
                  icon: AppIcons.profileDelete,
                  tooltip: 'Delete',
                  onTap: onDelete,
                  size: 18,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: AppText(
                coupon.code,
                style: AppTextStyles.subtitle,
                size: 18,
                weight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 6, 4),
              child: Divider(height: 1, color: AppColors.divider),
            ),
            for (var i = 0; i < rows.length; i++) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _MetaCell(data: rows[i].left)),
                    const SizedBox(width: 12),
                    Expanded(child: _MetaCell(data: rows[i].right)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CellData {
  const _CellData({
    required this.icon,
    required this.label,
    required this.value,
    this.emphasis = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool emphasis;
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 18,
  });

  final String icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
      icon: AppSvgIcon(icon, size: size, color: AppColors.primary),
    );
  }
}

class _MetaCell extends StatelessWidget {
  const _MetaCell({required this.data});

  final _CellData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(data.icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                data.label,
                style: AppTextStyles.caption,
                size: 11,
                color: AppColors.textSecondary,
                weight: FontWeight.w400,
              ),
              const SizedBox(height: 2),
              AppText(
                data.value,
                style: AppTextStyles.bodyStrong,
                size: 12,
                color: data.emphasis
                    ? AppColors.successGreen
                    : AppColors.textPrimary,
                weight: FontWeight.w600,
                height: 1.3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
