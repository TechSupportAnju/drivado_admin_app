import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/session/session_store.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/login_page.dart';
import 'package:drivado_admin_app/features/affiliates/presentation/pages/affiliates_page.dart';
import 'package:drivado_admin_app/features/coupons/presentation/pages/coupons_page.dart';
import 'package:drivado_admin_app/features/events/presentation/pages/events_page.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/pages/new_booking_page.dart';
import 'package:drivado_admin_app/features/profile/presentation/pages/company_profile_page.dart';
import 'package:drivado_admin_app/features/profile/presentation/pages/profile_document_page.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/confirm_action_dialog.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_headers.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.onOpenNewBooking});

  final VoidCallback? onOpenNewBooking;

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
              color: const Color(0xFFF5F6FA),
              child: AppContent(
                child: ListView(
                  padding:
                      AppLayout.of(context).scrollPadding(top: 16, bottom: 100),
                  children: [
                    ProfileSectionCard(
                      radius: 16,
                      padding: const EdgeInsets.all(16),
                      onTap: () => _open(context, const CompanyProfilePage()),
                      child: const ProfileIdentityTile(
                        name: 'Drivado',
                        email: 'abhishek@drivado.com',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProfileSectionCard(
                      child: Column(
                        children: [
                          for (var i = 0; i < _menu.length; i++) ...[
                            if (i > 0) const SizedBox(height: 16),
                            ProfileMenuTile(
                              label: _menu[i].label,
                              icon: _menu[i].icon,
                              onTap: () {
                                if (_menu[i].label == 'New booking' &&
                                    onOpenNewBooking != null) {
                                  onOpenNewBooking!();
                                  return;
                                }
                                _open(
                                  context,
                                  switch (_menu[i].label) {
                                    'New booking' => const NewBookingPage(),
                                    'Coupon' => const CouponsPage(),
                                    'Affiliate' => const AffiliatesPage(),
                                    'Event' => const EventsPage(),
                                    _ => ProfileDocumentPage(
                                        title: _menu[i].label,
                                      ),
                                  },
                                );
                              },
                            ),
                          ],
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
                        onTap: () => _confirmLogout(context),
                      ),
                    ),
                  ],
                ),
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
