import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:flutter/material.dart';

class FieldPrefixIcon extends StatelessWidget {
  const FieldPrefixIcon(this.asset, {super.key, this.size = 18});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: AppSvgIcon(asset, size: size, color: AppColors.textSecondary),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.hint,
    this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffix,
    this.maxLines = 1,
    this.prefix,
    this.hasError = false,
    this.requiredMark = true,
    this.onChanged,
    this.onTap,
    this.textInputAction,
  });

  final String hint;
  final String? label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final Widget? suffix;
  final Widget? prefix;
  final int maxLines;
  final bool hasError;
  final bool requiredMark;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final floatingLabel = label?.trim();
    final hasFloatingLabel = floatingLabel != null && floatingLabel.isNotEmpty;

    return Container(
      height: maxLines > 1 ? null : 52,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(
        prefix == null ? 14 : 0,
        3,
        suffix == null ? 14 : 4,
        maxLines > 1 ? 10 : 0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasError
              ? AppColors.primary.withValues(alpha: 0.44)
              : AppColors.stroke,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        maxLines: maxLines,
        onChanged: onChanged,
        onTap: onTap,
        textInputAction: textInputAction,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        cursorColor: Colors.black,
        cursorHeight: 15,
        cursorWidth: 1.5,
        style: AppTextStyles.plus(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textLabel,
        ),
        decoration: InputDecoration(
          filled: false,
          isDense: true,
          alignLabelWithHint: maxLines > 1,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          prefixIcon: prefix,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
          suffixIcon: suffix,
          suffixIconConstraints: suffix == null
              ? null
              : const BoxConstraints(minWidth: 40, minHeight: 40),
          hintText: hasFloatingLabel ? hint : null,
          hintStyle: AppTextStyles.plus(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.fieldHintText,
          ),
          label: Text.rich(
            TextSpan(
              text: hasFloatingLabel ? floatingLabel : hint,
              style: AppTextStyles.plus(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.fieldHintText,
              ),
              children: [
                if (requiredMark)
                  TextSpan(
                    text: ' *',
                    style: AppTextStyles.plus(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
          floatingLabelBehavior: hasFloatingLabel
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.never,
          floatingLabelStyle: AppTextStyles.plus(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.fieldHintText,
          ),
        ),
      ),
    );
  }
}

class AuthValidationMessage extends StatelessWidget {
  const AuthValidationMessage({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          message!,
          style: AppTextStyles.plus(fontSize: 11, color: Colors.red, height: 1),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.44),
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.44),
          foregroundColor: AppColors.textOnDark,
          disabledForegroundColor: AppColors.textOnDark,
          elevation: enabled ? 1 : 0,
          shadowColor: const Color(0x33FB4156),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTextStyles.button,
        ),
        child: Text(label),
      ),
    );
  }
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.titlePrefix,
    required this.titleAccent,
    this.subtitle,
    this.onBack,
    this.height = 280,
    this.topSpacing = 70,
    this.titleFontSize,
    this.backgroundImage,
  });

  static const loginBackground = 'assets/images/loginbg.png';
  static const signupBackground = 'assets/images/signup.png';
  static const sheetOverlap = 250.0;
  static const sheetRadius = 20.0;

  final String titlePrefix;
  final String titleAccent;
  final String? subtitle;
  final VoidCallback? onBack;
  final double height;
  final double topSpacing;
  final double? titleFontSize;
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTextStyles.plus(
      fontSize: titleFontSize ?? 32,
      fontWeight: FontWeight.w700,
      color: AppColors.textOnDark,
    );
    final image = backgroundImage;
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        image: image == null
            ? null
            : DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image == null) ...[
            Positioned.fill(
              child: Opacity(
                opacity: 0.55,
                child: Image.asset(
                  'assets/images/auth_header_stars.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            CustomPaint(painter: _GridPainter()),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: topSpacing),
                if (onBack != null) ...[
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: onBack,
                        child: const Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
                if (titlePrefix.isNotEmpty || titleAccent.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: titlePrefix,
                            style: titleStyle,
                            children: [
                              TextSpan(
                                text: titleAccent,
                                style: titleStyle.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subtitle!,
                          style: AppTextStyles.plus(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textOnDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Same stack as drivado_application: 280px header image, white sheet from 250px.
class AuthStackedSheet extends StatelessWidget {
  const AuthStackedSheet({
    super.key,
    required this.header,
    required this.child,
    this.top = AuthHeader.sheetOverlap,
  });

  final Widget header;
  final Widget child;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(children: [header, const Spacer()]),
        Positioned.fill(
          top: top,
          child: Material(
            color: AppColors.surface,
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AuthHeader.sheetRadius),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const step = 42.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
