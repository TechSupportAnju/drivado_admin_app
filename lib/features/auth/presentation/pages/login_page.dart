import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/session/session_store.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/utils/auth_validators.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/signup_page.dart';
import 'package:drivado_admin_app/features/home/presentation/pages/home_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = false;
  bool _obscure = true;

  /// Same flags as drivado_application login + password screens.
  bool _showEmailEmptyError = false;
  bool _showPasswordEmptyError = false;

  late final AnimationController _controller;
  late final Animation<Offset> _sheetSlide;
  late final Animation<double> _sheetFade;

  bool get _canSubmit =>
      AuthValidators.isEmailReady(_email.text) &&
      AuthValidators.isPasswordReady(_password.text);

  String? get _emailError => AuthValidators.emailMessage(
        email: _email.text,
        showEmptyError: _showEmailEmptyError,
      );

  String? get _passwordError => AuthValidators.passwordMessage(
        password: _password.text,
        showEmptyError: _showPasswordEmptyError,
      );

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    _sheetSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _sheetFade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    final saved = SessionStore.instance.savedEmail;
    if (saved != null && saved.isNotEmpty) {
      _email.text = saved;
      _remember = true;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    setState(() {
      if (AuthValidators.isEmailReady(value)) {
        _showEmailEmptyError = false;
      } else if (value.isEmpty) {
        _showEmailEmptyError = true;
      } else {
        // Invalid format: empty-error flag off; format message shows via !valid.
        _showEmailEmptyError = false;
      }
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _showPasswordEmptyError = value.isEmpty;
    });
  }

  void _submit() {
    final emailOk = AuthValidators.isEmailReady(_email.text);
    final passwordOk = AuthValidators.isPasswordReady(_password.text);

    if (!emailOk || !passwordOk) {
      setState(() {
        if (!emailOk) _showEmailEmptyError = true;
        if (!passwordOk) _showPasswordEmptyError = true;
      });
      return;
    }

    SessionStore.instance.login(_email.text.trim()).then((_) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        AppPageRoute(page: const HomeShellPage()),
        (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Column(
          children: [
            const AuthHeader(
              titlePrefix: 'Login to\nyour ',
              titleAccent: 'Account',
            ),
            Expanded(
              child: FadeTransition(
                opacity: _sheetFade,
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
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                      child: Column(
                        children: [
                          AuthTextField(
                            controller: _email,
                            hint: 'Enter your email ID',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            hasError: _emailError != null,
                            onChanged: _onEmailChanged,
                          ),
                          AuthValidationMessage(message: _emailError),
                          const SizedBox(height: 12),
                          AuthTextField(
                            controller: _password,
                            hint: 'Enter  your Password',
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            hasError: _passwordError != null,
                            onChanged: _onPasswordChanged,
                            suffix: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: AppSvgIcon(
                                _obscure
                                    ? AppIcons.authEyeOff
                                    : AppIcons.authEye,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          AuthValidationMessage(message: _passwordError),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: Checkbox(
                                  value: _remember,
                                  onChanged: (v) =>
                                      setState(() => _remember = v ?? false),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  side: const BorderSide(
                                    color: AppColors.stroke,
                                  ),
                                  activeColor: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Remember me',
                                style: AppTextStyles.caption.copyWith(
                                  letterSpacing: -0.12,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Forgot Password ?',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          PrimaryButton(
                            label: 'Log in',
                            enabled: _canSubmit,
                            onPressed: _submit,
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    SheetUpRoute(page: const SignUpPage()),
                                  );
                                },
                                child: Text(
                                  'Sign up',
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
          ],
        ),
      ),
    );
  }
}
