import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_headers.dart';
import 'package:flutter/material.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  String _bookingTimeFrame = '24';
  String _nightPrice = '__';
  final List<String> _contacts = [
    '(UK) +44 12240 15428',
    '(US) +1 33728 37177',
    '(IN) +91 80375 65049',
  ];

  Future<void> _editField({
    required String title,
    required String current,
    required ValueChanged<String> onSave,
  }) async {
    final controller = TextEditingController(text: current == '__' ? '' : current);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: AppText(
            title,
            style: AppTextStyles.bodyStrong,
            size: 16,
            weight: FontWeight.w600,
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: title,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result == null) return;
    onSave(result.isEmpty ? '__' : result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          ProfilePageHeader(
            title: 'Profile',
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: AppContent(
              maxWidth: AppLayout.of(context).formMaxWidth,
              child: ListView(
                padding:
                    AppLayout.of(context).scrollPadding(top: 16, bottom: 32),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surface,
                                  border: Border.all(
                                    color: const Color(0xFFBFC1CC),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: AppText(
                                  'D',
                                  style: AppTextStyles.subtitle,
                                  size: 22,
                                  color: AppColors.primary,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Drivado',
                                      style: AppTextStyles.subtitle,
                                      size: 16,
                                      weight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    const SizedBox(height: 6),
                                    AppText(
                                      'Website  :  www.drivado.com',
                                      style: AppTextStyles.caption,
                                      size: 12,
                                      color: const Color(0xFF606060),
                                      weight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: AppIcons.summaryEmail,
                          label: 'Email ID',
                          value: 'abhishek@drivado.com',
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: AppIcons.moreAffiliate,
                          label: 'Language',
                          value: 'English',
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: AppIcons.bookingsCalendar,
                          label: 'Booking Time Frame',
                          value: _bookingTimeFrame,
                          onEdit: () => _editField(
                            title: 'Booking Time Frame',
                            current: _bookingTimeFrame,
                            onSave: (v) =>
                                setState(() => _bookingTimeFrame = v),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: AppIcons.homeCalendarTick,
                          label: 'Night Price',
                          value: _nightPrice,
                          onEdit: () => _editField(
                            title: 'Night Price',
                            current: _nightPrice,
                            onSave: (v) => setState(() => _nightPrice = v),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: AppIcons.bookingsPhone,
                          label: 'Contact',
                          value: _contacts.join('\n'),
                          onEdit: () => _editField(
                            title: 'Contact',
                            current: _contacts.join(', '),
                            onSave: (v) => setState(() {
                              final parts = v
                                  .split(RegExp(r'[,;\n]'))
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty)
                                  .toList();
                              if (parts.isNotEmpty) {
                                _contacts
                                  ..clear()
                                  ..addAll(parts);
                              }
                            }),
                          ),
                        ),
                      ],
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
  });

  final String icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 107,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6FA),
                  shape: BoxShape.circle,
                ),
                child: AppSvgIcon(
                  icon,
                  size: 10,
                  color: const Color(0xFF606060),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppText(
                  label,
                  style: AppTextStyles.caption,
                  size: 12,
                  color: const Color(0xFF606060),
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppText(
                  value,
                  style: AppTextStyles.bodyStrong,
                  size: 12,
                  color: AppColors.textPrimary,
                  weight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              if (onEdit != null)
                InkWell(
                  onTap: onEdit,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: AppSvgIcon(
                      AppIcons.summaryEdit,
                      size: 14,
                      color: Color(0xFF606060),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
