import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/app_toast.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/voucher_action_dialog.dart';
import 'package:flutter/material.dart';

enum BookingMoreAction {
  whatsapp,
  editBooking,
  assignRide,
  clone,
  affiliateVoucher,
  cancel,
}

class BookingMoreMenu {
  BookingMoreMenu._();

  static Future<BookingMoreAction?> show(BuildContext context) {
    final topBarHeight =
        MediaQuery.paddingOf(context).top + kToolbarHeight;

    return showGeneralDialog<BookingMoreAction>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'More',
      barrierColor: const Color(0x66000000),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, _, __) {
        final size = MediaQuery.sizeOf(dialogContext);
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: topBarHeight),
            child: Material(
              color: AppColors.surface,
              elevation: 16,
              shadowColor: const Color(0x33000000),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: size.width * 0.5,
                height: size.height - topBarHeight,
                child: _MoreMenuBody(dialogContext: dialogContext),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }
}

class _MoreMenuBody extends StatefulWidget {
  const _MoreMenuBody({required this.dialogContext});

  final BuildContext dialogContext;

  @override
  State<_MoreMenuBody> createState() => _MoreMenuBodyState();
}

class _MoreMenuBodyState extends State<_MoreMenuBody> {
  BookingMoreAction? _highlighted;

  Future<void> _onWhatsapp() async {
    setState(() => _highlighted = BookingMoreAction.whatsapp);
    final confirmed = await VoucherActionDialog.confirm(
      widget.dialogContext,
      icon: AppIcons.summaryWhatsappConfirm,
      title: 'Are you sure?',
      message: 'Are you sure you want to share this voucher on Whatsapp?',
    );
    if (!mounted || !confirmed) return;
    await showAppSuccessToast(
      widget.dialogContext,
      title: 'Voucher sent to Whatsapp Successfully',
      message: 'Your voucher has been successfully sent to your Whatsapp.',
    );
  }

  Future<void> _onAffiliateVoucher() async {
    setState(() => _highlighted = BookingMoreAction.affiliateVoucher);
    final confirmed = await VoucherActionDialog.confirm(
      widget.dialogContext,
      icon: AppIcons.summaryVoucherConfirm,
      title: 'Want to send a voucher?',
      message:
          'Are you sure you want to send this affiliate voucher? Confirming this action will automatically send this voucher.',
    );
    if (!mounted || !confirmed) return;
    await showAppSuccessToast(
      widget.dialogContext,
      title: 'Affiliate voucher has been successfully sent',
      message: 'Affiliate voucher sent successfully for easy access.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MoreItem(
            icon: AppIcons.summaryWhatsapp,
            label: 'Whatsapp',
            selected: _highlighted == BookingMoreAction.whatsapp,
            onTap: _onWhatsapp,
          ),
          _MoreItem(
            icon: AppIcons.summaryEdit,
            label: 'Edit Booking',
            selected: _highlighted == BookingMoreAction.editBooking,
            onTap: () => Navigator.pop(
              widget.dialogContext,
              BookingMoreAction.editBooking,
            ),
          ),
          _MoreItem(
            icon: AppIcons.summaryAssign,
            label: 'Assign Ride',
            selected: _highlighted == BookingMoreAction.assignRide,
            onTap: () => Navigator.pop(
              widget.dialogContext,
              BookingMoreAction.assignRide,
            ),
          ),
          _MoreItem(
            icon: AppIcons.summaryClone,
            label: 'Clone',
            selected: _highlighted == BookingMoreAction.clone,
            onTap: () => Navigator.pop(
              widget.dialogContext,
              BookingMoreAction.clone,
            ),
          ),
          _MoreItem(
            icon: AppIcons.summaryVoucher,
            label: 'Affiliate Voucher',
            selected: _highlighted == BookingMoreAction.affiliateVoucher,
            onTap: _onAffiliateVoucher,
          ),
          _MoreItem(
            icon: AppIcons.summaryCancelCircle,
            label: 'Cancel',
            color: AppColors.primary,
            selected: _highlighted == BookingMoreAction.cancel,
            onTap: () => Navigator.pop(
              widget.dialogContext,
              BookingMoreAction.cancel,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  const _MoreItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.selected = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: selected ? const Color(0xFFEEEEF0) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                AppSvgIcon(icon, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    label,
                    style: AppTextStyles.body,
                    size: 14,
                    color: color ?? AppColors.textPrimary,
                    weight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
