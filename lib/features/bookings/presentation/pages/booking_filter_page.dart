import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingFilterResult {
  const BookingFilterResult({
    this.query = '',
    this.statuses = const {},
  });

  final String query;
  final Set<String> statuses;
}

class BookingFilterPage extends StatefulWidget {
  const BookingFilterPage({super.key});

  @override
  State<BookingFilterPage> createState() => _BookingFilterPageState();
}

class _BookingFilterPageState extends State<BookingFilterPage> {
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static const _statuses = [
    'Confirmed',
    'Completed',
    'Cancelled',
    'No show',
    'On request',
    'POB',
  ];

  var _useBookingDate = true;
  DateTime? _from;
  DateTime? _to;
  final _bookingId = TextEditingController();
  final _company = TextEditingController();
  final _username = TextEditingController();
  final _passengerName = TextEditingController();
  final _passengerNumber = TextEditingController();
  final _selectedStatuses = <String>{};

  @override
  void dispose() {
    _bookingId.dispose();
    _company.dispose();
    _username.dispose();
    _passengerName.dispose();
    _passengerNumber.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _useBookingDate = true;
      _from = null;
      _to = null;
      _bookingId.clear();
      _company.clear();
      _username.clear();
      _passengerName.clear();
      _passengerNumber.clear();
      _selectedStatuses.clear();
    });
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _from : _to) ?? now,
      firstDate: DateTime(2020),
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
    setState(() {
      if (isFrom) {
        _from = selected;
      } else {
        _to = selected;
      }
    });
  }

  void _search() {
    final query = [
      _bookingId.text.trim(),
      _passengerName.text.trim(),
      _company.text.trim(),
      _username.text.trim(),
      _passengerNumber.text.trim(),
    ].firstWhere((v) => v.isNotEmpty, orElse: () => '');
    Navigator.of(context).pop(
      BookingFilterResult(
        query: query,
        statuses: Set<String>.from(_selectedStatuses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primaryDark,
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.paddingOf(context).top + 8,
              16,
              16,
            ),
            child: Row(
              children: [
                Material(
                  color: const Color(0xFF352828),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.of(context).pop(),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AppText(
                    'Property Filter',
                    align: TextAlign.center,
                    style: AppTextStyles.subtitle,
                    size: 20,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Material(
                  color: const Color(0xFF352828),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _reset,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AppContent(
              maxWidth: AppLayout.of(context).formMaxWidth,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                children: [
                  AppText(
                    'Date range',
                    style: AppTextStyles.bodyStrong,
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 16),
                  _DateModeToggle(
                    useBookingDate: _useBookingDate,
                    onChanged: (v) => setState(() => _useBookingDate = v),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DateBox(
                          label: 'Date (From)',
                          value: _from == null
                              ? null
                              : _dateFormat.format(_from!),
                          onTap: () => _pickDate(isFrom: true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _DateBox(
                          label: 'Date (To)',
                          value:
                              _to == null ? null : _dateFormat.format(_to!),
                          onTap: () => _pickDate(isFrom: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppText(
                    'Search by:',
                    style: AppTextStyles.bodyStrong,
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _bookingId,
                    hint: 'Enter your booking ID',
                    requiredMark: false,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _company,
                    hint: 'Enter your company name',
                    requiredMark: false,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _username,
                    hint: 'Enter your username',
                    requiredMark: false,
                  ),
                  const SizedBox(height: 24),
                  AppText(
                    'Booking status',
                    style: AppTextStyles.bodyStrong,
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final status in _statuses)
                        _StatusCheck(
                          label: status,
                          checked: _selectedStatuses.contains(status),
                          onChanged: (checked) {
                            setState(() {
                              if (checked) {
                                _selectedStatuses.add(status);
                              } else {
                                _selectedStatuses.remove(status);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppText(
                    'Passenger details',
                    style: AppTextStyles.bodyStrong,
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passengerName,
                    hint: 'Enter passenger name',
                    requiredMark: false,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _passengerNumber,
                    hint: 'Enter passenger number',
                    requiredMark: false,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Search',
                    onPressed: _search,
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

class _DateModeToggle extends StatelessWidget {
  const _DateModeToggle({
    required this.useBookingDate,
    required this.onChanged,
  });

  final bool useBookingDate;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26606060),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _togglePill(
              label: 'Booking Date',
              selected: useBookingDate,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _togglePill(
              label: 'Travel Date',
              selected: !useBookingDate,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _togglePill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: AppText(
            label,
            style: AppTextStyles.bodyStrong,
            size: 14,
            weight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x80606060), width: 0.5),
          ),
          child: Row(
            children: [
              const AppSvgIcon(
                AppIcons.createCalendar,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              AppText(
                value ?? label,
                style: AppTextStyles.body,
                size: 12,
                color: value == null
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCheck extends StatelessWidget {
  const _StatusCheck({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: checked,
              onChanged: (v) => onChanged(v ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: Color(0x80606060)),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AppText(
            label,
            style: AppTextStyles.bodyStrong,
            size: 14,
            weight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
