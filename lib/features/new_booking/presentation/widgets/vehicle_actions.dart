import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class BookNowSlider extends StatefulWidget {
  const BookNowSlider({super.key, required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<BookNowSlider> createState() => _BookNowSliderState();
}

class _BookNowSliderState extends State<BookNowSlider> {
  var _drag = 0.0;
  var _done = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
    final parentWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : MediaQuery.sizeOf(context).width;
    final width = (parentWidth * 0.9).clamp(240.0, 420.0);
    const height = 50.0;
    const knob = 40.0;
    final maxDrag = width - knob - 8;
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  _done ? '' : 'Book Now',
                  style: AppTextStyles.bodyStrong,
                  size: 14,
                  color: Colors.white,
                ),
                if (!_done) ...[
                  const SizedBox(width: 7),
                  const AppSvgIcon(AppIcons.vehicleArrow, size: 14),
                ],
              ],
            ),
            Positioned(
              left: _drag,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _drag = (_drag + details.delta.dx).clamp(0, maxDrag);
                  });
                },
                onPanEnd: (_) async {
                  if (_drag >= maxDrag * 0.95) {
                    setState(() {
                      _done = true;
                      _drag = maxDrag;
                    });
                    await Future<void>.delayed(const Duration(milliseconds: 300));
                    widget.onCompleted();
                    if (mounted) {
                      setState(() {
                        _drag = 0;
                        _done = false;
                      });
                    }
                  } else {
                    setState(() {
                      _drag = 0;
                      _done = false;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: AppSvgIcon(
                    _done ? AppIcons.vehicleGreenCheck : AppIcons.vehicleBookNow,
                    size: knob,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}

Future<void> showInclusionDialog(BuildContext context) {
  const items = [
    'Free 60 minutes waiting time after flight landing for airport pickups, 15 minutes waiting time for all other pickups.',
    'Free cancellation upto 24 hour prior to time for both oneway transfer and hourly disposals.',
    'Flight No./Train No. is mandatory for airport /station pickup and dropoff.',
    'Guest/luggage capacities must be abided by for safety reasons. If you are unsure, select a larger class as chauffeurs may turn down service when they are exceeded.',
    'The vehicle images are just for reference, you may get a different vehicle of similar quality depending on destination.',
    'All prices include VAT, Gratuities, Meet and Greet services.',
  ];
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'inclusions',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, _, __) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 17),
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 24),
                    Expanded(
                      child: AppText(
                        'Details',
                        align: TextAlign.center,
                        style: AppTextStyles.subtitle,
                        size: 22,
                        weight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const AppSvgIcon(AppIcons.vehicleCross, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: AppSvgIcon(
                            AppIcons.vehicleInclusionTick,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppText(
                            item,
                            style: AppTextStyles.body,
                            size: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final scale = Curves.easeInOut.transform(animation.value);
      return Transform.scale(scale: scale, child: child);
    },
  );
}
