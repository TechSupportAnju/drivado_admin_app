import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssignRidePage extends StatefulWidget {
  const AssignRidePage({super.key, required this.booking});

  final ManagedBooking booking;

  @override
  State<AssignRidePage> createState() => _AssignRidePageState();
}

class _AssignRidePageState extends State<AssignRidePage> {
  static const _affiliates = [
    'Sanjay Das',
    'Maria Gomez',
    'Li Wei',
    'Aisha Khan',
    'Tomoko Tanaka',
    'Carlos Mendoza',
    'Fatima Al-Sayed',
  ];

  static const _currencies = ['USD', 'EUR', 'GBP', 'INR', 'AED', 'JPY'];

  final _price = TextEditingController();
  final _note = TextEditingController();
  final _affiliateSearch = TextEditingController();
  final _priceFocus = FocusNode();
  final _noteFocus = FocusNode();


  String? _affiliate;
  String? _currency;
  bool _submitted = false;
  bool _affiliateOpen = false;

  bool get _currencyError =>
      _submitted && (_currency == null || _currency!.isEmpty);

  bool get _priceError {
    if (!_submitted) return false;
    final value = double.tryParse(_price.text.trim());
    return value == null || value <= 0;
  }

  List<String> get _filteredAffiliates {
    final query = _affiliateSearch.text.trim().toLowerCase();
    if (query.isEmpty) return _affiliates;
    return _affiliates
        .where((name) => name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _priceFocus.addListener(() => setState(() {}));
    _noteFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _price.dispose();
    _note.dispose();
    _affiliateSearch.dispose();
    _priceFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  void _toggleAffiliate() {
    setState(() {
      _affiliateOpen = !_affiliateOpen;
      if (!_affiliateOpen) _affiliateSearch.clear();
    });
  }

  void _selectAffiliate(String name) {
    setState(() {
      _affiliate = name;
      _affiliateOpen = false;
      _affiliateSearch.clear();
    });
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
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
                  'Select Currency',
                  style: AppTextStyles.bodyStrong,
                  size: 16,
                ),
              ),
              for (final option in _currencies)
                ListTile(
                  title: AppText(
                    option,
                    style: AppTextStyles.body,
                    size: 15,
                    color: AppColors.textPrimary,
                  ),
                  trailing: option == _currency
                      ? const Icon(
                          Icons.check,
                          color: AppColors.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () => Navigator.pop(sheetContext, option),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (result != null) setState(() => _currency = result);
  }

  void _save() {
    setState(() => _submitted = true);
    if (_currencyError || _priceError) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
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
        title: Column(
          children: [
            AppText(
              'Assign Ride',
              style: AppTextStyles.subtitle,
              size: 20,
              color: AppColors.textOnDark,
              weight: FontWeight.w500,
            ),
            const SizedBox(height: 2),
            AppText(
              'Booking ID: ${widget.booking.id}',
              style: AppTextStyles.caption,
              size: 12,
              color: AppColors.textOnDark.withValues(alpha: 0.78),
              weight: FontWeight.w400,
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (_affiliateOpen) {
            setState(() {
              _affiliateOpen = false;
              _affiliateSearch.clear();
            });
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ListView(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    _DropdownField(
                      value: _affiliate,
                      placeholder: 'Select Affiliate',
                      showDivider: true,
                      expanded: _affiliateOpen,
                      onTap: _toggleAffiliate,
                    ),
                    const SizedBox(height: 18),
                    _DropdownField(
                      value: _currency,
                      placeholder: 'Currency',
                      requiredMark: true,
                      icon: AppIcons.assignCurrency,
                      onTap: _pickCurrency,
                    ),
                    AuthValidationMessage(
                      message: _currencyError ? 'Select currency' : null,
                    ),
                    const SizedBox(height: 18),
                    _AssignTextField(
                      controller: _price,
                      focusNode: _priceFocus,
                      icon: AppIcons.assignPrice,
                      label: 'Enter Purchase Price',
                      requiredMark: true,
                      hasError: _priceError,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      onChanged: (_) {
                        if (_submitted) setState(() {});
                      },
                    ),
                    AuthValidationMessage(
                      message: _priceError ? 'Enter valid price*' : null,
                    ),
                    const SizedBox(height: 18),
                    _AssignTextField(
                      controller: _note,
                      focusNode: _noteFocus,
                      icon: AppIcons.assignNote,
                      label: 'Enter P.P Note',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                side: const BorderSide(color: AppColors.stroke),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: AppTextStyles.button.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            label: 'Save',
                            onPressed: _save,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_affiliateOpen)
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: _AffiliateMenu(
                      controller: _affiliateSearch,
                      affiliates: _filteredAffiliates,
                      onChanged: (_) => setState(() {}),
                      onClose: _toggleAffiliate,
                      onSelect: _selectAffiliate,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AffiliateMenu extends StatelessWidget {
  const _AffiliateMenu({
    required this.controller,
    required this.affiliates,
    required this.onChanged,
    required this.onClose,
    required this.onSelect,
  });

  final TextEditingController controller;
  final List<String> affiliates;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 10,
      shadowColor: const Color(0x33000000),
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 14, right: 10),
                      child: AppSvgIcon(AppIcons.bookingsSearch, size: 18),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onChanged: onChanged,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: AppTextStyles.fieldHint,
                          filled: false,
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: AppColors.stroke,
                    ),
                    InkWell(
                      onTap: onClose,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.stroke),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: affiliates.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.divider,
                  ),
                  itemBuilder: (context, index) {
                    final name = affiliates[index];
                    return InkWell(
                      onTap: () => onSelect(name),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: AppText(
                          name,
                          style: AppTextStyles.body,
                          size: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssignTextField extends StatelessWidget {
  const _AssignTextField({
    required this.controller,
    required this.focusNode,
    required this.icon,
    required this.label,
    this.requiredMark = false,
    this.hasError = false,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String icon;
  final String label;
  final bool requiredMark;
  final bool hasError;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  InputDecoration get _borderless => const InputDecoration(
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final stacked = focusNode.hasFocus || controller.text.isNotEmpty;
        return _AssignFieldShell(
          icon: icon,
          hasError: hasError,
          tall: maxLines > 1,
          child: stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(text: label, requiredMark: requiredMark),
                    const SizedBox(height: 4),
                    TextField(
                      controller: controller,
                      focusNode: focusNode,
                      maxLines: maxLines,
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      onChanged: onChanged,
                      cursorColor: AppColors.primary,
                      style: AppTextStyles.bodyStrong.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                      decoration: _borderless.copyWith(isCollapsed: true),
                    ),
                  ],
                )
              : Align(
                  alignment: maxLines > 1
                      ? Alignment.topLeft
                      : Alignment.centerLeft,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: maxLines,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    onChanged: onChanged,
                    cursorColor: AppColors.primary,
                    style: AppTextStyles.bodyStrong.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    decoration: _borderless.copyWith(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: _FieldLabel(
                        text: label,
                        requiredMark: requiredMark,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _AssignFieldShell extends StatelessWidget {
  const _AssignFieldShell({
    required this.child,
    this.icon,
    this.trailing,
    this.hasError = false,
    this.tall = false,
    this.showDivider = false,
    this.onTap,
  });

  final Widget child;
  final String? icon;
  final Widget? trailing;
  final bool hasError;
  final bool tall;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: BoxConstraints(minHeight: tall ? 108 : 56),
      padding: EdgeInsets.fromLTRB(14, tall ? 14 : 10, 4, tall ? 14 : 10),
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
        crossAxisAlignment:
            tall ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Padding(
              padding: EdgeInsets.only(top: tall ? 2 : 0),
              child: AppSvgIcon(icon!, size: 20),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(child: child),
          if (showDivider)
            Container(
              width: 1,
              height: 28,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: AppColors.stroke,
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: content,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, this.requiredMark = false});

  final String text;
  final bool requiredMark;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: AppTextStyles.fieldHint.copyWith(fontSize: 12, height: 1.2),
        children: [
          if (requiredMark)
            TextSpan(
              text: '*',
              style: AppTextStyles.fieldHint.copyWith(
                fontSize: 12,
                color: AppColors.required,
                height: 1.2,
              ),
            ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.placeholder,
    required this.onTap,
    this.value,
    this.icon,
    this.requiredMark = false,
    this.hasError = false,
    this.showDivider = false,
    this.expanded = false,
  });

  final String placeholder;
  final String? value;
  final String? icon;
  final bool requiredMark;
  final bool hasError;
  final bool showDivider;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    return _AssignFieldShell(
      icon: icon,
      hasError: hasError,
      showDivider: showDivider,
      onTap: onTap,
      trailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(
          expanded
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          color: AppColors.textSecondary,
          size: 22,
        ),
      ),
      child: filled
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FieldLabel(text: placeholder, requiredMark: requiredMark),
                const SizedBox(height: 2),
                AppText(
                  value!,
                  style: AppTextStyles.bodyStrong,
                  size: 15,
                  color: AppColors.textPrimary,
                  weight: FontWeight.w600,
                ),
              ],
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: _FieldLabel(
                text: placeholder,
                requiredMark: requiredMark,
              ),
            ),
    );
  }
}
