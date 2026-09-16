import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/country_code_phone_field.dart';
import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/pages/create_booking_summary_page.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/widgets/booking_flow_chrome.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class PassengerDetailsPage extends StatefulWidget {
  const PassengerDetailsPage({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<PassengerDetailsPage> createState() => _PassengerDetailsPageState();
}

class _PassengerDetailsPageState extends State<PassengerDetailsPage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _flight = TextEditingController();
  final _request = TextEditingController();
  var _countryCode = '+91';
  var _agreed = false;
  var _submitted = false;
  var _loading = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    _flight.dispose();
    _request.dispose();
    super.dispose();
  }

  bool get _firstError => _submitted && _firstName.text.trim().isEmpty;
  bool get _lastError => _submitted && _lastName.text.trim().isEmpty;
  bool get _phoneError => _submitted && _phone.text.trim().length < 8;
  bool get _emailError =>
      _submitted && !EmailValidator.validate(_email.text.trim());

  Future<void> _continue() async {
    setState(() => _submitted = true);
    if (_firstError || _lastError || _phoneError || _emailError || !_agreed) {
      return;
    }
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    final passenger = PassengerInfo(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      countryCode: _countryCode,
      flightNo: _flight.text.trim(),
      specialRequest: _request.text.trim(),
    );
    Navigator.of(context).push(
      AppPageRoute(
        page: CreateBookingSummaryPage(
          draft: widget.draft.copyWith(passenger: passenger),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const BookingFlowAppBar(title: 'Passenger Details'),
      body: AppContent(
        maxWidth: AppLayout.of(context).formMaxWidth,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: BookingFlowProgressBar(step: 0),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                children: [
                  AuthTextField(
                    label: 'First name',
                    hint: 'Enter your first name',
                    controller: _firstName,
                    textCapitalization: TextCapitalization.sentences,
                    hasError: _firstError,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message: _firstError ? 'Please enter your first name' : null,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Last name',
                    hint: 'Enter your last name',
                    controller: _lastName,
                    textCapitalization: TextCapitalization.sentences,
                    hasError: _lastError,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message: _lastError ? 'Please enter your last name' : null,
                  ),
                  const SizedBox(height: 12),
                  CountryCodePhoneField(
                    controller: _phone,
                    countryCode: _countryCode,
                    hasError: _phoneError,
                    textInputAction: TextInputAction.next,
                    onCountryCodeChanged: (code) =>
                        setState(() => _countryCode = code),
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message: _phoneError
                        ? 'Please enter your contact number'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Email ID',
                    hint: 'Enter your Email ID',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    hasError: _emailError,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message: _emailError
                        ? (_email.text.trim().isEmpty
                            ? 'Please enter your email id'
                            : 'Please enter valid email id')
                        : null,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Flight Number (Optional)',
                    hint: 'Enter your flight number',
                    controller: _flight,
                    requiredMark: false,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Special Request (Optional)',
                    hint: 'Enter your special request',
                    controller: _request,
                    requiredMark: false,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 19,
                        height: 19,
                        child: Checkbox(
                          value: _agreed,
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          side: const BorderSide(color: AppColors.stroke),
                          activeColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: AppTextStyles.plus(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: AppColors.textPrimary,
                            ),
                            children: [
                              const TextSpan(text: 'I agree to '),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: AppTextStyles.plus(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                  height: 1.5,
                                ),
                              ),
                              const TextSpan(text: ', '),
                              TextSpan(
                                text: 'Booking Conditions',
                                style: AppTextStyles.plus(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                  height: 1.5,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: AppTextStyles.plus(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                  height: 1.5,
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
                    label: _loading ? 'Please wait...' : 'Confirm Booking',
                    enabled: _agreed && !_loading,
                    onPressed: _continue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
