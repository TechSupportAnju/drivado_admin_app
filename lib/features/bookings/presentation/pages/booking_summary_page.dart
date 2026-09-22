import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:drivado_admin_app/features/bookings/presentation/pages/assign_ride_page.dart';
import 'package:drivado_admin_app/features/bookings/presentation/pages/booking_documents_page.dart';
import 'package:drivado_admin_app/features/bookings/presentation/pages/clone_booking_page.dart';
import 'package:drivado_admin_app/features/bookings/presentation/pages/edit_booking_page.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_flight_status_panel.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_more_menu.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_ops_status.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_status_menu.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_summary_expand_card.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_summary_info_row.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_summary_outline_button.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/change_booking_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({super.key, required this.booking});

  final ManagedBooking booking;

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  late String _opsStatus;

  @override
  void initState() {
    super.initState();
    _opsStatus = widget.booking.opsStatus;
  }

  ManagedBooking get booking => widget.booking;

  Future<void> _onStatusTap() async {
    final selected = await BookingStatusMenu.show(context);
    if (!mounted || selected == null || selected == _opsStatus) return;

    final confirmed = await ChangeBookingStatusDialog.confirm(
      context,
      fromStatus: _opsStatus,
      toStatus: selected,
    );
    if (!mounted || !confirmed) return;
    setState(() => _opsStatus = selected);
  }

  @override
  Widget build(BuildContext context) {
    final created = DateFormat('dd-MM-yyyy')
        .format(booking.createdAt ?? booking.scheduledAt);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 64,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const AppSvgIcon(AppIcons.summaryBack, size: 40),
        ),
        title: AppText(
          'Booking Summary',
          style: AppTextStyles.subtitle,
          size: 20,
          color: AppColors.textOnDark,
          weight: FontWeight.w500,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: _showMoreMenu,
              icon: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.headerButton,
                  shape: BoxShape.circle,
                ),
                child: const AppSvgIcon(AppIcons.summaryMore, size: 22),
              ),
            ),
          ),
        ],
      ),
      body: AppContent(
        child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppLayout.of(context).pageGutter,
          16,
          AppLayout.of(context).pageGutter,
          48 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _IdCard(
            bookingId: booking.id,
            opsStatus: _opsStatus,
            paymentStatus: booking.paymentStatus,
            onDocuments: () {
              Navigator.of(context).push(
                AppPageRoute(
                  page: BookingDocumentsPage(booking: booking),
                ),
              );
            },
            onStatusTap: _onStatusTap,
          ),
          const SizedBox(height: 10),
          _TripCard(
            booking: booking,
            onNavigate: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening navigation')),
              );
            },
          ),
          const SizedBox(height: 10),
          BookingSummaryExpandCard(
            title: 'Affiliate Details',
            children: [
              BookingSummaryInfoRow(
                icon: AppIcons.summaryPax,
                label: 'Affiliate To:',
                value: booking.affiliateTo,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.bookingsClock,
                label: 'Affiliate At:',
                value: booking.affiliateAt,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.summarySwap,
                label: 'Assigned By:',
                value: booking.assignedBy,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.summaryContact,
                label: 'Contact Affiliate:',
                value: booking.affiliateContact,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.bookingsWallet,
                label: 'Purchase Price:',
                value: booking.purchasePrice,
                badge: booking.purchasePriceEdited ? 'Edited' : null,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.summaryNote,
                label: 'Affiliate Note:',
                value: booking.affiliateNote,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.summaryCar,
                label: 'Car Plate:',
                value: booking.carPlate,
              ),
            ],
          ),
          const SizedBox(height: 10),
          BookingSummaryExpandCard(
            title: 'Additional Details',
            children: [
              BookingSummaryInfoRow(
                icon: AppIcons.summaryPax,
                label: 'Booked By:',
                value: booking.bookedBy,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.summaryPax,
                label: 'Created date:',
                value: created,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.summaryEmail,
                label: 'Ref. number:',
                value: booking.referenceNumber,
              ),
              BookingSummaryInfoRow(
                icon: AppIcons.summarySpecialRequest,
                label: 'Spl. request:',
                value: booking.specialRequest,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
      ),
    );
  }

  Future<void> _showMoreMenu() async {
    final action = await BookingMoreMenu.show(context);
    if (!mounted || action == null) return;

    if (action == BookingMoreAction.editBooking) {
      await Navigator.of(context).push(
        AppPageRoute(page: EditBookingPage(booking: booking)),
      );
      return;
    }

    if (action == BookingMoreAction.assignRide) {
      await Navigator.of(context).push(
        AppPageRoute(page: AssignRidePage(booking: booking)),
      );
      return;
    }

    if (action == BookingMoreAction.clone) {
      await Navigator.of(context).push(
        AppPageRoute(page: CloneBookingPage(booking: booking)),
      );
      return;
    }

    if (action == BookingMoreAction.cancel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cancel')),
      );
    }
  }
}

class _IdCard extends StatelessWidget {
  const _IdCard({
    required this.bookingId,
    required this.opsStatus,
    required this.paymentStatus,
    required this.onDocuments,
    required this.onStatusTap,
  });

