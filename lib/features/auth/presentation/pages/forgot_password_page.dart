import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_system_ui.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/utils/auth_validators.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  var _showEmailEmptyError = false;

  String? get _emailError => AuthValidators.emailMessage(
    email: _email.text,
    showEmptyError: _showEmailEmptyError,
  );

  bool get _canContinue => AuthValidators.isEmailReady(_email.text);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(AppSystemUi.darkHeader);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    setState(() {
      if (AuthValidators.isEmailReady(value) || value.isNotEmpty) {
        _showEmailEmptyError = false;
      }
    });
  }

  void _continue() {
    if (!_canContinue) {
      setState(() => _showEmailEmptyError = true);
      return;
    }
    showOtpVerificationSheet(context, email: _email.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: AuthStackedSheet(
          header: AuthHeader(
            titlePrefix: 'Use mail to reset your\n',
            titleAccent: 'password',
            subtitle: 'Enter your email to reset your password easily.',
            titleFontSize: 24,
            topSpacing: 0,
            backgroundImage: AuthHeader.loginBackground,
            onBack: () => Navigator.of(context).pop(),
          ),
          child: AppContent(
            maxWidth: AppLayout.of(context).formMaxWidth,
            child: SingleChildScrollView(
              padding: AppLayout.of(context).scrollPadding(top: 30, bottom: 24),
              child: Column(
                children: [
                  AuthTextField(
                    controller: _email,
                    label: 'Email Id',
                    hint: 'Enter your Email ID',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    hasError: _emailError != null,
                    onChanged: _onEmailChanged,
                  ),
                  AuthValidationMessage(message: _emailError),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Continue',
                    enabled: _canContinue,
                    onPressed: _continue,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text.rich(
                      TextSpan(
                        text: 'Back to ',
                        style: AppTextStyles.plus(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: 'sign in',
                            style: AppTextStyles.plus(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
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
        ),
      ),
    );
  }
}
