import 'package:drivado_admin_app/core/country_code/country_code.dart';
import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/country_code_phone_field.dart';
import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditBookingPage extends StatefulWidget {
  const EditBookingPage({super.key, required this.booking});

  final ManagedBooking booking;

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  static const _currencies = ['USD', 'EUR', 'GBP', 'INR', 'AED', 'JPY'];

  late final TextEditingController _price;
  late final TextEditingController _extraPrice;
  late final TextEditingController _extraHours;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;
  late final TextEditingController _flight;
  late final TextEditingController _reference;

  late final FocusNode _priceFocus;
  late final FocusNode _extraPriceFocus;
  late final FocusNode _extraHoursFocus;
  late final FocusNode _firstNameFocus;
  late final FocusNode _lastNameFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _flightFocus;
  late final FocusNode _referenceFocus;

  late String _currency;
  late String _countryCode;
  late DateTime _date;
  late TimeOfDay _time;
  bool _submitted = false;

  bool get _currencyError => _submitted && _currency.isEmpty;
  bool get _priceError {
    if (!_submitted) return false;
    final value = double.tryParse(_price.text.trim());
    return value == null || value <= 0;
  }

  bool get _firstNameError => _submitted && _firstName.text.trim().isEmpty;
  bool get _lastNameError => _submitted && _lastName.text.trim().isEmpty;
  bool get _phoneError => _submitted && _phone.text.trim().length < 8;

  double get _priceValue => double.tryParse(_price.text.trim()) ?? 0;
  double get _extraPriceValue => double.tryParse(_extraPrice.text.trim()) ?? 0;
  double get _total => _priceValue + _extraPriceValue;

  String get _totalLabel {
    final value = _total;
    final amount = value == value.roundToDouble()
        ? value.round().toString()
        : value.toStringAsFixed(2);
    return '$_currency $amount';
  }

  @override
  void initState() {
    super.initState();
    final booking = widget.booking;
    final parsed = _parseAmount(booking.amount);
    _currency = parsed.$1;
    _price = TextEditingController(text: parsed.$2);
    _extraPrice = TextEditingController();
    _extraHours = TextEditingController();

    final names = booking.customer.trim().split(RegExp(r'\s+'));
    _firstName = TextEditingController(
      text: names.isEmpty ? '' : names.first,
    );
    _lastName = TextEditingController(
      text: names.length < 2 ? '' : names.sublist(1).join(' '),
    );

    final phone = _parsePhone(booking.customerPhone);
    _countryCode = phone.$1;
    _phone = TextEditingController(text: phone.$2);
    _flight = TextEditingController();
    _reference = TextEditingController(
      text: booking.referenceNumber == '—' ? '' : booking.referenceNumber,
    );

    _date = booking.scheduledAt;
    _time = TimeOfDay.fromDateTime(booking.scheduledAt);

    _priceFocus = FocusNode()..addListener(() => setState(() {}));
    _extraPriceFocus = FocusNode()..addListener(() => setState(() {}));
    _extraHoursFocus = FocusNode()..addListener(() => setState(() {}));
    _firstNameFocus = FocusNode()..addListener(() => setState(() {}));
    _lastNameFocus = FocusNode()..addListener(() => setState(() {}));
    _phoneFocus = FocusNode()..addListener(() => setState(() {}));
    _flightFocus = FocusNode()..addListener(() => setState(() {}));
    _referenceFocus = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _price.dispose();
    _extraPrice.dispose();
    _extraHours.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _flight.dispose();
    _reference.dispose();
    _priceFocus.dispose();
    _extraPriceFocus.dispose();
    _extraHoursFocus.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();
    _flightFocus.dispose();
    _referenceFocus.dispose();
    super.dispose();
  }

  (String, String) _parseAmount(String amount) {
    final match = RegExp(r'([A-Za-z]+)\s*([\d.]+)').firstMatch(amount);
    if (match == null) return ('USD', '');
    final code = match.group(1)!.toUpperCase();
    final raw = double.tryParse(match.group(2)!) ?? 0;
    final value =
        raw == raw.roundToDouble() ? raw.round().toString() : match.group(2)!;
    return (_currencies.contains(code) ? code : 'USD', value);
  }

  (String, String) _parsePhone(String phone) => splitPhone(phone);

  String _formatDate(DateTime date) => DateFormat('dd/MM/yy').format(date);

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickCurrency() async {
    final result = await _showOptionsSheet(
      title: 'Select Currency',
      options: _currencies,
      selected: _currency,
    );
    if (result != null) setState(() => _currency = result);
  }

  Future<String?> _showOptionsSheet({
    required String title,
    required List<String> options,
    required String selected,
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
                    color: AppColors.textPrimary,
                  ),
                  trailing: option == selected
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
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
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
    setState(() => _date = selected);
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _time,
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
    setState(() => _time = selected);
  }

  void _save() {
    setState(() => _submitted = true);
    if (_currencyError ||
        _priceError ||
        _firstNameError ||
        _lastNameError ||
        _phoneError) {
      return;
    }
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
              'Edit Booking',
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Price Details'),
                  const SizedBox(height: 14),
                  _EditPickerField(
                    icon: AppIcons.assignCurrency,
                    placeholder: 'Currency',
                    requiredMark: true,
                    value: _currency,
                    hasError: _currencyError,
                    showChevron: true,
                    onTap: _pickCurrency,
                  ),
                  AuthValidationMessage(
                    message: _currencyError ? 'Please select currency' : null,
                  ),
                  const SizedBox(height: 14),
                  _EditTextField(
                    controller: _price,
                    focusNode: _priceFocus,
                    icon: AppIcons.assignPrice,
                    label: 'Price',
                    requiredMark: true,
                    hasError: _priceError,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (_) => setState(() {}),
                  ),
                  AuthValidationMessage(
                    message: _priceError ? 'Please enter price' : null,
                  ),
                  const SizedBox(height: 14),
                  _EditTextField(
                    controller: _extraPrice,
                    focusNode: _extraPriceFocus,
                    icon: AppIcons.assignPrice,
                    label: 'Enter Extra Price',
                    requiredMark: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  _EditTextField(
                    controller: _extraHours,
                    focusNode: _extraHoursFocus,
                    icon: AppIcons.cloneClock,
                    label: 'Enter Extra Hours',
                    requiredMark: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _TotalPriceBar(label: _totalLabel),
                  const SizedBox(height: 24),
                  const _SectionTitle('Passenger Details'),
                  const SizedBox(height: 14),
                  _EditTextField(
                    controller: _firstName,
                    focusNode: _firstNameFocus,
                    icon: AppIcons.summaryPax,
                    label: 'Pax First Name',
                    requiredMark: true,
                    hasError: _firstNameError,
                    onChanged: (_) {
                      if (_submitted) setState(() {});
                    },
                  ),
                  AuthValidationMessage(
                    message:
                        _firstNameError ? 'Please enter first name' : null,
                  ),
                  const SizedBox(height: 14),
                  _EditTextField(
                    controller: _lastName,
                    focusNode: _lastNameFocus,
                    icon: AppIcons.summaryPax,
                    label: 'Pax Last Name',
                    requiredMark: true,
                    hasError: _lastNameError,
                    onChanged: (_) {
                      if (_submitted) setState(() {});
                    },
                  ),
                  AuthValidationMessage(
                    message: _lastNameError ? 'Please enter last name' : null,
                  ),
                  const SizedBox(height: 14),
                  CountryCodePhoneField(
                    countryCode: _countryCode,
                    controller: _phone,
                    focusNode: _phoneFocus,
                    hasError: _phoneError,
                    onCountryCodeChanged: (code) =>
                        setState(() => _countryCode = code),
                    onChanged: (_) {
                      if (_submitted) setState(() {});
                    },
                  ),
                  AuthValidationMessage(
                    message:
                        _phoneError ? 'Please enter contact number' : null,
                  ),
                  const SizedBox(height: 14),
                  _EditTextField(
                    controller: _flight,
                    focusNode: _flightFocus,
                    icon: AppIcons.summaryFlight,
                    label: 'Flight Number (optional)',
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('Booking Details'),
                  const SizedBox(height: 14),
                  _EditTextField(
                    controller: _reference,
                    focusNode: _referenceFocus,
                    icon: AppIcons.summaryDocument,
                    label: 'Reference Number (Optional)',
                  ),
                  const SizedBox(height: 14),
                  _EditPickerField(
                    icon: AppIcons.cloneClock,
                    placeholder: 'Travel Date',
                    requiredMark: true,
                    value: _formatDate(_date),
                    showChevron: true,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 14),
                  _EditPickerField(
                    icon: AppIcons.cloneClock,
                    placeholder: 'Travel Time',
                    requiredMark: true,
                    value: _formatTime(_time),
                    showChevron: true,
                    onTap: _pickTime,
                  ),
                  const SizedBox(height: 24),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      style: AppTextStyles.subtitle,
      size: 16,
      color: AppColors.textPrimary,
      weight: FontWeight.w700,
    );
  }
}

class _TotalPriceBar extends StatelessWidget {
  const _TotalPriceBar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text.rich(
        TextSpan(
          text: 'Total Price: ',
          style: AppTextStyles.bodyStrong.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          children: [
            TextSpan(
              text: label,
              style: AppTextStyles.bodyStrong.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditTextField extends StatelessWidget {
  const _EditTextField({
    required this.controller,
    required this.focusNode,
    required this.icon,
    required this.label,
    this.requiredMark = false,
    this.hasError = false,
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
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  static const _borderless = InputDecoration(
    filled: false,
    isDense: true,
    isCollapsed: true,
    contentPadding: EdgeInsets.zero,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final stacked = focusNode.hasFocus || controller.text.isNotEmpty;
        return _FieldShell(
          icon: icon,
          hasError: hasError,
          child: stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FieldLabel(text: label, requiredMark: requiredMark),
                    const SizedBox(height: 2),
                    TextField(
                      controller: controller,
                      focusNode: focusNode,
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
                      decoration: _borderless,
                    ),
                  ],
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
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
                      isCollapsed: false,
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

class _EditPickerField extends StatelessWidget {
  const _EditPickerField({
    required this.icon,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.requiredMark = false,
    this.hasError = false,
    this.showChevron = false,
  });

  final String icon;
  final String placeholder;
  final String? value;
  final bool requiredMark;
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
        child: _FieldShell(
          icon: icon,
          hasError: hasError,
          trailing: showChevron
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                )
              : null,
          child: filled
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FieldLabel(
                      text: placeholder,
                      requiredMark: requiredMark,
                    ),
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
        ),
      ),
    );
  }
}

class _FieldShell extends StatelessWidget {
  const _FieldShell({
    required this.child,
    this.icon,
    this.trailing,
    this.hasError = false,
  });

  final Widget child;
  final String? icon;
  final Widget? trailing;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
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
          if (icon != null) ...[
            AppSvgIcon(icon!, size: 20),
            const SizedBox(width: 10),
          ],
          Expanded(child: child),
          if (trailing != null) trailing!,
        ],
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
                height: 1.2,
                color: AppColors.required,
              ),
            ),
        ],
      ),
    );
  }
}
