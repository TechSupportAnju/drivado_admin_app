import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class BookingSummaryOutlineButton extends StatelessWidget {
  const BookingSummaryOutlineButton({
    super.key,
    required this.icon,
    required this.label,
    required this.foreground,
    required this.borderColor,
    required this.onTap,
    this.height = 40,
    this.iconSize = 16,
    this.fontSize = 13,
    this.radius = 8,
  });

  final String icon;
  final String label;
  final Color foreground;
  final Color borderColor;
  final VoidCallback onTap;
  final double height;
  final double iconSize;
  final double fontSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvgIcon(icon, size: iconSize, color: foreground),
              const SizedBox(width: 6),
              AppText(
                label,
                style: AppTextStyles.caption,
                size: fontSize,
                color: foreground,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
