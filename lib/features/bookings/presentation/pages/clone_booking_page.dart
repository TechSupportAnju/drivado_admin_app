import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CloneBookingPage extends StatefulWidget {
  const CloneBookingPage({super.key, required this.booking});

  final ManagedBooking booking;

  @override
  State<CloneBookingPage> createState() => _CloneBookingPageState();
}

class _CloneBookingPageState extends State<CloneBookingPage> {
  bool _multi = false;
  bool _submitted = false;

  DateTime? _singleDate;
  TimeOfDay? _singleTime;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _multiTime;

  TimeOfDay? get _time => _multi ? _multiTime : _singleTime;

  bool get _singleDateError => !_multi && _submitted && _singleDate == null;
  bool get _startDateError => _multi && _submitted && _startDate == null;
  bool get _endDateError => _multi && _submitted && _endDate == null;
  bool get _timeError => _submitted && _time == null;

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  Future<DateTime?> _showDatePicker({
    required DateTime? current,
    DateTime? firstDate,
  }) {
    final now = DateTime.now();
    final first = firstDate ?? now;
    var initial = current ?? first;
    if (initial.isBefore(first)) initial = first;
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: now.add(const Duration(days: 365 * 2)),
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
  }

  Future<void> _pickSingleDate() async {
    final selected = await _showDatePicker(current: _singleDate);
    if (selected == null) return;
    setState(() => _singleDate = selected);
  }

  Future<void> _pickStartDate() async {
    final selected = await _showDatePicker(current: _startDate);
    if (selected == null) return;
    setState(() {
      _startDate = selected;
      if (_endDate != null && _endDate!.isBefore(selected)) {
        _endDate = selected;
      }
    });
  }

  Future<void> _pickEndDate() async {
    final selected = await _showDatePicker(
      current: _endDate ?? _startDate,
      firstDate: _startDate ?? DateTime.now(),
    );
    if (selected == null) return;
    setState(() => _endDate = selected);
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
    setState(() {
      if (_multi) {
        _multiTime = selected;
      } else {
        _singleTime = selected;
      }
    });
  }

  void _publish() {
    setState(() => _submitted = true);
    final valid = _multi
        ? _startDate != null && _endDate != null && _multiTime != null
        : _singleDate != null && _singleTime != null;
    if (!valid) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final timeLabel = _time == null ? null : _time!.format(context);

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
        title: Column(
          children: [
            AppText(
              'Clone',
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
          _CloneTabs(
            multi: _multi,
            onChanged: (multi) => setState(() {
              _multi = multi;
              _submitted = false;
            }),
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                children: [
                  if (_multi) ...[
                    _ClonePickerField(
                      icon: AppIcons.cloneCalendar,
                      placeholder: 'Start Travel Date',
                      requiredMark: true,
                      value: _formatDate(_startDate),
                      hasError: _startDateError,
                      onTap: _pickStartDate,
                    ),
                    AuthValidationMessage(
                      message: _startDateError
                          ? 'Please enter start travel date'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _ClonePickerField(
                      icon: AppIcons.cloneCalendar,
                      placeholder: 'End Travel Date',
                      requiredMark: true,
                      value: _formatDate(_endDate),
                      hasError: _endDateError,
                      onTap: _pickEndDate,
                    ),
                    AuthValidationMessage(
                      message: _endDateError
                          ? 'Please enter end travel date'
                          : null,
                    ),
                  ] else ...[
                    _ClonePickerField(
                      icon: AppIcons.cloneCalendar,
                      placeholder: 'Enter travel date',
                      requiredMark: true,
                      value: _formatDate(_singleDate),
                      hasError: _singleDateError,
                      onTap: _pickSingleDate,
                    ),
                    AuthValidationMessage(
                      message:
                          _singleDateError ? 'Please enter travel date' : null,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _ClonePickerField(
                    icon: AppIcons.cloneClock,
                    placeholder: 'Enter travel time',
                    requiredMark: true,
                    value: timeLabel,
                    hasError: _timeError,
                    onTap: _pickTime,
                  ),
                  AuthValidationMessage(
                    message: _timeError ? 'Please enter travel time' : null,
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
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.stroke),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: AppTextStyles.button.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: const Text('Discard'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Publish',
                          onPressed: _publish,
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

class _CloneTabs extends StatelessWidget {
  const _CloneTabs({required this.multi, required this.onChanged});

  final bool multi;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E9EE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _TabChip(
            label: 'Single clone',
            selected: !multi,
            onTap: () => onChanged(false),
          ),
          _TabChip(
            label: 'Multi clone',
            selected: multi,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: AppText(
            label,
            style: AppTextStyles.bodyStrong,
            size: 14,
            weight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ClonePickerField extends StatelessWidget {
  const _ClonePickerField({
    required this.icon,
    required this.placeholder,
    required this.onTap,
    required this.hasError,
    this.value,
    this.requiredMark = false,
  });

  final String icon;
  final String placeholder;
  final String? value;
  final bool requiredMark;
  final bool hasError;
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
          height: 56,
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
              AppSvgIcon(icon, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: filled
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _RequiredHint(
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
                    : _RequiredHint(
                        text: placeholder,
                        requiredMark: requiredMark,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredHint extends StatelessWidget {
  const _RequiredHint({required this.text, this.requiredMark = false});

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
