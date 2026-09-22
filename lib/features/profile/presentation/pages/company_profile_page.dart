import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_edit_dialogs.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_headers.dart';
import 'package:flutter/material.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  String _bookingTimeFrame = '24';
  String _nightPrice = '--';
  List<ProfileEmergencyContact> _contacts = const [
    ProfileEmergencyContact(
      region: 'UK',
      dialCode: '+44',
      number: '12240 15428',
    ),
    ProfileEmergencyContact(
      region: 'US',
      dialCode: '+1',
      number: '33728 37177',
    ),
    ProfileEmergencyContact(
      region: 'IN',
      dialCode: '+91',
      number: '80375 65049',
    ),
  ];

  Future<void> _editBookingTime() async {
    final result = await showEditBookingTimeDialog(
      context,
      current: _bookingTimeFrame,
    );
    if (!mounted || result == null || result.isEmpty) return;
    setState(() => _bookingTimeFrame = result);
  }

  Future<void> _editNightPrice() async {
    final result = await showEditNightPriceDialog(
      context,
      current: _nightPrice,
    );
    if (!mounted || result == null) return;
    setState(() {
      _nightPrice = result.isEmpty || result == '00' ? '--' : result;
    });
  }

  Future<void> _editContacts() async {
    final result = await showEditEmergencyContactDialog(
      context,
      contacts: _contacts,
    );
    if (!mounted || result == null || result.isEmpty) return;
    setState(() => _contacts = result);
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
                              const _DrivadoAvatar(),
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
                                      'Website : www.drivado.com',
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
                        const _InfoRow(
                          icon: AppIcons.summaryEmail,
                          label: 'Email ID',
                          value: 'abhishek@drivado.com',
                        ),
                        const SizedBox(height: 12),
                        const _InfoRow(
                          icon: AppIcons.moreAffiliate,
                          label: 'Language',
                          value: 'English',
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: AppIcons.bookingsClock,
                          label: 'Booking Time Frame',
                          value: _bookingTimeFrame,
                          onEdit: _editBookingTime,
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: AppIcons.profileMoon,
                          label: 'Night Price',
                          value: _nightPrice,
                          onEdit: _editNightPrice,
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: AppIcons.bookingsPhone,
                          label: 'Contact',
                          value: _contacts
                              .map((contact) => contact.display)
                              .join('\n'),
                          onEdit: _editContacts,
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

class _DrivadoAvatar extends StatelessWidget {
  const _DrivadoAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: const Color(0xFFBFC1CC)),
      ),
      alignment: Alignment.center,
      child: AppText(
        'drivado',
        style: AppTextStyles.plus(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: -0.2,
        ),
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
          width: 120,
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
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                    padding: EdgeInsets.only(left: 8, top: 2, bottom: 2),
                    child: AppSvgIcon(
                      AppIcons.profileEdit,
                      size: 16,
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
