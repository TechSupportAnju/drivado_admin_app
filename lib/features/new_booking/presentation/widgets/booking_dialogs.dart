import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/new_booking/domain/repositories/booking_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showRequiredFieldsToast(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black26,
    builder: (dialogContext) => const _RequiredFieldsToast(),
  );
}

class _RequiredFieldsToast extends StatefulWidget {
  const _RequiredFieldsToast();

  @override
  State<_RequiredFieldsToast> createState() => _RequiredFieldsToastState();
}

class _RequiredFieldsToastState extends State<_RequiredFieldsToast> {
  var _progress = 1.0;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 40), _tick);
  }

  void _tick() {
    if (!mounted) return;
    if (_progress <= 0.02) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _progress -= 0.02);
    Future<void>.delayed(const Duration(milliseconds: 40), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          decoration: BoxDecoration(
            color: const Color(0xFF190C0C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const AppSvgIcon(AppIcons.createToast, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'Action Required',
                          style: AppTextStyles.bodyStrong,
                          size: 17,
                          color: Colors.white,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          'Incomplete fields. Please fill in all required information now',
                          style: AppTextStyles.body,
                          size: 13,
                          color: const Color(0xFFC8C5C5),
                          height: 1.4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 4,
                  backgroundColor: Colors.transparent,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showAdvanceBookingDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: AppText(
          'Invalid booking time',
          style: AppTextStyles.subtitle,
          size: 16,
          weight: FontWeight.w600,
        ),
        content: AppText(
          'Please select a pickup date and time at least 24 hours from now.',
          style: AppTextStyles.body,
          size: 14,
          height: 1.4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      );
    },
  );
}

Future<String?> showDurationPickerDialog({
  required BuildContext context,
  String? current,
}) {
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'duration',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (dialogContext, _, __) {
      final durations = context.read<BookingCatalogRepository>().durations;
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: Colors.transparent,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                child: Row(
                  children: [
                    AppText(
                      'Select Duration',
                      style: AppTextStyles.bodyStrong,
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_up_sharp, color: Color(0xFFF7FAFF)),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF2F2F2)),
              Expanded(
                child: ListView.builder(
                  itemCount: durations.length,
                  itemBuilder: (context, index) {
                    final text = durations[index];
                    return InkWell(
                      onTap: () => Navigator.pop(context, text),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: AppText(
                          text,
                          style: AppTextStyles.body,
                          size: 14,
                          color: text == current
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          weight: text == current
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final scale = Curves.easeInOut.transform(animation.value);
      return Transform.scale(scale: scale, child: child);
    },
  );
}

Future<String?> showCurrencyPickerDialog({
  required BuildContext context,
  required List<(String, String)> currencies,
  String? current,
}) {
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'currency',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, _, __) {
      return _CurrencyDialog(currencies: currencies, current: current);
    },
    transitionBuilder: (context, animation, _, child) {
      final scale = Curves.easeInOut.transform(animation.value);
      return Transform.scale(scale: scale, child: child);
    },
  );
}

class _CurrencyDialog extends StatefulWidget {
  const _CurrencyDialog({required this.currencies, this.current});

  final List<(String, String)> currencies;
  final String? current;

  @override
  State<_CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends State<_CurrencyDialog> {
  final _search = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.currencies.where((c) {
      final hay = '${c.$1} ${c.$2}'.toLowerCase();
      return hay.contains(_query);
    }).toList();
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 310,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  const AppSvgIcon(AppIcons.createSearch, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppSearchField(
                      controller: _search,
                      hint: 'Search',
                      onChanged: (value) {
                        setState(() => _query = value.trim().toLowerCase());
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  final selected = item.$1 == widget.current;
                  return ListTile(
                    title: AppText(
                      '${item.$1}  ·  ${item.$2}',
                      style: AppTextStyles.body,
                      size: 14,
                      color: selected ? AppColors.primary : AppColors.textPrimary,
                      weight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onTap: () => Navigator.pop(context, item.$1),
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