  final String bookingId;
  final String opsStatus;
  final String paymentStatus;
  final VoidCallback onDocuments;
  final VoidCallback onStatusTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Booking ID',
                      style: AppTextStyles.caption,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 6),
                    AppText(
                      bookingId,
                      style: AppTextStyles.subtitle,
                      size: 18,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              BookingSummaryOutlineButton(
                icon: AppIcons.summaryDocument,
                label: 'Documents',
                foreground: AppColors.textSecondary,
                borderColor: const Color(0xFFB8B8B8),
                onTap: onDocuments,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: onStatusTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      'Status: ',
                      style: AppTextStyles.caption,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    Text(
                      opsStatus,
                      key: ValueKey('ops-status-$opsStatus'),
                      style: BookingOpsStatus.textStyle(opsStatus),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: BookingOpsStatus.colorOf(opsStatus),
                      size: 18,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppText(
                'Payment: ',
                style: AppTextStyles.caption,
                size: 14,
                color: AppColors.textSecondary,
              ),
              AppText(
                paymentStatus,
                style: AppTextStyles.label,
                size: 14,
                color: AppColors.primary,
                weight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({
    required this.booking,
    required this.onNavigate,
  });

  final ManagedBooking booking;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    final dayLabel = DateFormat('EEE,').format(booking.scheduledAt);
    final dateLabel = DateFormat('MMM d, yyyy').format(booking.scheduledAt);
    final timeLabel = DateFormat('HH:mm').format(booking.scheduledAt);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    dayLabel,
                    style: AppTextStyles.caption,
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    dateLabel,
                    style: AppTextStyles.caption,
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    timeLabel,
                    size: 36,
                    weight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: BookingFlightStatusPanel(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AppText(
                'Vehicle Type',
                style: AppTextStyles.caption,
              ),
              const Spacer(),
              AppText(
                'Price',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: AppText(
                  booking.vehicle.toUpperCase(),
                  style: AppTextStyles.subtitle,
                  weight: FontWeight.w700,
                ),
              ),
              AppText(
                booking.amount,
                style: AppTextStyles.subtitle,
                color: AppColors.primary,
                weight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      width: 18,
                      child: _TimelineRail(
                        icon: AppSvgIcon(AppIcons.summarySource, size: 8),
                        dash: _DashSpan.fromCenterDown,
                        iconSize: 8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        booking.pickup,
                        style: AppTextStyles.caption,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      child: CustomPaint(
                        size: Size(18, 44),
                        painter: _DashPainter(span: _DashSpan.full),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          _Chip(label: booking.tripType),
                          const SizedBox(width: 6),
                          Flexible(
                            child: _Chip(label: booking.metaLabel),
                          ),
                          const SizedBox(width: 6),
                          BookingSummaryOutlineButton(
                            icon: AppIcons.summaryNavigate,
                            label: 'Navigate',
                            foreground: AppColors.primary,
                            borderColor: AppColors.primary,
                            height: 24,
                            iconSize: 11,
                            fontSize: 11,
                            radius: 20,
                            onTap: onNavigate,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      width: 18,
                      child: _TimelineRail(
                        icon: AppSvgIcon(AppIcons.summaryDest, size: 12),
                        dash: _DashSpan.fromTopToCenter,
                        iconSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        booking.dropoff,
                        style: AppTextStyles.caption,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BookingSummaryInfoRow(
            icon: AppIcons.summaryPax,
            label: 'Pax name:',
            value: booking.customer,
          ),
          const SizedBox(height: 12),
          BookingSummaryInfoRow(
            icon: AppIcons.summaryContact,
            label: 'Mob. number:',
            value: booking.customerPhone.isEmpty
                ? '—'
                : booking.customerPhone,
          ),
          const SizedBox(height: 12),
          BookingSummaryInfoRow(
            icon: AppIcons.summaryEmail,
            label: 'Email ID:',
            value: booking.customerEmail.isEmpty
                ? '—'
                : booking.customerEmail,
          ),
          const SizedBox(height: 12),
          BookingSummaryInfoRow(
            icon: AppIcons.summaryPaxCount,
            label: 'Passenger count:',
            value: booking.passengerCountLabel,
          ),
          const SizedBox(height: 12),
          BookingSummaryInfoRow(
            icon: AppIcons.summaryPax,
            label: 'Chauffeur name:',
            value: booking.driverName,
          ),
          const SizedBox(height: 12),
          BookingSummaryInfoRow(
            icon: AppIcons.summaryContact,
            label: 'Chauffeur number:',
            value: booking.driverPhone,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        label,
        style: AppTextStyles.chip,
        color: AppColors.textPrimary,
        weight: FontWeight.w500,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

enum _DashSpan { fromCenterDown, full, fromTopToCenter }

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({
    required this.icon,
    required this.dash,
    required this.iconSize,
  });

  final Widget icon;
  final _DashSpan dash;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _DashPainter(
              span: dash,
              iconSize: iconSize,
            ),
            child: const SizedBox.expand(),
          ),
        ),
        Center(child: icon),
      ],
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter({
    this.span = _DashSpan.full,
    this.iconSize = 0,
  });

  final _DashSpan span;
  final double iconSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height <= 0) return;
    final paint = Paint()
      ..color = const Color(0xFF9A9A9A)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    const dash = 3.0;
    const gap = 2.5;
    final x = size.width / 2;
    final gapFromIcon = iconSize / 2 + 2;
    final start = switch (span) {
      _DashSpan.fromCenterDown => size.height / 2 + gapFromIcon,
      _DashSpan.full => 0.0,
      _DashSpan.fromTopToCenter => 0.0,
    };
    final end = switch (span) {
      _DashSpan.fromCenterDown => size.height,
      _DashSpan.full => size.height,
      _DashSpan.fromTopToCenter => size.height / 2 - gapFromIcon,
    };
    if (end <= start) return;
    var y = start;
    while (y < end) {
      final next = (y + dash).clamp(y, end);
      canvas.drawLine(Offset(x, y), Offset(x, next), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) =>
      oldDelegate.span != span || oldDelegate.iconSize != iconSize;
}
