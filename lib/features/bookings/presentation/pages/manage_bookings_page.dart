import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/session/demo_user.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/utils/formatters.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:drivado_admin_app/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:drivado_admin_app/features/bookings/presentation/pages/booking_filter_page.dart';
import 'package:drivado_admin_app/features/bookings/presentation/pages/booking_summary_page.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/manage_booking_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManageBookingsPage extends StatefulWidget {
  const ManageBookingsPage({super.key});

  @override
  State<ManageBookingsPage> createState() => _ManageBookingsPageState();
}

class _ManageBookingsPageState extends State<ManageBookingsPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryDark,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
          _BookingsHeader(
            searchController: _search,
            onSearch: (q) =>
                context.read<BookingsBloc>().add(BookingsSearchChanged(q)),
          ),
          Expanded(
            child: AppRoundedSheet(
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.of(context).pageGutter,
                    ),
                    child: const _ActionRow(),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<BookingsBloc, BookingsState>(
                      builder: (context, state) {
                        if (state is BookingsLoading ||
                            state is BookingsInitial) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        if (state is BookingsFailure) {
                          return Center(
                            child: TextButton(
                              onPressed: () => context
                                  .read<BookingsBloc>()
                                  .add(const BookingsStarted()),
                              child: Text(state.message),
                            ),
                          );
                        }

                        final loaded = state as BookingsLoaded;
                        if (loaded.bookings.isEmpty) {
                          return Center(
                            child: AppText(
                              'No bookings found',
                              style: AppTextStyles.body,
                              weight: FontWeight.w500,
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            context
                                .read<BookingsBloc>()
                                     .add(const BookingsRefreshed());
                            await context.read<BookingsBloc>().stream.firstWhere(
                                  (s) =>
                                      s is BookingsLoaded ||
                                      s is BookingsFailure,
                                );
                          },
                          child: AppContent(
                            child: ResponsiveCardList(
                            padding: AppLayout.of(context)
                                .scrollPadding(top: 4, bottom: 100),
                            itemCount: loaded.bookings.length,
                            itemBuilder: (context, index) {
                              final booking = loaded.bookings[index];
                              return ManageBookingCard(
                                booking: booking,
                                onTap: () {
                                  Navigator.of(context).push(
                                    AppPageRoute(
                                      page: BookingSummaryPage(
                                        booking: booking,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _BookingsHeader extends StatelessWidget {
  const _BookingsHeader({
    required this.searchController,
    required this.onSearch,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  static const _counts = {
    BookingFilterTab.all: 100333,
    BookingFilterTab.td: 652,
    BookingFilterTab.tw: 300,
    BookingFilterTab.ua: 981,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppLayout.of(context).headerPadding,
      child: Column(
        children: [
          Row(
            children: [
              const AppAvatar(),
              const SizedBox(width: 12),
              const Expanded(
                child: UserGreeting(
                  name: DemoUser.firstName,
                  email: DemoUser.email,
                ),
              ),
              HeaderIconButton(
                asset: AppIcons.bookingsDownload,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              HeaderIconButton(
                asset: AppIcons.homeNotification,
                showDot: true,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppSearchField(
                  controller: searchController,
                  onChanged: onSearch,
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 52,
                height: 48,
                child: Material(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      final result = await Navigator.of(context)
                          .push<BookingFilterResult>(
                        AppPageRoute(page: const BookingFilterPage()),
                      );
                      if (!context.mounted || result == null) return;
                      if (result.query.isNotEmpty) {
                        searchController.text = result.query;
                        context
                            .read<BookingsBloc>()
                            .add(BookingsSearchChanged(result.query));
                      }
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.bookingsFilter,
                        width: 21,
                        height: 14.887,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BlocBuilder<BookingsBloc, BookingsState>(
            builder: (context, state) {
              final tab = state is BookingsLoaded
                  ? state.tab
                  : BookingFilterTab.all;

              return Row(
                children: [
                  for (var i = 0; i < BookingFilterTab.values.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: _RegionTab(
                        label: BookingFilterTab.values[i].label,
                        count: _counts[BookingFilterTab.values[i]]!,
                        selected: tab == BookingFilterTab.values[i],
                        onTap: () => context.read<BookingsBloc>().add(
                              BookingsTabChanged(BookingFilterTab.values[i]),
                            ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RegionTab extends StatelessWidget {
  const _RegionTab({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : const Color(0xFF352828),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              label,
              style: AppTextStyles.label,
              size: 12,
              weight: FontWeight.w600,
              color: selected ? AppColors.primary : AppColors.textOnDark,
            ),
            const SizedBox(height: 2),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(40),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AppText(
                  AppFormatters.indianCount(count),
                  style: AppTextStyles.chip,
                  size: 8,
                  weight: FontWeight.w600,
                  color:
                      selected ? AppColors.textOnDark : const Color(0xFF352828),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ActionChip { none, clock, wallet }

class _ActionRow extends StatefulWidget {
  const _ActionRow();

  @override
  State<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<_ActionRow> {
  _ActionChip _selected = _ActionChip.wallet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppBadgeButton(
          asset: AppIcons.bookingsActionClock,
          label: '(10)',
          accent: AppColors.chipGreen,
          softColor: AppColors.chipGreenSoft,
          selected: _selected == _ActionChip.clock,
          onTap: () => setState(() => _selected = _ActionChip.clock),
          onClear: () => setState(() => _selected = _ActionChip.none),
        ),
        const SizedBox(width: 12),
        AppBadgeButton(
          asset: AppIcons.bookingsActionWallet,
          label: '(10)',
          accent: AppColors.primary,
          softColor: AppColors.chipRedSoft,
          selected: _selected == _ActionChip.wallet,
          onTap: () => setState(() => _selected = _ActionChip.wallet),
          onClear: () => setState(() => _selected = _ActionChip.none),
        ),
        const Spacer(),
        Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppSvgIcon(AppIcons.bookingsBulkAssign, size: 16),
                  AppText(
                    '+',
                    style: AppTextStyles.bodyStrong,
                    color: Colors.white,
                    size: 16,
                    weight: FontWeight.w500,
                    height: 13 / 16,
                  ),
                  const SizedBox(width: 4),
                  AppText(
                    'Bulk Assign',
                    style: AppTextStyles.navLabel,
                    color: Colors.white,
                    size: 10,
                    weight: FontWeight.w500,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
