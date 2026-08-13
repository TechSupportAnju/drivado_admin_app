import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.style,
    this.color,
    this.size,
    this.weight,
    this.height,
    this.maxLines,
    this.overflow,
    this.align,
    this.letterSpacing,
  });

  final String data;
  final TextStyle? style;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final double? height;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? align;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    final base = style ?? AppTextStyles.body;
    return Text(
      data,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align,
      style: base.copyWith(
        color: color,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
