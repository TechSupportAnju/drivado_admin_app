import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/session/session_store.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/login_page.dart';
import 'package:drivado_admin_app/features/profile/presentation/pages/profile_document_page.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/confirm_action_dialog.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_headers.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _menu = <({String label, String icon})>[
    (label: 'New booking', icon: AppIcons.moreNewBooking),
    (label: 'Offline booking', icon: AppIcons.moreOfflineBooking),
    (label: 'Flat rates', icon: AppIcons.moreFlatRates),
    (label: 'Affiliate', icon: AppIcons.moreAffiliate),
    (label: 'Event', icon: AppIcons.moreEvent),
    (label: 'Coupon', icon: AppIcons.moreCoupon),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MorePageHeader(),
          Expanded(
            child: ColoredBox(
              color: AppColors.background,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                children: [
                  const ProfileSectionCard(
                    padding: EdgeInsets.all(16),
                    child: ProfileIdentityTile(
                      name: 'Drivado',
                      email: 'abhishek@drivado.com',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileSectionCard(
                    child: Column(
                      children: [
                        for (var i = 0; i < _menu.length; i++)
                          ProfileMenuTile(
                            label: _menu[i].label,
                            icon: _menu[i].icon,
                            showDivider: i != _menu.length - 1,
                            onTap: () => _open(
                              context,
                              ProfileDocumentPage(title: _menu[i].label),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileSectionCard(
                    child: ProfileMenuTile(
                      label: 'Logout',
                      icon: AppIcons.moreLogout,
                      subtitle: 'Securely log out of Account',
                      destructive: true,
                      iconHasBackground: true,
                      onTap: () => _confirmLogout(context),
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

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(AppPageRoute(page: page));
  }

  void _confirmLogout(BuildContext context) {
    ConfirmActionDialog.show(
      context,
      icon: AppIcons.profileLogoutPopup,
      title: 'Are you sure you want to log out?',
      message:
          'You will be signed out of your account. Your booking history and saved details will stay safe.',
      primaryLabel: 'Stay logged in',
      secondaryLabel: 'Log out',
      onPrimary: () => Navigator.of(context).pop(),
      onSecondary: () async {
        Navigator.of(context).pop();
        await SessionStore.instance.logout();
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          AppPageRoute(page: const LoginPage()),
          (_) => false,
        );
      },
    );
  }
}
