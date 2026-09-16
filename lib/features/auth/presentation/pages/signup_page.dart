import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/country_code_phone_field.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/signup_thank_you_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  static const _consentIntro =
      'I consent to receiving digital and telephone communication from Drivado regarding its services.';
  static const _consentDetails =
      ' I understand I may change my preference or opt-out of communication with Drivado at anytime using the unsubscribe link provided in Drivado email communication.';

  final _phone = TextEditingController();
  bool _consent = false;
  bool _consentExpanded = false;
  var _countryCode = '+91';
  late final AnimationController _controller;
  late final Animation<Offset> _sheetSlide;
  late final TapGestureRecognizer _consentToggle;

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
    _consentToggle = TapGestureRecognizer()
      ..onTap = () => setState(() => _consentExpanded = !_consentExpanded);
    _controller.forward();
  }

  @override
  void dispose() {
    _consentToggle.dispose();
    _phone.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: AuthStackedSheet(
          header: const AuthHeader(
            titlePrefix: 'Sign up to\nyour ',
            titleAccent: 'Account',
            backgroundImage: AuthHeader.signupBackground,
            topSpacing: 60,
          ),
          child: SlideTransition(
            position: _sheetSlide,
            child: AppContent(
              maxWidth: AppLayout.of(context).formMaxWidth,
              child: SingleChildScrollView(
                padding: AppLayout.of(
                  context,
                ).scrollPadding(top: 20, bottom: 24),
                child: Column(
                  children: [
                    const AuthTextField(
                      label: 'First name',
                      hint: 'Enter your first name',
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    const AuthTextField(
                      label: 'Last name',
                      hint: 'Enter your last name',
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    const AuthTextField(
                      label: 'Email Id',
                      hint: 'Enter your Email ID',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    const AuthTextField(
                      label: 'Confirm email ID',
                      hint: 'Confirm email ID',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    const AuthTextField(
                      label: 'Company name',
                      hint: 'Company name',
                    ),
                    const SizedBox(height: 12),
                    CountryCodePhoneField(
                      controller: _phone,
                      countryCode: _countryCode,
                      onCountryCodeChanged: (code) =>
                          setState(() => _countryCode = code),
                    ),
                    const SizedBox(height: 12),
                    const AuthTextField(
                      label: 'Address',
                      hint: 'Address',
                      maxLines: 3,
                    ),
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
                            side: const BorderSide(color: AppColors.stroke),
                            activeColor: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(text: _consentIntro),
                                if (_consentExpanded)
                                  const TextSpan(text: _consentDetails),
                                TextSpan(
                                  text: _consentExpanded ? 'Less' : ' more',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                  recognizer: _consentToggle,
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
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          AppPageRoute(page: const SignupThankYouPage()),
                        );
                      },
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
      ),
    );
  }
}
