import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/utils/auth_validators.dart';
import 'package:drivado_admin_app/core/widgets/app_toast.dart';
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

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _confirmEmail = TextEditingController();
  final _company = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  var _showFirstNameError = false;
  var _showLastNameError = false;
  var _showEmailError = false;
  var _showConfirmEmailError = false;
  var _showCompanyError = false;
  var _showPhoneError = false;
  var _showAddressError = false;

  bool _consent = false;
  bool _consentExpanded = false;
  var _countryCode = '+91';
  late final AnimationController _controller;
  late final Animation<Offset> _sheetSlide;
  late final TapGestureRecognizer _consentToggle;

  String? get _firstNameError => AuthValidators.requiredMessage(
    value: _firstName.text,
    emptyMessage: 'Please enter your first name',
    showEmptyError: _showFirstNameError,
  );

  String? get _lastNameError => AuthValidators.requiredMessage(
    value: _lastName.text,
    emptyMessage: 'Please enter your last name',
    showEmptyError: _showLastNameError,
  );

  String? get _emailError => AuthValidators.signupEmailMessage(
    email: _email.text,
    showEmptyError: _showEmailError,
  );

  String? get _confirmEmailError => AuthValidators.confirmEmailMessage(
    email: _email.text,
    confirmEmail: _confirmEmail.text,
    showEmptyError: _showConfirmEmailError,
  );

  String? get _companyError => AuthValidators.requiredMessage(
    value: _company.text,
    emptyMessage: 'Please enter your company name',
    showEmptyError: _showCompanyError,
  );

  String? get _phoneError => AuthValidators.requiredMessage(
    value: _phone.text,
    emptyMessage: 'Please enter your contact number',
    showEmptyError: _showPhoneError,
  );

  String? get _addressError => AuthValidators.requiredMessage(
    value: _address.text,
    emptyMessage: 'Please enter your address',
    showEmptyError: _showAddressError,
  );

  bool get _fieldsValid =>
      _firstNameError == null &&
      _lastNameError == null &&
      _emailError == null &&
      _confirmEmailError == null &&
      _companyError == null &&
      _phoneError == null &&
      _addressError == null;

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
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _confirmEmail.dispose();
    _company.dispose();
    _phone.dispose();
    _address.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onRequiredChanged({
    required String value,
    required void Function(bool show) setShowError,
  }) {
    setState(() => setShowError(value.trim().isEmpty));
  }

  void _submit() {
    setState(() {
      _showFirstNameError = _firstName.text.trim().isEmpty;
      _showLastNameError = _lastName.text.trim().isEmpty;
      _showEmailError = !AuthValidators.isEmailReady(_email.text);
      _showConfirmEmailError =
          _confirmEmail.text.trim().isEmpty ||
          _confirmEmail.text.trim() != _email.text.trim();
      _showCompanyError = _company.text.trim().isEmpty;
      _showPhoneError = _phone.text.trim().isEmpty;
      _showAddressError = _address.text.trim().isEmpty;
    });

    if (!_fieldsValid || !_consent) {
      if (!_consent) {
        showAppErrorToast(
          context,
          title: 'Error',
          message:
              'Please fill all required fields correctly and accept consent.',
        );
      }
      return;
    }

    Navigator.of(
      context,
    ).pushReplacement(AppPageRoute(page: const SignupThankYouPage()));
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
                ).scrollPadding(top: 20, bottom: 54),
                child: Column(
                  children: [
                    AuthTextField(
                      controller: _firstName,
                      label: 'First name',
                      hint: 'Enter your first name',
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      hasError: _firstNameError != null,
                      onChanged: (value) => _onRequiredChanged(
                        value: value,
                        setShowError: (show) => _showFirstNameError = show,
                      ),
                    ),
                    AuthValidationMessage(message: _firstNameError),
                    const SizedBox(height: 12),
                    AuthTextField(
                      controller: _lastName,
                      label: 'Last name',
                      hint: 'Enter your last name',
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      hasError: _lastNameError != null,
                      onChanged: (value) => _onRequiredChanged(
                        value: value,
                        setShowError: (show) => _showLastNameError = show,
                      ),
                    ),
                    AuthValidationMessage(message: _lastNameError),
                    const SizedBox(height: 12),
                    AuthTextField(
                      controller: _email,
                      label: 'Email Id',
                      hint: 'Enter your Email ID',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hasError: _emailError != null,
                      onChanged: (_) {
                        setState(() {
                          _showEmailError =
                              _email.text.isEmpty ||
                              !AuthValidators.isEmailFormatValid(_email.text);
                          if (_confirmEmail.text.isNotEmpty) {
                            _showConfirmEmailError =
                                _confirmEmail.text.trim() != _email.text.trim();
                          }
                        });
                      },
                    ),
                    AuthValidationMessage(message: _emailError),
                    const SizedBox(height: 12),
                    AuthTextField(
                      controller: _confirmEmail,
                      label: 'Confirm email ID',
                      hint: 'Confirm email ID',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hasError: _confirmEmailError != null,
                      onChanged: (_) {
                        setState(() {
                          _showConfirmEmailError =
                              _confirmEmail.text.trim().isEmpty ||
                              _confirmEmail.text.trim() != _email.text.trim();
                        });
                      },
                    ),
                    AuthValidationMessage(message: _confirmEmailError),
                    const SizedBox(height: 12),
                    AuthTextField(
                      controller: _company,
                      label: 'Company name',
                      hint: 'Company name',
                      textInputAction: TextInputAction.next,
                      hasError: _companyError != null,
                      onChanged: (value) => _onRequiredChanged(
                        value: value,
                        setShowError: (show) => _showCompanyError = show,
                      ),
                    ),
                    AuthValidationMessage(message: _companyError),
                    const SizedBox(height: 12),
                    CountryCodePhoneField(
                      controller: _phone,
                      countryCode: _countryCode,
                      onCountryCodeChanged: (code) =>
                          setState(() => _countryCode = code),
                      hasError: _phoneError != null,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) => _onRequiredChanged(
                        value: value,
                        setShowError: (show) => _showPhoneError = show,
                      ),
                    ),
                    AuthValidationMessage(message: _phoneError),
                    const SizedBox(height: 12),
                    AuthTextField(
                      controller: _address,
                      label: 'Address',
                      hint: 'Address',
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      hasError: _addressError != null,
                      onChanged: (value) => _onRequiredChanged(
                        value: value,
                        setShowError: (show) => _showAddressError = show,
                      ),
                    ),
                    AuthValidationMessage(message: _addressError),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w400,
                                // height: 1.4,
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
                    PrimaryButton(label: 'Sign up', onPressed: _submit),
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
