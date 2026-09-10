import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/pages/select_location_page.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/pages/vehicle_results_sheet.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/widgets/booking_dialogs.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/widgets/new_booking_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _RideType { oneway, hourly }

class NewBookingPage extends StatefulWidget {
  const NewBookingPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<NewBookingPage> createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static const _currencies = [
    ('USD', 'United States Dollar'),
    ('INR', 'Indian Rupees'),
    ('EUR', 'Euro'),
    ('GBP', 'Pound Sterling'),
    ('AED', 'United Arab Emirates Dirham'),
    ('AUD', 'Australian Dollar'),
    ('SGD', 'Singapore Dollar'),
  ];

  _RideType _type = _RideType.oneway;
  String? _pickup;
  String? _dropoff;
  String? _duration;
  String? _currency;
  DateTime? _date;
  TimeOfDay? _time;
  int _passengers = 1;
  bool _submitted = false;
  bool _searching = false;
  BookingShortcut _shortcut = BookingShortcut.newBooking;

  bool get _isOneway => _type == _RideType.oneway;
  bool get _pickupError => _submitted && (_pickup == null || _pickup!.isEmpty);
  bool get _dropoffError =>
      _submitted && _isOneway && (_dropoff == null || _dropoff!.isEmpty);
  bool get _durationError =>
      _submitted && !_isOneway && (_duration == null || _duration!.isEmpty);
  bool get _dateError => _submitted && _date == null;
  bool get _timeError => _submitted && _time == null;
  bool get _currencyError =>
      _submitted && (_currency == null || _currency!.isEmpty);

  String? get _dateLabel =>
      _date == null ? null : _dateFormat.format(_date!);
  String? get _timeLabel {
    if (_time == null) return null;
    return '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickPickup() async {
    final selected = await Navigator.of(context).push<String>(
      AppPageRoute(
        page: SelectLocationPage(
          title: 'Pickup location',
          current: _pickup,
        ),
      ),
    );
    if (!mounted || selected == null) return;
    setState(() {
      _pickup = selected;
      if (!_isOneway) _duration = null;
    });
  }

  Future<void> _pickDropoff() async {
    final selected = await Navigator.of(context).push<String>(
      AppPageRoute(
        page: SelectLocationPage(
          title: 'Drop off location',
          current: _dropoff,
        ),
      ),
    );
    if (!mounted || selected == null) return;
    setState(() => _dropoff = selected);
  }

  Future<void> _pickDuration() async {
    if (_pickup == null) {
      setState(() => _submitted = true);
      return;
    }
    final selected = await showDurationPickerDialog(
      context: context,
      current: _duration,
    );
    if (!mounted || selected == null) return;
    setState(() => _duration = selected);
  }

  Future<void> _pickCurrency() async {
    final selected = await showCurrencyPickerDialog(
      context: context,
      currencies: _currencies,
      current: _currency,
    );
    if (!mounted || selected == null) return;
    setState(() => _currency = selected);
  }

  bool _isAtLeast24Hours(DateTime date, TimeOfDay time) {
    final pickup = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return pickup.difference(DateTime.now()).inHours >= 24;
  }

  Future<void> _show24HourDialog() => showAdvanceBookingDialog(context);

