import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
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

  static const _codes = ['+91', '+1', '+44', '+971', '+65', '+61'];

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
                    hint: 'Enter your first name',
                    controller: _firstName,
                    hasError: _firstError,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message: _firstError ? 'First name is required' : null,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    hint: 'Enter your last name',
                    controller: _lastName,
                    hasError: _lastError,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message: _lastError ? 'Last name is required' : null,
                  ),
                  const SizedBox(height: 14),
                  _PhoneField(
                    countryCode: _countryCode,
                    codes: _codes,
                    controller: _phone,
                    hasError: _phoneError,
                    onCodeChanged: (code) => setState(() => _countryCode = code),
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message:
                        _phoneError ? 'Enter a valid contact number' : null,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    hint: 'Enter your email ID',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    hasError: _emailError,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message: _emailError ? 'Enter a valid email id' : null,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    hint: 'Enter your flight number (Optional)',
                    controller: _flight,
                    requiredMark: false,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    hint: 'Enter your special request (Optional)',
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

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.countryCode,
    required this.codes,
    required this.controller,
    required this.hasError,
    required this.onCodeChanged,
    required this.onChanged,
  });

  final String countryCode;
  final List<String> codes;
  final TextEditingController controller;
  final bool hasError;
  final ValueChanged<String> onCodeChanged;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasError
              ? AppColors.primary.withValues(alpha: 0.7)
              : AppColors.stroke,
        ),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            initialValue: countryCode,
            onSelected: onCodeChanged,
            itemBuilder: (context) => [
              for (final code in codes)
                PopupMenuItem(value: code, child: Text(code)),
            ],
            child: Row(
              children: [
                Text(
                  countryCode,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (controller.text.isEmpty)
                  IgnorePointer(
                    child: Text.rich(
                      TextSpan(
                        text: 'Enter your contact number',
                        style: AppTextStyles.fieldHint.copyWith(fontSize: 13),
                        children: [
                          TextSpan(
                            text: '*',
                            style: AppTextStyles.fieldHint.copyWith(
                              fontSize: 13,
                              color: AppColors.required,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onChanged: onChanged,
                  style: AppTextStyles.body.copyWith(fontSize: 14),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
