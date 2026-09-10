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
  static const _green = Color(0xFF098C31);

  bool get _isOneTime => coupon.type == CouponType.oneTime;

  @override
  Widget build(BuildContext context) {
    final start = _dateFormat.format(coupon.startDate);
    final end = _dateFormat.format(coupon.expiryDate);

    final rows = _isOneTime
        ? [
            (
              left: _CellData(
                icon: AppIcons.assignPrice,
                label: 'Discount',
                value: coupon.discount,
                emphasis: true,
              ),
              right: _CellData(
                icon: AppIcons.bookingsWallet,
                label: 'Bank Name',
                value: coupon.bankName,
              ),
            ),
            (
              left: _CellData(
                icon: AppIcons.moreCoupon,
                label: 'Card',
                value: coupon.card,
              ),
              right: _CellData(
                icon: AppIcons.summaryNavigate,
                label: 'Microsite',
                value: coupon.microsite,
              ),
            ),
            (
              left: _CellData(
                icon: AppIcons.summaryContact,
                label: 'Network',
                value: coupon.network,
              ),
              right: _CellData(
                icon: AppIcons.assignPrice,
                label: 'Threshold Price',
                value: coupon.thresholdPrice,
                emphasis: true,
              ),
            ),
            (
              left: _CellData(
                icon: AppIcons.bookingsCalendar,
                label: 'Start date',
                value: start,
              ),
              right: _CellData(
                icon: AppIcons.bookingsCalendar,
                label: 'End date',
                value: end,
              ),
            ),
          ]
        : [
            (
              left: _CellData(
                icon: AppIcons.bookingsCalendar,
                label: 'Start date',
                value: start,
              ),
              right: _CellData(
                icon: AppIcons.bookingsCalendar,
                label: 'End date',
                value: end,
              ),
            ),
            (
              left: _CellData(
                icon: AppIcons.bookingsWallet,
                label: 'Bank Name',
                value: coupon.bankName,
              ),
              right: _CellData(
                icon: AppIcons.summaryNavigate,
                label: 'Microsite',
                value: coupon.microsite,
              ),
            ),
            (
              left: _CellData(
                icon: AppIcons.moreCoupon,
                label: 'Card',
                value: coupon.card,
              ),
              right: _CellData(
                icon: AppIcons.summaryContact,
                label: 'Network',
                value: coupon.network,
              ),
            ),
            (
              left: _CellData(
                icon: AppIcons.assignPrice,
                label: 'Discount',
                value: coupon.discount,
                emphasis: true,
              ),
              right: _CellData(
                icon: AppIcons.assignPrice,
                label: 'Threshold Price',
                value: coupon.thresholdPrice,
                emphasis: true,
              ),
            ),
          ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: AppSvgIcon(
                  AppIcons.moreCoupon,
                  size: 16,
                  color: Color(0xFF606060),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      _isOneTime ? 'Group Code' : 'Coupon Code',
                      style: AppTextStyles.caption,
                      size: 11,
                      color: const Color(0xFF606060),
                      weight: FontWeight.w400,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      coupon.code,
                      style: AppTextStyles.subtitle,
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
              _IconAction(
                icon: AppIcons.summaryEdit,
                tooltip: 'Edit',
                onTap: onEdit,
              ),
              const SizedBox(width: 8),
              _IconAction(
                icon: AppIcons.profileDelete,
                tooltip: 'Delete',
                onTap: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _MetaCell(data: rows[i].left)),
                const SizedBox(width: 12),
                Expanded(child: _MetaCell(data: rows[i].right)),
              ],
            ),
          ],
        ],
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

  final String icon;
  final String label;
  final String value;
  final bool emphasis;
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final String icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary),
          ),
          child: AppSvgIcon(icon, size: 14, color: AppColors.primary),
        ),
      ),
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
        AppSvgIcon(data.icon, size: 14, color: const Color(0xFF606060)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                data.label,
                style: AppTextStyles.caption,
                size: 11,
                color: const Color(0xFF606060),
                weight: FontWeight.w400,
              ),
              const SizedBox(height: 2),
              AppText(
                data.value,
                style: AppTextStyles.bodyStrong,
                size: 12,
                color: data.emphasis
                    ? CouponCard._green
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
