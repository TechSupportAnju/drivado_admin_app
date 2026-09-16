import 'dart:async';

import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/change_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showOtpVerificationSheet(
  BuildContext context, {
  required String email,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    scrollControlDisabledMaxHeightRatio: 2,
    builder: (context) => OtpVerificationSheet(email: email),
  );
}

class OtpVerificationSheet extends StatefulWidget {
  const OtpVerificationSheet({super.key, required this.email});

  final String email;

  @override
  State<OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<OtpVerificationSheet> {
  static const _otpLength = 4;

  final _digits = List.generate(_otpLength, (_) => TextEditingController());
  final _nodes = List.generate(_otpLength, (_) => FocusNode());
  var _submitted = false;
  var _secondsLeft = 120;
  Timer? _timer;

  String get _otp => _digits.map((c) => c.text).join();
  bool get _otpComplete => _otp.length == _otpLength;
  bool get _otpError => _submitted && !_otpComplete;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _digits) {
      controller.dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 120);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
        return;
      }
      setState(() => _secondsLeft -= 1);
    });
  }

  String get _timerLabel {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onDigitChanged(int index, String value) {
    final digit = value.replaceAll(RegExp(r'\D'), '');
    if (digit.length > 1) {
      _digits[index].text = digit.substring(digit.length - 1);
    }
    setState(() => _submitted = false);
    if (digit.isNotEmpty && index < _otpLength - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (digit.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    for (final controller in _digits) {
      controller.clear();
    }
    _nodes.first.requestFocus();
    _startTimer();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP sent again')));
  }

  void _continue() {
    setState(() => _submitted = true);
    if (!_otpComplete) return;
    Navigator.of(context).push(AppPageRoute(page: const ChangePasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: size.height / 1.2,
        width: size.width,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Check Your Email',
                  style: AppTextStyles.plus(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We've sent a verification code to",
                  style: AppTextStyles.plus(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: AppTextStyles.plus(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  'Please check your email enter the 4-digit code to activate your account.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.plus(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _otpLength; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    _OtpBox(
                      controller: _digits[i],
                      focusNode: _nodes[i],
                      hasError: _otpError,
                      onChanged: (value) => _onDigitChanged(i, value),
                    ),
                  ],
                ],
              ),
              AuthValidationMessage(
                message: _otpError ? 'Please enter the 4-digit code' : null,
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _resend,
                child: Text.rich(
                  TextSpan(
                    text: "Didn't receive a code? ",
                    style: AppTextStyles.plus(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: _secondsLeft == 0 ? 'Resend' : _timerLabel,
                        style: AppTextStyles.plus(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(label: 'Continue', onPressed: _continue),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text.rich(
                  TextSpan(
                    text: 'Wrong email address? ',
                    style: AppTextStyles.plus(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ).copyWith(decoration: TextDecoration.underline),
                    children: [
                      TextSpan(
                        text: 'Edit email',
                        style: AppTextStyles.plus(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ).copyWith(decoration: TextDecoration.underline),
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
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hasError,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, _) {
        final focused = focusNode.hasFocus;
        return SizedBox(
          width: 53,
          height: 64,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            cursorColor: AppColors.primary,
            style: AppTextStyles.plus(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              counterText: '',
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(focused ? 8 : 20),
                borderSide: BorderSide(
                  color: hasError
                      ? AppColors.primary.withValues(alpha: 0.44)
                      : AppColors.stroke,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: hasError
                      ? AppColors.primary.withValues(alpha: 0.44)
                      : AppColors.stroke,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        );
      },
    );
  }
}
