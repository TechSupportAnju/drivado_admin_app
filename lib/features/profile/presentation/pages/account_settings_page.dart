import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/confirm_action_dialog.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_headers.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          ProfilePageHeader(
            title: 'Account Settings',
            onBack: () => Navigator.of(context).pop(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ProfileSectionCard(
              child: ProfileMenuTile(
                label: 'Delete account',
                icon: AppIcons.profileDelete,
                subtitle: 'Permanently remove your account',
                destructive: true,
                showChevron: false,
                onTap: () => _confirmDelete(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    ConfirmActionDialog.show(
      context,
      icon: AppIcons.profileDelete,
      title: 'Delete this account?',
      message:
          'This cannot be undone. Your profile and booking history will be removed.',
      primaryLabel: 'Keep account',
      secondaryLabel: 'Delete',
      onPrimary: () => Navigator.of(context).pop(),
      onSecondary: () => Navigator.of(context).pop(),
    );
  }
}
