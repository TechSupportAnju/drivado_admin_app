import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/coupons/domain/entities/coupon.dart';
import 'package:drivado_admin_app/features/coupons/domain/repositories/coupons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CouponFormPage extends StatefulWidget {
  const CouponFormPage({
    super.key,
    required this.type,
    this.coupon,
  });

  final CouponType type;
  final Coupon? coupon;

  bool get isEditing => coupon != null;
  bool get isOneTime => type == CouponType.oneTime;

  @override
  State<CouponFormPage> createState() => _CouponFormPageState();
}

class _CouponFormPageState extends State<CouponFormPage> {
  late final TextEditingController _count;
  late final TextEditingController _code;
  late final TextEditingController _bankName;
  late final TextEditingController _card;
  late final TextEditingController _microsite;
  late final TextEditingController _network;
  late final TextEditingController _discount;
  late final TextEditingController _threshold;

  DateTime? _startDate;
  DateTime? _expiryDate;
  bool _submitted = false;

  static final _dateFormat = DateFormat('dd/MM/yyyy');

  bool get _isOneTime => widget.isOneTime;
  bool get _includeCount => _isOneTime && !widget.isEditing;

  String get _title {
    if (widget.isEditing) return 'Edit Coupon';
    return _isOneTime ? 'Create Coupon By Count' : 'Create New Coupon';
  }

  String get _primaryLabel =>
      widget.isEditing ? 'Edit Coupon' : 'Create Coupon';

  bool get _countError =>
      _includeCount &&
      _submitted &&
      (int.tryParse(_count.text.trim()) == null ||
          int.parse(_count.text.trim()) <= 0);

  bool get _codeError => _submitted && _code.text.trim().isEmpty;
  bool get _bankError => _submitted && _bankName.text.trim().isEmpty;
  bool get _cardError => _submitted && _card.text.trim().isEmpty;
  bool get _micrositeError => _submitted && _microsite.text.trim().isEmpty;
  bool get _networkError => _submitted && _network.text.trim().isEmpty;
  bool get _discountError => _submitted && _discount.text.trim().isEmpty;
  bool get _thresholdError => _submitted && _threshold.text.trim().isEmpty;
  bool get _expiryError => _submitted && _expiryDate == null;

  @override
  void initState() {
    super.initState();
    final c = widget.coupon;
    _count = TextEditingController(text: c?.count?.toString() ?? '');
    _code = TextEditingController(
      text: _isOneTime
          ? (c?.prefix.isNotEmpty == true ? c!.prefix : (c?.code ?? ''))
          : (c?.code ?? ''),
    );
    _bankName = TextEditingController(text: c?.bankName ?? '');
    _card = TextEditingController(text: c?.card ?? '');
    _microsite = TextEditingController(text: c?.microsite ?? '');
    _network = TextEditingController(text: c?.network ?? '');
    _discount = TextEditingController(text: c?.discount ?? '');
    _threshold = TextEditingController(text: c?.thresholdPrice ?? '');
    _startDate = c?.startDate;
    _expiryDate = c?.expiryDate;
  }

