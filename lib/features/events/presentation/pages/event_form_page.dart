import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/events/domain/entities/event.dart';
import 'package:drivado_admin_app/features/events/domain/repositories/events_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key, this.event});

  final EventItem? event;

  bool get isEditing => event != null;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  late final TextEditingController _name;
  late final TextEditingController _markup;

  String? _region;
  String? _flatRegion;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _allRegions = false;
  bool _allFlatRegions = false;
  bool _blackout = false;
  bool _submitted = false;

  static final _dateFormat = DateFormat('dd/MM/yyyy');

  List<String> get _flatRegionOptions {
    if (_region == null) return const [];
    return context.read<EventsRepository>().flatRegionsFor(_region!);
  }

  bool get _regionError =>
      _submitted && !_allRegions && (_region == null || _region!.isEmpty);

  bool get _flatRegionError =>
      _submitted &&
      !_allRegions &&
      !_allFlatRegions &&
      (_flatRegion == null || _flatRegion!.isEmpty);

  bool get _nameError => _submitted && _name.text.trim().isEmpty;
  bool get _markupError => _submitted && _markup.text.trim().isEmpty;
  bool get _startError => _submitted && _startDate == null;
  bool get _endError => _submitted && _endDate == null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _name = TextEditingController(text: e?.name ?? '');
    _markup = TextEditingController(text: e?.markup ?? '');
    _region = e?.region;
    _flatRegion = e?.flatRegion;
    _startDate = e?.startDate;
    _endDate = e?.endDate;
    _allRegions = e?.allRegions ?? false;
    _allFlatRegions = e?.allFlatRegions ?? false;
    _blackout = e?.blackout ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _markup.dispose();
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

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final current = isStart ? _startDate : _endDate;
    final first = isStart
        ? DateTime(now.year - 5)
        : (_startDate ?? DateTime(now.year - 5));
    var initial = current ?? (isStart ? now : (_startDate ?? now));
    if (initial.isBefore(first)) initial = first;

    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: now.add(const Duration(days: 365 * 10)),
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
        if (_endDate != null && _endDate!.isBefore(selected)) {
          _endDate = selected;
        }
      } else {
        _endDate = selected;
      }
    });
  }

  void _submit() {
    setState(() => _submitted = true);
    final valid = !_regionError &&
        !_flatRegionError &&
        !_nameError &&
        !_markupError &&
        !_startError &&
        !_endError;
    if (!valid) return;

    final existing = widget.event;
    context.read<EventsRepository>().upsert(
      EventItem(
        id: existing?.id ?? 'e_${DateTime.now().millisecondsSinceEpoch}',
        name: _name.text.trim(),
        region: _allRegions ? 'All Regions' : (_region ?? ''),
        flatRegion: _allRegions || _allFlatRegions
            ? 'All Flat Regions'
            : (_flatRegion ?? ''),
        startDate: _startDate!,
        endDate: _endDate!,
        markup: _markup.text.trim(),
        allRegions: _allRegions,
        allFlatRegions: _allFlatRegions,
        blackout: _blackout,
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.isEditing;

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
                    editing ? 'Edit Event' : 'Add Event',
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
                          if (editing) ...[
                            _ReadOnlyLocation(
                              label: 'Region/City',
                              value: widget.event!.locationLabel,
                            ),
                            const SizedBox(height: 12),
                          ] else ...[
                            _DropdownField(
                              hint: 'Select Region / City name',
                              value: _allRegions ? 'All Regions' : _region,
                              hasError: _regionError,
                              enabled: !_allRegions,
                              requiredMark: false,
                              onTap: () async {
                                final selected = await _pickOption(
                                  title: 'Select Region / City name',
                                  options:
                                      context.read<EventsRepository>().regions,
                                  current: _region,
                                );
                                if (selected == null) return;
                                setState(() {
                                  _region = selected;
                                  _flatRegion = null;
                                  _allFlatRegions = false;
                                });
                              },
                            ),
                            AuthValidationMessage(
                              message: _regionError
                                  ? 'Select Region is required'
                                  : null,
                            ),
                            const SizedBox(height: 6),
                            _CheckOption(
                              label: 'All Regions',
                              checked: _allRegions,
                              onChanged: (value) {
                                setState(() {
                                  _allRegions = value;
                                  if (value) {
                                    _region = null;
                                    _flatRegion = null;
                                    _allFlatRegions = false;
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _DropdownField(
                              hint: 'Select Flat Region / City name',
                              value: _allRegions
                                  ? 'All Flat Regions'
                                  : (_allFlatRegions
                                      ? 'All Flat Regions'
                                      : _flatRegion),
                              hasError: _flatRegionError,
                              enabled: !_allRegions && !_allFlatRegions,
                              requiredMark: false,
                              onTap: () async {
                                if (_region == null) return;
                                final selected = await _pickOption(
                                  title: 'Select Flat Region / City name',
                                  options: _flatRegionOptions,
                                  current: _flatRegion,
                                );
                                if (selected == null) return;
                                setState(() => _flatRegion = selected);
                              },
                            ),
                            AuthValidationMessage(
                              message: _flatRegionError
                                  ? 'Select Flat Region is required'
                                  : null,
                            ),
                            const SizedBox(height: 6),
                            _CheckOption(
                              label: 'All Flat Regions',
                              checked: _allFlatRegions || _allRegions,
                              enabled: !_allRegions,
                              onChanged: (value) {
                                setState(() {
                                  _allFlatRegions = value;
                                  if (value) _flatRegion = null;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                          AuthTextField(
                            hint: 'Event Name',
                            controller: _name,
                            hasError: _nameError,
                            prefix: const FieldPrefixIcon(
                              AppIcons.moreEvent,
                              size: 16,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          AuthValidationMessage(
                            message:
                                _nameError ? 'Event Name is required' : null,
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            hint: 'Markup',
                            controller: _markup,
                            hasError: _markupError,
                            prefix: const FieldPrefixIcon(
                              AppIcons.assignPrice,
                              size: 16,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          AuthValidationMessage(
                            message:
                                _markupError ? 'Markup is required' : null,
                          ),
                          const SizedBox(height: 12),
                          _DateField(
                            hint: editing ? 'Start Date' : 'Enter Start Date',
                            value: _startDate == null
                                ? null
                                : _dateFormat.format(_startDate!),
                            hasError: _startError,
                            onTap: () => _pickDate(isStart: true),
                          ),
                          AuthValidationMessage(
                            message:
                                _startError ? 'Start Date is required' : null,
                          ),
                          const SizedBox(height: 12),
                          _DateField(
                            hint: editing ? 'End Date' : 'Enter End Date',
                            value: _endDate == null
                                ? null
                                : _dateFormat.format(_endDate!),
                            hasError: _endError,
                            onTap: () => _pickDate(isStart: false),
                          ),
                          AuthValidationMessage(
                            message: _endError ? 'End Date is required' : null,
                          ),
                          if (editing) ...[
                            const SizedBox(height: 12),
                            _BlackoutToggle(
                              value: _blackout,
                              onChanged: (v) => setState(() => _blackout = v),
                            ),
                          ],
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
                              label: editing ? 'Update' : 'Create Event',
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

class _ReadOnlyLocation extends StatelessWidget {
  const _ReadOnlyLocation({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppSvgIcon(
                AppIcons.bookingsDestination,
                size: 16,
                color: Color(0xFF606060),
              ),
              const SizedBox(width: 4),
              AppText(
                label,
                style: AppTextStyles.caption,
                size: 12,
                color: const Color(0xFF606060),
                weight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 2),
          AppText(
            value,
            style: AppTextStyles.bodyStrong,
            size: 14,
            color: AppColors.textPrimary,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _BlackoutToggle extends StatelessWidget {
  const _BlackoutToggle({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          AppText(
            'Blackout',
            style: AppTextStyles.bodyStrong,
            size: 16,
            color: AppColors.textPrimary,
            weight: FontWeight.w600,
          ),
          const Spacer(),
          Switch.adaptive(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF00E041),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _CheckOption extends StatelessWidget {
  const _CheckOption({
    required this.label,
    required this.checked,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onChanged(!checked) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: checked ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: checked
                      ? AppColors.primary
                      : const Color(0xFF606060).withValues(alpha: 0.5),
                  width: 1.2,
                ),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 11, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 6),
            AppText(
              label,
              style: AppTextStyles.body,
              size: 12,
              color: enabled
                  ? const Color(0xFF606060)
                  : AppColors.textSecondary,
              weight: FontWeight.w500,
              letterSpacing: -0.12,
            ),
          ],
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
    this.enabled = true,
    this.requiredMark = true,
  });

  final String hint;
  final String? value;
  final bool hasError;
  final bool enabled;
  final bool requiredMark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: enabled ? onTap : null,
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
                Expanded(
                  child: filled
                      ? AppText(
                          value!,
                          style: AppTextStyles.bodyStrong,
                          size: 14,
                          color: AppColors.textPrimary,
                          weight: FontWeight.w500,
                        )
                      : Text.rich(
                          TextSpan(
                            text: hint,
                            style: AppTextStyles.fieldHint.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
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
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.stroke,
                  margin: const EdgeInsets.only(right: 12),
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
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: hint,
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
                          const SizedBox(height: 2),
                          AppText(
                            value!,
                            style: AppTextStyles.bodyStrong,
                            size: 14,
                            color: AppColors.textPrimary,
                            weight: FontWeight.w600,
                          ),
                        ],
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
