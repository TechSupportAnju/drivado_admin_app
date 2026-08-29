import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 28, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MoreItem(
                        icon: AppIcons.summaryWhatsapp,
                        label: 'Whatsapp',
                        onTap: () => Navigator.pop(
                          dialogContext,
                          BookingMoreAction.whatsapp,
                        ),
                      ),
                      _MoreItem(
                        icon: AppIcons.summaryEdit,
                        label: 'Edit Booking',
                        onTap: () => Navigator.pop(
                          dialogContext,
                          BookingMoreAction.editBooking,
                        ),
                      ),
                      _MoreItem(
                        icon: AppIcons.summaryAssign,
                        label: 'Assign Ride',
                        onTap: () => Navigator.pop(
                          dialogContext,
                          BookingMoreAction.assignRide,
                        ),
                      ),
                      _MoreItem(
                        icon: AppIcons.summaryClone,
                        label: 'Clone',
                        onTap: () => Navigator.pop(
                          dialogContext,
                          BookingMoreAction.clone,
                        ),
                      ),
                      _MoreItem(
                        icon: AppIcons.summaryVoucher,
                        label: 'Affiliate Voucher',
                        onTap: () => Navigator.pop(
                          dialogContext,
                          BookingMoreAction.affiliateVoucher,
                        ),
                      ),
                      _MoreItem(
                        icon: AppIcons.summaryCancelCircle,
                        label: 'Cancel',
                        color: AppColors.primary,
                        onTap: () => Navigator.pop(
                          dialogContext,
                          BookingMoreAction.cancel,
                        ),
                      ),
                    ],
                  ),
                ),
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

class _MoreItem extends StatelessWidget {
  const _MoreItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              AppSvgIcon(icon, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: AppText(
                  label,
                  style: AppTextStyles.body,
                  size: 15,
                  color: color ?? AppColors.textPrimary,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