  Future<void> _showRequiredFieldDialog() => showRequiredFieldsToast(context);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: DateTime(2040),
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
    if (_time != null && !_isAtLeast24Hours(selected, _time!)) {
      await _show24HourDialog();
      return;
    }
    setState(() => _date = selected);
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
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
    if (_date != null && !_isAtLeast24Hours(_date!, selected)) {
      await _show24HourDialog();
      return;
    }
    setState(() => _time = selected);
  }

  Future<void> _searchVehicles() async {
    setState(() => _submitted = true);
    final valid = !_pickupError &&
        !_dropoffError &&
        !_durationError &&
        !_dateError &&
        !_timeError &&
        !_currencyError;
    if (!valid) {
      await _showRequiredFieldDialog();
      return;
    }
    if (!_isAtLeast24Hours(_date!, _time!)) {
      await _show24HourDialog();
      return;
    }
    setState(() => _searching = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _searching = false);
    final draft = BookingDraft(
      isOneway: _isOneway,
      pickup: _pickup!,
      dropoff: _isOneway ? _dropoff : null,
      duration: _isOneway ? null : _duration,
      dateLabel: _dateLabel!,
      timeLabel: _timeLabel!,
      passengers: _passengers,
      currency: _currency!,
      distanceKm: _isOneway ? '32 km' : '0 km',
      routeDuration: _isOneway ? '45 mins' : (_duration ?? ''),
    );
    await showVehicleResultsSheet(context: context, draft: draft);
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        NewBookingHeader(
          shortcut: _shortcut,
          onShortcutChanged: (value) => setState(() => _shortcut = value),
          onBack: widget.embedded ? null : () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: AppRoundedSheet(
            color: AppColors.surface,
            topRadius: 24,
            child: switch (_shortcut) {
              BookingShortcut.newBooking => Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: AppLayout.of(context).scrollPadding(
                          top: 16,
                          bottom: 24,
                        ),
                        children: [
                          _RideTypeSelector(
                          type: _type,
                          onChanged: (type) => setState(() {
                            _type = type;
                            _submitted = false;
                            if (type == _RideType.hourly) {
                              _dropoff = null;
                            } else {
                              _duration = null;
                            }
                          }),
                        ),
                        const SizedBox(height: 24),
                        _PickerField(
                          icon: AppIcons.createLocation,
                          label: 'From',
                          hint: 'Enter your pickup location',
                          value: _pickup,
                          hasError: _pickupError,
                          onTap: _pickPickup,
                        ),
                        AuthValidationMessage(
                          message: _pickupError
                              ? 'Pickup location is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        if (_isOneway) ...[
                          _PickerField(
                            icon: AppIcons.createLocation,
                            label: 'To',
                            hint: 'Enter your drop off location',
                            value: _dropoff,
                            hasError: _dropoffError,
                            onTap: _pickDropoff,
                          ),
                          AuthValidationMessage(
                            message: _dropoffError
                                ? 'Drop off location is required'
                                : null,
                          ),
                        ] else ...[
                          _PickerField(
                            icon: AppIcons.createDuration,
                            label: 'Duration',
                            hint: 'Select Duration',
                            value: _duration,
                            hasError: _durationError,
                            showChevron: true,
                            onTap: _pickDuration,
                          ),
                          AuthValidationMessage(
                            message: _submitted && !_isOneway && _pickup == null
                                ? 'Please enter pickup location first'
                                : (_durationError
                                    ? 'Duration is required'
                                    : null),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _PickerField(
                                icon: AppIcons.createCalendar,
                                label: 'Date',
                                hint: 'DD/MM/YYYY',
                                value: _dateLabel,
                                hasError: _dateError,
                                showChevron: true,
                                onTap: _pickDate,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PickerField(
                                icon: AppIcons.createClock,
                                label: 'Time',
                                hint: 'Select Time',
                                value: _timeLabel,
                                hasError: _timeError,
                                showChevron: true,
                                onTap: _pickTime,
                              ),
                            ),
                          ],
                        ),
                        AuthValidationMessage(
                          message: _dateError ? 'Date is required' : null,
                        ),
                        AuthValidationMessage(
                          message: _timeError ? 'Time is required' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _PassengerStepper(
                                count: _passengers,
                                onChanged: (value) =>
                                    setState(() => _passengers = value),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PickerField(
                                icon: AppIcons.createCurrency,
                                label: 'Currency',
                                hint: 'Currency',
                                value: _currency,
                                hasError: _currencyError,
                                showChevron: true,
                                onTap: _pickCurrency,
                              ),
                            ),
                          ],
                        ),
                        AuthValidationMessage(
                          message:
                              _currencyError ? 'Currency is required' : null,
                        ),
                      ],
                    ),
                  ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          8,
                          16,
                          widget.embedded ? 88 : 16,
                        ),
                        child: PrimaryButton(
                          label: _searching ? 'Checking route...' : 'Search Vehicle',
                          enabled: !_searching,
                          onPressed: _searchVehicles,
                        ),
                      ),
                    ),
                  ],
                ),
              BookingShortcut.flatRate => const _ShortcutPlaceholder(
                  title: 'Flat Rate',
                ),
              BookingShortcut.offlineBooking => const _ShortcutPlaceholder(
                  title: 'Offline Booking',
                ),
            },
          ),
        ),
      ],
    );

    if (widget.embedded) {
      return ColoredBox(
        color: AppColors.primaryDark,
        child: AppContent(child: body),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: AppContent(child: body),
    );
  }
}

class _OptionSheet extends StatefulWidget {
  const _OptionSheet({
    required this.title,
    required this.options,
    this.current,
  });

  final String title;
  final List<String> options;
  final String? current;

