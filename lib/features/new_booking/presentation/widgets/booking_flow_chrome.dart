import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class BookingFlowProgressBar extends StatelessWidget {
  const BookingFlowProgressBar({super.key, required this.step});

  /// 0 = passenger, 1 = summary, 2 = payment/receipt.
  final int step;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _dot(done: step > 0, current: step == 0),
            Expanded(child: _line(active: step > 0)),
            _dot(done: step > 1, current: step == 1),
            Expanded(child: _line(active: step > 1)),
            _dot(done: step >= 2, current: step == 2),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: AppText(
                'Basic Information',
                style: AppTextStyles.caption,
                size: 10,
                weight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: AppText(
                'Booking Summary',
                align: TextAlign.center,
                style: AppTextStyles.caption,
                size: 10,
                weight: FontWeight.w600,
                color: step == 0 ? const Color(0xFFADADAD) : AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: AppText(
                'Payment',
                align: TextAlign.end,
                style: AppTextStyles.caption,
                size: 10,
                weight: FontWeight.w600,
                color: step >= 2 ? AppColors.textPrimary : const Color(0xFFADADAD),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dot({required bool done, required bool current}) {
    if (done) {
      return const Icon(Icons.check_circle, size: 16, color: Color(0xFF22C55E));
    }
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: current ? AppColors.primary : const Color(0xFFD9D9D9),
      ),
    );
  }

  Widget _line({required bool active}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? AppColors.textPrimary : const Color(0xFFD9D9D9),
              width: 1.5,
              style: active ? BorderStyle.solid : BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}

class BookingFlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookingFlowAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: onBack ?? () => Navigator.of(context).pop(),
        icon: const Icon(Icons.keyboard_backspace, color: Color(0xFF555555)),
      ),
      title: AppText(
        title,
        style: AppTextStyles.subtitle,
        size: 20,
        weight: FontWeight.w600,
      ),
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFD9D9D9)),
      ),
    );
  }
}
