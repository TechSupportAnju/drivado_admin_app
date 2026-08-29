import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/affiliates/data/mock_affiliates_store.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AffiliateFormPage extends StatefulWidget {
  const AffiliateFormPage({super.key, this.affiliate});

  final Affiliate? affiliate;

  bool get isEditing => affiliate != null;

  @override
  State<AffiliateFormPage> createState() => _AffiliateFormPageState();
}

class _AffiliateFormPageState extends State<AffiliateFormPage> {
  static const _countryCodes = ['+91', '+1', '+44', '+33', '+49', '+61'];
  static const _cities = [
    'Kolkata, West Bengal',
    'London',
    'Paris',
    'Berlin',
    'New York',
    'Sydney',
    'Dubai',
    'Singapore',
  ];
  static const _countries = [
    'India',
    'United Kingdom',
    'France',
    'Germany',
    'United States',
    'Australia',
    'United Arab Emirates',
    'Singapore',
  ];
  static const _statuses = ['Active', 'Inactive'];

  late final TextEditingController _name;
  late final TextEditingController _contactPerson;
  late final TextEditingController _affiliateId;
  late final TextEditingController _password;
  late final TextEditingController _email1;
  late final TextEditingController _email2;
  late final TextEditingController _phone1;
  late final TextEditingController _phone2;
  late final TextEditingController _phone3;
  late final TextEditingController _address;

  late String _code1;
  late String _code2;
  late String _code3;
  String? _city;
  String? _country;
  String? _status;
  bool _obscurePassword = true;
  bool _submitted = false;

  bool get _nameError => _submitted && _name.text.trim().isEmpty;
  bool get _contactError => _submitted && _contactPerson.text.trim().isEmpty;
  bool get _idError => _submitted && _affiliateId.text.trim().isEmpty;
  bool get _passwordError =>
      _submitted && !widget.isEditing && _password.text.trim().isEmpty;
  bool get _email1Error => _submitted && _email1.text.trim().isEmpty;
  bool get _email2Error => _submitted && _email2.text.trim().isEmpty;
  bool get _phone1Error => _submitted && _phone1.text.trim().length < 8;
  bool get _addressError => _submitted && _address.text.trim().isEmpty;
  bool get _cityError => _submitted && (_city == null || _city!.isEmpty);
  bool get _countryError =>
      _submitted && (_country == null || _country!.isEmpty);
  bool get _statusError =>
      _submitted && (_status == null || _status!.isEmpty);

  @override
  void initState() {
    super.initState();
    final a = widget.affiliate;
    _name = TextEditingController(text: a?.name ?? '');
    _contactPerson = TextEditingController(text: a?.contactPerson ?? '');
    _affiliateId = TextEditingController(text: a?.affiliateId ?? '');
    _password = TextEditingController(text: a?.password ?? '');
    _email1 = TextEditingController(text: a?.email1 ?? '');
    _email2 = TextEditingController(text: a?.email2 ?? '');
    _phone1 = TextEditingController(text: a?.phone1 ?? '');
    _phone2 = TextEditingController(text: a?.phone2 ?? '');
    _phone3 = TextEditingController(text: a?.phone3 ?? '');
    _address = TextEditingController(text: a?.address ?? '');
    _code1 = a?.countryCode1 ?? '+91';
    _code2 = a?.countryCode2 ?? '+91';
    _code3 = a?.countryCode3 ?? '+91';
    _city = a?.city;
    _country = a?.country;
    _status = a == null ? null : (a.active ? 'Active' : 'Inactive');
  }