  @override
  State<_OptionSheet> createState() => _OptionSheetState();
}

class _OptionSheetState extends State<_OptionSheet> {
  late final TextEditingController _search;
  var _query = '';

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _isSelected(String option) {
    final current = widget.current;
    if (current == null || current.isEmpty) return false;
    return option == current || option.startsWith('$current  ·  ');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.options
        .where((item) => item.toLowerCase().contains(_query))
        .toList();
    return SafeArea(
      child: SizedBox(
        height: AppLayout.of(context).sheetHeight(0.62),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: AppText(
                widget.title,
                style: AppTextStyles.bodyStrong,
                size: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSearchField(
                controller: _search,
                hint: 'Search',
                onChanged: (value) {
                  setState(() => _query = value.trim().toLowerCase());
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final option = filtered[index];
                  final selected = _isSelected(option);
                  return ListTile(
                    title: AppText(
                      option,
                      style: AppTextStyles.body,
                      size: 15,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      weight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onTap: () => Navigator.of(context).pop(option),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutPlaceholder extends StatelessWidget {
  const _ShortcutPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: AppText(
          '$title will be available here soon.',
          align: TextAlign.center,
          style: AppTextStyles.bodyStrong,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _RideTypeSelector extends StatelessWidget {
  const _RideTypeSelector({required this.type, required this.onChanged});

  final _RideType type;
  final ValueChanged<_RideType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          _RideTypeTab(
            selected: type == _RideType.oneway,
            title: 'Oneway',
            subtitle: 'Airport · City · Intercity',
            icon: AppIcons.createOneway,
            onTap: () => onChanged(_RideType.oneway),
          ),
          const SizedBox(width: 12),
          _RideTypeTab(
            selected: type == _RideType.hourly,
            title: 'Hourly',
            subtitle: 'Chauffeur by the hour',
            icon: type == _RideType.hourly
                ? AppIcons.createHourlyActive
                : AppIcons.createHourly,
            onTap: () => onChanged(_RideType.hourly),
          ),
        ],
      ),
    );
  }
}

class _RideTypeTab extends StatelessWidget {
  const _RideTypeTab({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(60),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x1A606060),
                      blurRadius: 2,
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              AppSvgIcon(icon, size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      title,
                      style: AppTextStyles.bodyStrong,
                      size: 14,
                      weight: FontWeight.w600,
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      subtitle,
                      style: AppTextStyles.caption,
                      size: 10,
                      weight: FontWeight.w500,
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.onTap,
    required this.hasError,
    this.value,
    this.showChevron = false,
    this.showLabelWhenFilled = false,
  });

  final String icon;
  final String label;
  final String hint;
  final String? value;
  final bool hasError;
  final bool showChevron;
  final bool showLabelWhenFilled;
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
          padding: const EdgeInsets.all(8),
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
              AppSvgIcon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: filled
                    ? (showLabelWhenFilled
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: label,
                                  style: AppTextStyles.fieldHint.copyWith(
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '*',
                                      style: AppTextStyles.fieldHint.copyWith(
                                        fontSize: 12,
                                        color: AppColors.required,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppText(
                                value!,
                                style: AppTextStyles.bodyStrong,
                                size: 14,
                                weight: FontWeight.w500,
                                maxLines: 1,
                              ),
                            ],
                          )
                        : AppText(
                            value!,
                            style: AppTextStyles.bodyStrong,
                            size: 14,
                            weight: FontWeight.w500,
                            maxLines: 1,
                          ))
                    : Text.rich(
                        TextSpan(
                          text: hint,
                          style: AppTextStyles.fieldHint.copyWith(
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: '*',
                              style: AppTextStyles.fieldHint.copyWith(
                                fontSize: 14,
                                color: AppColors.required,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              if (showChevron)
                const AppSvgIcon(
                  AppIcons.createExpand,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassengerStepper extends StatelessWidget {
  const _PassengerStepper({required this.count, required this.onChanged});

  final int count;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          const AppSvgIcon(
            AppIcons.createPax,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Passenger',
                  style: AppTextStyles.caption,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _StepButton(
                      icon: Icons.remove,
                      enabled: count > 1,
                      onTap: () => onChanged(count - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppText(
                        '$count',
                        style: AppTextStyles.bodyStrong,
                        size: 12,
                        weight: FontWeight.w600,
                      ),
                    ),
                    _StepButton(
                      icon: Icons.add,
                      enabled: count < 5,
                      onTap: () => onChanged(count + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
