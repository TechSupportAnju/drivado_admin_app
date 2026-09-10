import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/session/demo_user.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:drivado_admin_app/features/bookings/presentation/pages/manage_bookings_page.dart';
import 'package:drivado_admin_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:drivado_admin_app/features/home/presentation/widgets/admin_bottom_nav.dart';
import 'package:drivado_admin_app/features/home/presentation/widgets/booking_list_tile.dart';
import 'package:drivado_admin_app/features/home/presentation/widgets/home_header.dart';
import 'package:drivado_admin_app/features/home/presentation/widgets/stats_summary_card.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/pages/new_booking_page.dart';
import 'package:drivado_admin_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage>
    with SingleTickerProviderStateMixin {
  int _tab = 0;
  late final AnimationController _enter;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 640),
    )..forward();
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  void _setTab(int index) {
    setState(() => _tab = index);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  void _openBookings() => _setTab(1);

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ScaleTransition(
          scale: CurvedAnimation(
            parent: _enter,
            curve: const Interval(0.45, 1, curve: Curves.easeOutBack),
          ),
          child: FloatingActionButton(
            onPressed: () => _setTab(4),
            backgroundColor: AppColors.primary,
            elevation: 6,
            shape: const CircleBorder(),
            child: const AppSvgIcon(
              AppIcons.bookingsAdd,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: AdminBottomNav(
          currentIndex: _tab > 3 ? -1 : _tab,
          onChanged: _setTab,
        ),
        body: IndexedStack(
          index: _tab > 3 ? 4 : _tab,
          children: [
            SafeArea(
              bottom: false,
              child: _HomeTab(
                enter: _enter,
                onSeeMore: _openBookings,
                onOpenBookings: _openBookings,
              ),
            ),
            const SafeArea(
              bottom: false,
              child: ManageBookingsPage(),
            ),
            const SafeArea(
              bottom: false,
              child: ManageBookingsPage(),
            ),
            ProfilePage(onOpenNewBooking: () => _setTab(4)),
            const NewBookingPage(embedded: true),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.enter,
    required this.onSeeMore,
    required this.onOpenBookings,
  });

  final AnimationController enter;
  final VoidCallback onSeeMore;
  final VoidCallback onOpenBookings;

  @override
  Widget build(BuildContext context) {
    final contentFade = CurvedAnimation(
      parent: enter,
      curve: const Interval(0.2, 1, curve: Curves.easeOut),
    );
    final contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: enter,
        curve: const Interval(0.15, 1, curve: Curves.easeOutCubic),
      ),
    );

    return Column(
      children: [
        FadeTransition(
          opacity: CurvedAnimation(
            parent: enter,
            curve: const Interval(0, 0.5, curve: Curves.easeOut),
          ),
          child: const HomeHeader(
            name: DemoUser.firstName,
            email: DemoUser.email,
          ),
        ),
        Expanded(
          child: FadeTransition(
            opacity: contentFade,
            child: SlideTransition(
              position: contentSlide,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: _HomeDashboard(
                  onSeeMore: onSeeMore,
                  onOpenBookings: onOpenBookings,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({
    required this.onSeeMore,
    required this.onOpenBookings,
  });

  final VoidCallback onSeeMore;
  final VoidCallback onOpenBookings;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is! DashboardLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final bookings = state.snapshot.recentBookings;
        final layout = AppLayout.of(context);
        return AppContent(
          child: ListView(
          padding: layout.scrollPadding(bottom: 100),
          children: [
            const StatsSummaryCard(
              total: 1235,
              confirmed: 600,
              completed: 585,
              cancelled: 50,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29606060),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Recent Bookings',
                          style: AppTextStyles.subtitle,
                        ),
                      ),
                      GestureDetector(
                        onTap: onSeeMore,
                        child: Text(
                          'See More',
                          style: AppTextStyles.caption.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...bookings.asMap().entries.map((entry) {
                    final i = entry.key;
                    final b = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: i == bookings.length - 1 ? 0 : 8,
                      ),
                      child: BookingListTile(
                        booking: b,
                        onTap: onOpenBookings,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        );
      },
    );
  }
}
