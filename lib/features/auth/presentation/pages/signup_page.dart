import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  bool _consent = false;
  late final AnimationController _controller;
  late final Animation<Offset> _sheetSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _sheetSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Column(
          children: [
            const AuthHeader(
              titlePrefix: 'Sign up to\nyour ',
              titleAccent: 'Account',
              height: 218,
            ),
            Expanded(
              child: SlideTransition(
                position: _sheetSlide,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
                    child: Column(
                      children: [
                        const AuthTextField(hint: 'Enter your first name'),
                        const SizedBox(height: 12),
                        const AuthTextField(hint: 'Enter your last name'),
                        const SizedBox(height: 12),
                        const AuthTextField(
                          hint: 'Enter your email ID',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        const AuthTextField(
                          hint: 'Confirm email ID',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        const AuthTextField(hint: 'Company name'),
                        const SizedBox(height: 12),
                        AuthTextField(
                          hint: 'Enter your contact number',
                          keyboardType: TextInputType.phone,
                          prefix: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '+91',
                                  style: AppTextStyles.bodyStrong.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: AppColors.stroke,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const AuthTextField(hint: 'Address', maxLines: 3),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Checkbox(
                                value: _consent,
                                onChanged: (v) =>
                                    setState(() => _consent = v ?? false),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                side: const BorderSide(
                                  color: AppColors.stroke,
                                ),
                                activeColor: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      'I consent to receiving digital and telephone communication from Drivado regarding its services.',
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' more',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: 'Sign up',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'Login',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
