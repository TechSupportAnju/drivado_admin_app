import 'dart:io';

import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AffiliateAvatar extends StatelessWidget {
  const AffiliateAvatar({
    super.key,
    required this.size,
    this.photoPath,
    this.initials,
    this.backgroundColor,
    this.borderColor,
    this.showPlaceholderSilhouette = false,
    this.initialsSize,
  });

  final double size;
  final String? photoPath;
  final String? initials;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool showPlaceholderSilhouette;
  final double? initialsSize;

  @override
  Widget build(BuildContext context) {
    final path = photoPath?.trim() ?? '';
    final file = path.isEmpty ? null : File(path);
    final hasFile = file != null && file.existsSync();

    Widget child;
    if (hasFile) {
      child = ClipOval(
        child: Image.file(
          file,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else if (showPlaceholderSilhouette ||
        initials == null ||
        initials!.isEmpty) {
      child = AppSvgIcon(
        AppIcons.moreAvatar,
        size: size * 0.5,
        color: const Color(0xFF9AA0A6),
      );
    } else {
      child = AppText(
        initials!,
        style: AppTextStyles.subtitle,
        size: initialsSize ?? size * 0.33,
        color: AppColors.textOnDark,
        weight: FontWeight.w700,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasFile
            ? Colors.transparent
            : (backgroundColor ?? const Color(0xFFE8E9EE)),
        border: Border.all(color: borderColor ?? AppColors.stroke),
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
