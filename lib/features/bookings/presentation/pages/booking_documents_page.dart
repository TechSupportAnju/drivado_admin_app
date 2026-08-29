import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:flutter/material.dart';

enum _DocType { invoice, voucher, driver }

class BookingDocumentsPage extends StatefulWidget {
  const BookingDocumentsPage({super.key, required this.booking});

  final ManagedBooking booking;

  @override
  State<BookingDocumentsPage> createState() => _BookingDocumentsPageState();
}

class _BookingDocumentsPageState extends State<BookingDocumentsPage> {
  _DocType? _selected;
  late final TextEditingController _email;
  bool _submitted = false;

  bool get _hasSelection => _selected != null;

  bool get _emailError {
    if (!_submitted) return false;
    final value = _email.text.trim();
    if (value.isEmpty) return true;
    return !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.booking.customerEmail);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _select(_DocType type) {
    setState(() {
      _selected = _selected == type ? null : type;
    });
  }

  void _send() {
    setState(() => _submitted = true);
    if (!_hasSelection || _emailError) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Documents sent')),
    );
  }

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
        title: Column(
          children: [
            AppText(
              'Documents',
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
        padding: const EdgeInsets.all(16),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Booking ID',
                    style: AppTextStyles.caption,
                    size: 12,
                    color: AppColors.textSecondary,
                    weight: FontWeight.w500,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    widget.booking.id,
                    style: AppTextStyles.subtitle,
                    size: 18,
                    color: AppColors.textPrimary,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _DocOption(
                          icon: AppIcons.documentsInvoice,
                          title: 'Invoice',
                          actionLabel: 'View Invoice',
                          selected: _selected == _DocType.invoice,
                          onSelect: () => _select(_DocType.invoice),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DocOption(
                          icon: AppIcons.documentsVoucher,
                          title: 'Voucher',
                          actionLabel: 'View Voucher',
                          selected: _selected == _DocType.voucher,
                          onSelect: () => _select(_DocType.voucher),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DriverTile(
                    selected: _selected == _DocType.driver,
                    onTap: () => _select(_DocType.driver),
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    'Send Email To:',
                    style: AppTextStyles.label,
                    size: 14,
                    color: AppColors.textPrimary,
                    weight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10),
                  AuthTextField(
                    hint: 'Enter your email ID',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    hasError: _emailError,
                    onChanged: (_) {
                      if (_submitted) setState(() {});
                    },
                  ),
                  AuthValidationMessage(
                    message:
                        _emailError ? 'Please enter a valid email ID' : null,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              side: const BorderSide(
                                color: AppColors.textSecondary,
                              ),
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
                          label: 'Send',
                          enabled: _hasSelection,
                          onPressed: _send,
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

class _DocOption extends StatelessWidget {
  const _DocOption({
    required this.icon,
    required this.title,
    required this.selected,
    required this.actionLabel,
    required this.onSelect,
  });

  final String icon;
  final String title;
  final bool selected;
  final String actionLabel;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onSelect,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0x7F606060),
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSvgIcon(icon, size: 18),
                    _SelectMark(selected: selected),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AppText(
                  title,
                  style: AppTextStyles.label,
                  size: 16,
                  color: AppColors.textPrimary,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ColoredBox(
                color: const Color(0xFFF5F6FA),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      actionLabel,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        height: 1,
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

class _DriverTile extends StatelessWidget {
  const _DriverTile({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x7F606060), width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const AppSvgIcon(AppIcons.documentsDriver, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    'Driver Details',
                    style: AppTextStyles.label,
                    size: 16,
                    color: AppColors.textPrimary,
                    weight: FontWeight.w600,
                  ),
                ),
                _SelectMark(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectMark extends StatelessWidget {
  const _SelectMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.textPrimary : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.textPrimary : AppColors.textSecondary,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: AppColors.textOnDark)
          : null,
    );
  }
}
