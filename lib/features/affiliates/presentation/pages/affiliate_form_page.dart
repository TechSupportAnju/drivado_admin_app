import 'dart:io';

import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:drivado_admin_app/features/affiliates/domain/repositories/affiliates_repository.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/widgets/affiliate_avatar.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/widgets/affiliate_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AffiliateFormPage extends StatefulWidget {
  const AffiliateFormPage({super.key, this.affiliate});

  final Affiliate? affiliate;

  bool get isEditing => affiliate != null;

  @override
  State<AffiliateFormPage> createState() => _AffiliateFormPageState();
}

class _AffiliateFormPageState extends State<AffiliateFormPage> {
  static const _cities = [
    'London',
    'Paris',
    'New York',
    'Tokyo',
    'Berlin',
    'Rome',
  ];
  static const _countries = [
    'United Kingdom',
    'France',
    'United States',
    'Japan',
    'Germany',
    'Italy',
  ];

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
  String? _photoPath;
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
    _photoPath = a?.photoPath;
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

  Future<void> _changePhoto() async {
    final source = await showChangeProfileSheet(context);
    if (source == null || !mounted) return;
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (picked == null || !mounted) return;
      final dir = await getApplicationDocumentsDirectory();
      final dest = File(
        p.join(
          dir.path,
          'affiliate_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}',
        ),
      );
      await dest.writeAsBytes(await picked.readAsBytes());
      if (!mounted) return;
      setState(() => _photoPath = dest.path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update profile photo')),
      );
    }
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
    context.read<AffiliatesRepository>().upsert(
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
        locations: existing?.locations ?? '',
        photoPath: _photoPath,
        initials: existing?.initials ?? '',
        logoColor: existing?.logoColor ?? 0xFF1A365D,
      ),
    );
    Navigator.of(context).pop(true);
  }

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
                    size: 20,
                    color: AppColors.textOnDark,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F7F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: AppContent(
                      maxWidth: AppLayout.of(context).formMaxWidth,
                      child: ListView(
                        padding: AppLayout.of(context).scrollPadding(
                          top: 16,
                          bottom: 24,
                        ),
                        children: [
                          _AvatarPicker(
                            photoPath: _photoPath,
                            initials: widget.affiliate?.displayInitials,
                            color: widget.affiliate == null
                                ? null
                                : Color(widget.affiliate!.logoColor),
                            onCameraTap: _changePhoto,
                          ),
                          const SizedBox(height: 16),
                          AffiliateInputField(
                            label: 'Affiliate Name',
                            hint: 'Enter affiliate name',
                            controller: _name,
                            hasError: _nameError,
                            icon: AppIcons.affiliateUser,
                            onChanged: (_) => setState(() {}),
                          ),
                          AffiliateFieldError(
                            message: _nameError
                                ? 'This field is required*'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliateInputField(
                            label: 'Contact Person',
                            hint: 'Enter contact person',
                            controller: _contactPerson,
                            hasError: _contactError,
                            icon: AppIcons.affiliateUser,
                            onChanged: (_) => setState(() {}),
                          ),
                          AffiliateFieldError(
                            message: _contactError
                                ? 'This field is required*'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliateInputField(
                            label: 'Affiliate Id',
                            hint: 'Enter affiliate Id',
                            controller: _affiliateId,
                            hasError: _idError,
                            icon: AppIcons.affiliatePersonalCard,
                            onChanged: (_) => setState(() {}),
                          ),
                          AffiliateFieldError(
                            message:
                                _idError ? 'This field is required*' : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliateInputField(
                            label: 'Company Password',
                            hint: 'Enter password',
                            controller: _password,
                            hasError: _passwordError,
                            icon: AppIcons.affiliateLock,
                            onChanged: (_) => setState(() {}),
                          ),
                          AffiliateFieldError(
                            message: _passwordError
                                ? 'This field is required*'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliateInputField(
                            label: 'Email 1 (username)',
                            hint: 'Enter user name',
                            controller: _email1,
                            keyboardType: TextInputType.emailAddress,
                            hasError: _email1Error,
                            icon: AppIcons.affiliateSms,
                            onChanged: (_) => setState(() {}),
                          ),
                          AffiliateFieldError(
                            message: _email1Error
                                ? 'This field is required*'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliateInputField(
                            label: 'Email 2',
                            hint: 'Enter email',
                            controller: _email2,
                            keyboardType: TextInputType.emailAddress,
                            hasError: _email2Error,
                            icon: AppIcons.affiliateSms,
                            onChanged: (_) => setState(() {}),
                          ),
                          AffiliateFieldError(
                            message: _email2Error
                                ? 'This field is required*'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliatePhoneField(
                            label: 'Contact Number 1',
                            hint: 'Enter Contact Number 1',
                            controller: _phone1,
                            countryCode: _code1,
                            hasError: _phone1Error,
                            onCountryCodeChanged: (code) =>
                                setState(() => _code1 = code),
                            onChanged: (_) => setState(() {}),
                          ),
                          AffiliateFieldError(
                            message: _phone1Error
                                ? 'This field is required*'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliatePhoneField(
                            label: 'Contact Number 2',
                            hint: 'Enter Contact Number 2',
                            requiredMark: false,
                            controller: _phone2,
                            countryCode: _code2,
                            onCountryCodeChanged: (code) =>
                                setState(() => _code2 = code),
                          ),
                          const SizedBox(height: 12),
                          AffiliatePhoneField(
                            label: 'Contact Number 3',
                            hint: 'Enter Contact Number 3',
                            requiredMark: false,
                            controller: _phone3,
                            countryCode: _code3,
                            onCountryCodeChanged: (code) =>
                                setState(() => _code3 = code),
                          ),
                          const SizedBox(height: 12),
                          AffiliateInputField(
                            label: 'Address',
                            hint: 'Enter Address',
                            controller: _address,
                            maxLines: 3,
                            minHeight: 80,
                            hasError: _addressError,
                            icon: AppIcons.affiliateLocation,
                            onChanged: (_) => setState(() {}),
                          ),
                          AffiliateFieldError(
                            message: _addressError
                                ? 'Please Enter Valid Address'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliateDropdownField(
                            label: 'Enter city',
                            icon: AppIcons.affiliateBuildings,
                            value: _city,
                            hasError: _cityError,
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final selected = await showAffiliateSearchPicker(
                                context,
                                searchHint: 'Search for city',
                                options: _cities,
                                current: _city,
                              );
                              if (selected == null) return;
                              setState(() => _city = selected);
                            },
                          ),
                          AffiliateFieldError(
                            message:
                                _cityError ? 'This field is required*' : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliateDropdownField(
                            label: 'Enter Country',
                            icon: AppIcons.affiliateCourthouse,
                            value: _country,
                            hasError: _countryError,
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final selected = await showAffiliateSearchPicker(
                                context,
                                searchHint: 'Search for country',
                                options: _countries,
                                current: _country,
                              );
                              if (selected == null) return;
                              setState(() => _country = selected);
                            },
                          ),
                          AffiliateFieldError(
                            message: _countryError
                                ? 'This field is required*'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          AffiliateDropdownField(
                            label: 'Status',
                            icon: AppIcons.affiliateStatus,
                            value: _status,
                            hasError: _statusError,
                            valueColor: _status == 'Active'
                                ? const Color(0xFF098C31)
                                : AppColors.textPrimary,
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final selected = await showAffiliateStatusPicker(
                                context,
                                current: _status,
                              );
                              if (selected == null) return;
                              setState(() {
                                _status = selected == 'None' ? null : selected;
                              });
                            },
                          ),
                          AffiliateFieldError(
                            message: _statusError
                                ? 'This field is required*'
                                : null,
                          ),
                        ],
                      ),
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
                                  foregroundColor: const Color(0xFF191919),
                                  backgroundColor: AppColors.surface,
                                  side: const BorderSide(
                                    color: Color(0xFFE6E8E7),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.button.copyWith(
                                    color: const Color(0xFF191919),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
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
  const _AvatarPicker({
    required this.onCameraTap,
    this.photoPath,
    this.initials,
    this.color,
  });

  final String? photoPath;
  final String? initials;
  final Color? color;
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AffiliateAvatar(
                size: 80,
                photoPath: photoPath,
                initials: initials,
                backgroundColor: color,
                showPlaceholderSilhouette:
                    (photoPath == null || photoPath!.isEmpty) &&
                    (initials == null || initials!.isEmpty),
                initialsSize: 24,
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Material(
                  color: const Color(0xFF0D0D0D),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onCameraTap,
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: AppSvgIcon(
                          AppIcons.affiliateCamera,
                          size: 12,
                        ),
                      ),
                    ),
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
