import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.maxLines = 1,
    this.prefix,
    this.hasError = false,
    this.onChanged,
    this.onTap,
    this.textInputAction,
  });

  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final Widget? prefix;
  final int maxLines;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;

  static final _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: AppColors.primary.withValues(alpha: 0.44),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines > 1 ? null : 52,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        onTap: onTap,
        textInputAction: textInputAction,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
        decoration: InputDecoration(
          hintText: null,
          prefixIcon: prefix,
          suffixIcon: suffix,
          label: Text.rich(
            TextSpan(
              text: hint,
              style: AppTextStyles.fieldHint,
              children: [
                TextSpan(
                  text: '*',
                  style: AppTextStyles.fieldHint.copyWith(
                    color: AppColors.required,
                  ),
                ),
              ],
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: hasError
              ? _errorBorder
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.stroke),
                ),
          focusedBorder: hasError
              ? _errorBorder.copyWith(
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.44),
                    width: 1.4,
                  ),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.4,
                  ),
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
          style: AppTextStyles.plus(
            fontSize: 11,
            color: Colors.red,
            height: 1,
          ),
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
    this.height = 263,
  });

  final String titlePrefix;
  final String titleAccent;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.primaryDark),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 68, 22, 24),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text.rich(
                TextSpan(
                  text: titlePrefix,
                  style: AppTextStyles.display,
                  children: [
                    TextSpan(
                      text: titleAccent,
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
