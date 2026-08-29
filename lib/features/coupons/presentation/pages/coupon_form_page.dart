import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/coupons/data/mock_coupons_store.dart';
import 'package:drivado_admin_app/features/coupons/domain/entities/coupon.dart';
import 'package:flutter/material.dart';
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

  String get _title {
    if (widget.isEditing) {
      return _isOneTime ? 'Edit Count' : 'Edit Coupon';
    }
    return _isOneTime ? 'Create Coupon By Count' : 'Create New Coupon';
  }

  String get _primaryLabel =>
      widget.isEditing ? 'Save Coupon' : 'Create Coupon';

  bool get _countError =>
      _isOneTime &&
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
  bool get _startError => _submitted && _startDate == null;
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

  Widget _icon(IconData icon) => Icon(
        icon,
        size: 20,
        color: AppColors.textSecondary,
      );

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final current = isStart ? _startDate : _expiryDate;
    final first = isStart
        ? DateTime(now.year - 1)
        : (_startDate ?? DateTime(now.year - 1));
    var initial = current ?? (isStart ? now : (_startDate ?? now));
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
    setState(() {
      if (isStart) {
        _startDate = selected;
        if (_expiryDate != null && _expiryDate!.isBefore(selected)) {
          _expiryDate = selected;
        }
      } else {
        _expiryDate = selected;
      }
    });
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
        !_startError &&
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
      startDate: _startDate!,
      expiryDate: _expiryDate!,
      prefix: _isOneTime ? codeText : '',
      count: _isOneTime ? int.tryParse(_count.text.trim()) : null,
    );

    MockCouponsStore.instance.upsert(coupon);
    Navigator.of(context).pop(true);
  }

  List<Widget> _sharedFields({required bool includeCount}) => [
        if (includeCount) ...[
          AuthTextField(
            hint: 'Count',
            controller: _count,
            keyboardType: TextInputType.number,
            hasError: _countError,
            prefix: _icon(Icons.tag_outlined),
            onChanged: (_) => setState(() {}),
          ),
          AuthValidationMessage(
            message: _countError ? 'Please enter a valid count' : null,
          ),
          const SizedBox(height: 14),
        ],
        AuthTextField(
          hint: includeCount ? 'Coupon Code Prefix' : 'Coupon Name',
          controller: _code,
          hasError: _codeError,
          prefix: _icon(Icons.confirmation_number_outlined),
          onChanged: (_) => setState(() {}),
        ),
        AuthValidationMessage(
          message: _codeError
              ? (includeCount
                  ? 'Please enter coupon code prefix'
                  : 'Please enter coupon name')
              : null,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          hint: 'Bank Name',
          controller: _bankName,
          hasError: _bankError,
          prefix: _icon(Icons.account_balance_outlined),
          onChanged: (_) => setState(() {}),
        ),
        AuthValidationMessage(
          message: _bankError ? 'Please enter bank name' : null,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          hint: 'Card',
          controller: _card,
          hasError: _cardError,
          prefix: _icon(Icons.credit_card_outlined),
          onChanged: (_) => setState(() {}),
        ),
        AuthValidationMessage(
          message: _cardError ? 'Please enter card' : null,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          hint: 'Microsite',
          controller: _microsite,
          hasError: _micrositeError,
          prefix: _icon(Icons.language_rounded),
          onChanged: (_) => setState(() {}),
        ),
        AuthValidationMessage(
          message: _micrositeError ? 'Please enter microsite' : null,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          hint: 'Network',
          controller: _network,
          hasError: _networkError,
          prefix: _icon(Icons.hub_outlined),
          onChanged: (_) => setState(() {}),
        ),
        AuthValidationMessage(
          message: _networkError ? 'Please enter network' : null,
        ),
        const SizedBox(height: 14),
        _DateField(
          hint: 'Start Date',
          icon: Icons.calendar_today_outlined,
          value: _startDate == null ? null : _dateFormat.format(_startDate!),
          hasError: _startError,
          onTap: () => _pickDate(isStart: true),
        ),
        AuthValidationMessage(
          message: _startError ? 'Please select start date' : null,
        ),
        const SizedBox(height: 14),
        _DateField(
          hint: 'End Date',
          icon: Icons.event_outlined,
          value: _expiryDate == null ? null : _dateFormat.format(_expiryDate!),
          hasError: _expiryError,
          showChevron: true,
          onTap: () => _pickDate(isStart: false),
        ),
        AuthValidationMessage(
          message: _expiryError ? 'Please select end date' : null,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          hint: 'Discount',
          controller: _discount,
          hasError: _discountError,
          prefix: _icon(Icons.percent_rounded),
          onChanged: (_) => setState(() {}),
        ),
        AuthValidationMessage(
          message: _discountError ? 'Please enter discount' : null,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          hint: 'Threshold Price',
          controller: _threshold,
          hasError: _thresholdError,
          prefix: _icon(Icons.payments_outlined),
          onChanged: (_) => setState(() {}),
        ),
        AuthValidationMessage(
          message: _thresholdError ? 'Please enter threshold price' : null,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 72,
        leadingWidth: 64,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const AppSvgIcon(AppIcons.summaryBack, size: 40),
        ),
        title: AppText(
          _title,
          style: AppTextStyles.subtitle,
          size: 18,
          color: AppColors.textOnDark,
          weight: FontWeight.w500,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: _sharedFields(includeCount: _isOneTime),
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
                          backgroundColor: const Color(0xFFE8E9EE),
                          side: BorderSide.none,
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
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.hint,
    required this.icon,
    required this.onTap,
    required this.hasError,
    this.value,
    this.showChevron = false,
  });

  final String hint;
  final IconData icon;
  final String? value;
  final bool hasError;
  final bool showChevron;
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: filled
                    ? AppText(
                        value!,
                        style: AppTextStyles.bodyStrong,
                        size: 13,
                        color: AppColors.textPrimary,
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
              if (showChevron)
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