  @override
  void dispose() {
    _count.dispose();
    _code.dispose();
    _bankName.dispose();
    _card.dispose();
    _microsite.dispose();
    _network.dispose();
    _discount.dispose();
    _threshold.dispose();
    super.dispose();
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1);
    var initial = _expiryDate ?? now;
    if (initial.isBefore(first)) initial = first;

    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: now.add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnDark,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected == null) return;
    setState(() => _expiryDate = selected);
  }

  void _submit() {
    setState(() => _submitted = true);
    final valid = !_countError &&
        !_codeError &&
        !_bankError &&
        !_cardError &&
        !_micrositeError &&
        !_networkError &&
        !_discountError &&
        !_thresholdError &&
        !_expiryError;
    if (!valid) return;

    final codeText = _code.text.trim().toUpperCase();
    final coupon = Coupon(
      id: widget.coupon?.id ?? 'c_${DateTime.now().millisecondsSinceEpoch}',
      code: _isOneTime ? (widget.coupon?.code ?? codeText) : codeText,
      type: widget.type,
      discount: _discount.text.trim(),
      bankName: _bankName.text.trim(),
      card: _card.text.trim(),
      microsite: _microsite.text.trim(),
      network: _network.text.trim(),
      thresholdPrice: _threshold.text.trim(),
      startDate: _startDate ?? DateTime.now(),
      expiryDate: _expiryDate!,
      prefix: _isOneTime ? codeText : '',
      count: _isOneTime
          ? (int.tryParse(_count.text.trim()) ?? widget.coupon?.count)
          : null,
    );

    context.read<CouponsRepository>().upsert(coupon);
    Navigator.of(context).pop(true);
  }

  AuthTextField _field({
    required String hint,
    required TextEditingController controller,
    required bool hasError,
    required String icon,
    TextInputType? keyboardType,
  }) {
    return AuthTextField(
      hint: hint,
      controller: controller,
      hasError: hasError,
      requiredMark: false,
      keyboardType: keyboardType,
      prefix: FieldPrefixIcon(icon, size: 16),
      onChanged: (_) => setState(() {}),
    );
  }

  List<Widget> _formFields() {
    final nameHint = _isOneTime ? 'Coupon Initial Name' : 'Coupon Name';
    final middle = <Widget>[
      _field(
        hint: nameHint,
        controller: _code,
        hasError: _codeError,
        icon: AppIcons.moreCoupon,
      ),
      AuthValidationMessage(
        message: _codeError ? 'Please enter $nameHint' : null,
      ),
      const SizedBox(height: 12),
      _field(
        hint: 'Microsite name',
        controller: _microsite,
        hasError: _micrositeError,
        icon: AppIcons.summaryNavigate,
      ),
      AuthValidationMessage(
        message: _micrositeError ? 'Please enter microsite name' : null,
      ),
      const SizedBox(height: 12),
      _field(
        hint: 'Card name',
        controller: _card,
        hasError: _cardError,
        icon: AppIcons.moreCoupon,
      ),
      AuthValidationMessage(
        message: _cardError ? 'Please enter card name' : null,
      ),
      const SizedBox(height: 12),
      _field(
        hint: 'Network name',
        controller: _network,
        hasError: _networkError,
        icon: AppIcons.summaryContact,
      ),
      AuthValidationMessage(
        message: _networkError ? 'Please enter network name' : null,
      ),
      const SizedBox(height: 12),
      _field(
        hint: 'Bank name',
        controller: _bankName,
        hasError: _bankError,
        icon: AppIcons.bookingsWallet,
      ),
      AuthValidationMessage(
        message: _bankError ? 'Please enter bank name' : null,
      ),
    ];

    final discount = <Widget>[
      _field(
        hint: 'Discount',
        controller: _discount,
        hasError: _discountError,
        icon: AppIcons.assignPrice,
      ),
      AuthValidationMessage(
        message: _discountError ? 'Please enter discount' : null,
      ),
      const SizedBox(height: 12),
      _field(
        hint: 'Threshold Price',
        controller: _threshold,
        hasError: _thresholdError,
        icon: AppIcons.assignPrice,
      ),
      AuthValidationMessage(
        message: _thresholdError ? 'Please enter threshold price' : null,
      ),
    ];

    final expiry = <Widget>[
      _DateField(
        hint: 'Expiry Date',
        value: _expiryDate == null ? null : _dateFormat.format(_expiryDate!),
        hasError: _expiryError,
        onTap: _pickExpiry,
      ),
      AuthValidationMessage(
        message: _expiryError ? 'Please select expiry date' : null,
      ),
    ];

    return [
      if (_includeCount) ...[
        _field(
          hint: 'Count',
          controller: _count,
          hasError: _countError,
          icon: AppIcons.assignPrice,
          keyboardType: TextInputType.number,
        ),
        AuthValidationMessage(
          message: _countError ? 'Please enter a valid count' : null,
        ),
        const SizedBox(height: 12),
      ],
      ...middle,
      const SizedBox(height: 12),
      if (_isOneTime) ...[
        ...discount,
        const SizedBox(height: 12),
        ...expiry,
      ] else ...[
        ...expiry,
        const SizedBox(height: 12),
        ...discount,
      ],
    ];
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
                    _title,
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
                        children: _formFields(),
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
                              label: _primaryLabel,
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

class _DateField extends StatelessWidget {
  const _DateField({
    required this.hint,
    required this.onTap,
    required this.hasError,
    this.value,
  });

  final String hint;
  final String? value;
  final bool hasError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError
                  ? AppColors.primary.withValues(alpha: 0.7)
                  : AppColors.stroke,
            ),
          ),
          child: Row(
            children: [
              const AppSvgIcon(
                AppIcons.bookingsCalendar,
                size: 14,
                color: Color(0xFF606060),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: filled
                    ? AppText(
                        value!,
                        style: AppTextStyles.bodyStrong,
                        size: 14,
                        color: AppColors.textPrimary,
                        weight: FontWeight.w500,
                      )
                    : Text(
                        hint,
                        style: AppTextStyles.fieldHint,
                      ),
              ),
              const AppSvgIcon(
                AppIcons.profileChevron,
                size: 12,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