  @override
  void dispose() {
    _name.dispose();
    _contactPerson.dispose();
    _affiliateId.dispose();
    _password.dispose();
    _email1.dispose();
    _email2.dispose();
    _phone1.dispose();
    _phone2.dispose();
    _phone3.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<String?> _pickOption({
    required String title,
    required List<String> options,
    String? current,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: AppText(
                  title,
                  style: AppTextStyles.bodyStrong,
                  size: 16,
                ),
              ),
              for (final option in options)
                ListTile(
                  title: AppText(
                    option,
                    style: AppTextStyles.body,
                    size: 15,
                    color: option == current
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    weight: option == current
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  onTap: () => Navigator.of(sheetContext).pop(option),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickCountryCode(int index) async {
    final selected = await _pickOption(
      title: 'Select Country Code',
      options: _countryCodes,
      current: index == 1
          ? _code1
          : index == 2
              ? _code2
              : _code3,
    );
    if (selected == null) return;
    setState(() {
      if (index == 1) {
        _code1 = selected;
      } else if (index == 2) {
        _code2 = selected;
      } else {
        _code3 = selected;
      }
    });
  }

  void _submit() {
    setState(() => _submitted = true);
    final valid = !_nameError &&
        !_contactError &&
        !_idError &&
        !_passwordError &&
        !_email1Error &&
        !_email2Error &&
        !_phone1Error &&
        !_addressError &&
        !_cityError &&
        !_countryError &&
        !_statusError;
    if (!valid) return;

    final existing = widget.affiliate;
    MockAffiliatesStore.instance.upsert(
      Affiliate(
        id: existing?.id ?? 'a_${DateTime.now().millisecondsSinceEpoch}',
        name: _name.text.trim(),
        contactPerson: _contactPerson.text.trim(),
        affiliateId: _affiliateId.text.trim(),
        password: _password.text.trim().isEmpty
            ? (existing?.password ?? '')
            : _password.text.trim(),
        email1: _email1.text.trim(),
        email2: _email2.text.trim(),
        phone1: _phone1.text.trim(),
        phone2: _phone2.text.trim(),
        phone3: _phone3.text.trim(),
        countryCode1: _code1,
        countryCode2: _code2,
        countryCode3: _code3,
        address: _address.text.trim(),
        city: _city!,
        country: _country!,
        active: _status == 'Active',
        initials: existing?.initials ?? '',
        logoColor: existing?.logoColor ?? 0xFF1A365D,
      ),
    );
    Navigator.of(context).pop(true);
  }

  Widget _prefixIcon(IconData icon) => Icon(
        icon,
        size: 20,
        color: AppColors.textSecondary,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const AppSvgIcon(AppIcons.summaryBack, size: 40),
                    ),
                  ),
                  AppText(
                    widget.isEditing ? 'Edit Affiliate' : 'Add Affiliate',
                    style: AppTextStyles.subtitle,
                    size: 18,
                    color: AppColors.textOnDark,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                      children: [
                        _AvatarPicker(
                          initials: widget.affiliate?.displayInitials,
                          color: widget.affiliate == null
                              ? null
                              : Color(widget.affiliate!.logoColor),
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          hint: 'Affiliate Name',
                          controller: _name,
                          hasError: _nameError,
                          prefix: _prefixIcon(Icons.person_outline_rounded),
                          onChanged: (_) => setState(() {}),
                        ),
                        AuthValidationMessage(
                          message: _nameError ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          hint: 'Contact Person',
                          controller: _contactPerson,
                          hasError: _contactError,
                          prefix: _prefixIcon(Icons.person_outline_rounded),
                          onChanged: (_) => setState(() {}),
                        ),
                        AuthValidationMessage(
                          message:
                              _contactError ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          hint: 'Affiliate Id',
                          controller: _affiliateId,
                          hasError: _idError,
                          prefix: _prefixIcon(Icons.badge_outlined),
                          onChanged: (_) => setState(() {}),
                        ),
                        AuthValidationMessage(
                          message: _idError ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          hint: 'Company Password',
                          controller: _password,
                          obscureText: _obscurePassword,
                          hasError: _passwordError,
                          prefix: _prefixIcon(Icons.lock_outline_rounded),
                          suffix: IconButton(
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: AppSvgIcon(
                              _obscurePassword
                                  ? AppIcons.authEye
                                  : AppIcons.authEyeOff,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        AuthValidationMessage(
                          message:
                              _passwordError ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          hint: 'Email 1 (username)',
                          controller: _email1,
                          keyboardType: TextInputType.emailAddress,
                          hasError: _email1Error,
                          prefix: _prefixIcon(Icons.mail_outline_rounded),
                          onChanged: (_) => setState(() {}),
                        ),
                        AuthValidationMessage(
                          message:
                              _email1Error ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          hint: 'Email 2',
                          controller: _email2,
                          keyboardType: TextInputType.emailAddress,
                          hasError: _email2Error,
                          prefix: _prefixIcon(Icons.mail_outline_rounded),
                          onChanged: (_) => setState(() {}),
                        ),
                        AuthValidationMessage(
                          message:
                              _email2Error ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        _PhoneField(
                          hint: 'Contact Number 1',
                          requiredMark: true,
                          controller: _phone1,
                          countryCode: _code1,
                          hasError: _phone1Error,
                          onCodeTap: () => _pickCountryCode(1),
                          onChanged: (_) => setState(() {}),
                        ),
                        AuthValidationMessage(
                          message:
                              _phone1Error ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        _PhoneField(
                          hint: 'Enter Contact Number 2',
                          requiredMark: false,
                          controller: _phone2,
                          countryCode: _code2,
                          hasError: false,
                          onCodeTap: () => _pickCountryCode(2),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        _PhoneField(
                          hint: 'Enter Contact Number 3',
                          requiredMark: false,
                          controller: _phone3,
                          countryCode: _code3,
                          hasError: false,
                          onCodeTap: () => _pickCountryCode(3),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          hint: 'Address',
                          controller: _address,
                          maxLines: 3,
                          hasError: _addressError,
                          prefix: Padding(
                            padding: const EdgeInsets.only(bottom: 28),
                            child: _prefixIcon(Icons.location_on_outlined),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        AuthValidationMessage(
                          message: _addressError
                              ? 'Please Enter Valid Address'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _DropdownField(
                          hint: 'Enter City',
                          value: _city,
                          hasError: _cityError,
                          valueColor: AppColors.textPrimary,
                          onTap: () async {
                            final selected = await _pickOption(
                              title: 'Select City',
                              options: _cities,
                              current: _city,
                            );
                            if (selected == null) return;
                            setState(() => _city = selected);
                          },
                        ),
                        AuthValidationMessage(
                          message: _cityError ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        _DropdownField(
                          hint: 'Enter Country',
                          value: _country,
                          hasError: _countryError,
                          valueColor: AppColors.textPrimary,
                          onTap: () async {
                            final selected = await _pickOption(
                              title: 'Select Country',
                              options: _countries,
                              current: _country,
                            );
                            if (selected == null) return;
                            setState(() => _country = selected);
                          },
                        ),
                        AuthValidationMessage(
                          message:
                              _countryError ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 14),
                        _DropdownField(
                          hint: 'Status',
                          value: _status,
                          hasError: _statusError,
                          valueColor: _status == 'Active'
                              ? AppColors.successGreen
                              : AppColors.textPrimary,
                          onTap: () async {
                            final selected = await _pickOption(
                              title: 'Select Status',
                              options: _statuses,
                              current: _status,
                            );
                            if (selected == null) return;
                            setState(() => _status = selected);
                          },
                        ),
                        AuthValidationMessage(
                          message:
                              _statusError ? 'This field is required' : null,
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  backgroundColor: AppColors.surface,
                                  side: const BorderSide(
                                    color: AppColors.stroke,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: widget.isEditing
                                  ? 'Update'
                                  : 'Add Affiliate',
                              onPressed: _submit,
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
        ],
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({this.initials, this.color});

  final String? initials;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final hasLogo = initials != null && color != null;
    return Center(
      child: SizedBox(
        width: 96,
        height: 96,
        child: Stack(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: hasLogo ? color : const Color(0xFFE8E9EE),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: hasLogo
                  ? AppText(
                      initials!,
                      style: AppTextStyles.subtitle,
                      size: 28,
                      color: AppColors.textOnDark,
                      weight: FontWeight.w700,
                    )
                  : const Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: Color(0xFF9AA0A6),
                    ),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.stroke),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
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
    required this.hint,
    required this.requiredMark,
    required this.controller,
    required this.countryCode,
    required this.hasError,
    required this.onCodeTap,
    required this.onChanged,
  });

  final String hint;
  final bool requiredMark;
  final TextEditingController controller;
  final String countryCode;
  final bool hasError;
  final VoidCallback onCodeTap;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: onCodeTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countryCode,
                    style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Container(width: 1, height: 20, color: AppColors.stroke),
                ],
              ),
            ),
          ),
          label: Text.rich(
            TextSpan(
              text: hint,
              style: AppTextStyles.fieldHint,
              children: [
                if (requiredMark)
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: hasError
                  ? AppColors.primary.withValues(alpha: 0.44)
                  : AppColors.stroke,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: hasError
                  ? AppColors.primary.withValues(alpha: 0.44)
                  : AppColors.primary,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.hint,
    required this.onTap,
    required this.hasError,
    this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String hint;
  final String? value;
  final bool hasError;
  final Color valueColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError
                  ? AppColors.primary.withValues(alpha: 0.7)
                  : AppColors.stroke,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: filled
                    ? AppText(
                        value!,
                        style: AppTextStyles.bodyStrong,
                        size: 13,
                        color: valueColor,
                        weight: FontWeight.w500,
                      )
                    : Text.rich(
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
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
