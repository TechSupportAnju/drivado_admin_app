import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_system_ui.dart';
import 'package:drivado_admin_app/core/utils/auth_validators.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_toast.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _obscurePassword = true;
  var _obscureConfirm = true;
  var _submitted = false;

  String? get _passwordError => AuthValidators.passwordMessage(
    password: _password.text,
    showEmptyError: _submitted,
  );

  String? get _confirmError => AuthValidators.confirmPasswordMessage(
    password: _password.text,
    confirmPassword: _confirm.text,
    showEmptyError: _submitted,
  );

  bool get _canSubmit =>
      AuthValidators.isPasswordReady(_password.text) &&
      _confirm.text == _password.text &&
      _confirm.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(AppSystemUi.darkHeader);
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!_canSubmit) return;
    await showAppSuccessToast(
      context,
      title: 'Password changed',
      message: 'your Password changed successfully!',
    );
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushAndRemoveUntil(AppPageRoute(page: const LoginPage()), (_) => false);
  }

  Widget _eyeButton({required bool obscure, required VoidCallback onTap}) {
    return IconButton(
      onPressed: onTap,
      icon: AppSvgIcon(
        obscure ? AppIcons.authEyeOff : AppIcons.authEye,
        size: 20,
        color: AppColors.textSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: AuthStackedSheet(
          header: AuthHeader(
            titlePrefix: 'Change your\n',
            titleAccent: 'Password',
            titleFontSize: 28,
            topSpacing: 20,
            backgroundImage: AuthHeader.signupBackground,
            onBack: () => Navigator.of(context).pop(),
          ),
          child: AppContent(
            maxWidth: AppLayout.of(context).formMaxWidth,
            child: SingleChildScrollView(
              padding: AppLayout.of(context).scrollPadding(top: 20, bottom: 24),
              child: Column(
                children: [
                  AuthTextField(
                    controller: _password,
                    label: 'Password',
                    hint: 'Enter your new password',
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    hasError: _passwordError != null,
                    onChanged: (_) => setState(() {}),
                    suffix: _eyeButton(
                      obscure: _obscurePassword,
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  AuthValidationMessage(message: _passwordError),
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _confirm,
                    label: 'Confirm password',
                    hint: 'Confirm password',
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    hasError: _confirmError != null,
                    onChanged: (_) => setState(() {}),
                    suffix: _eyeButton(
                      obscure: _obscureConfirm,
                      onTap: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  AuthValidationMessage(message: _confirmError),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Confirm',
                    enabled: _canSubmit,
                    onPressed: _submit,
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
