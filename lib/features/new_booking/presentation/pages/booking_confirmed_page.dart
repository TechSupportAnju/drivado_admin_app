import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/widgets/booking_flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingConfirmedPage extends StatefulWidget {
  const BookingConfirmedPage({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingConfirmedPage> createState() => _BookingConfirmedPageState();
}

class _BookingConfirmedPageState extends State<BookingConfirmedPage> {
  var _showCongrats = true;
  late final String _bookingId;

  @override
  void initState() {
    super.initState();
    final stamp = DateTime.now();
    _bookingId =
        'D${stamp.month.toString().padLeft(2, '0')}${stamp.day.toString().padLeft(2, '0')}-${4500 + stamp.minute}';
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showCongrats = false);
    });
  }

  void _backHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final vehicle = draft.vehicle!;
    final passenger = draft.passenger!;

    if (_showCongrats) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.surface,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 120,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                AppText(
                  'Congratulations',
                  style: AppTextStyles.subtitle,
                  size: 24,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: 8),
                AppText(
                  'Your ride is booked',
                  style: AppTextStyles.body,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5FA),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Material(
                      color: const Color(0xFFF5F6FA),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _backHome,
                        child: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.home_outlined,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        'Booking Receipt',
                        align: TextAlign.center,
                        style: AppTextStyles.subtitle,
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      children: [
                        AppSvgIcon(
                          AppIcons.summaryDocument,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          'PDF',
                          style: AppTextStyles.caption,
                          size: 10,
                          weight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: BookingFlowProgressBar(step: 2),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    _ReceiptCard(
                      bookingId: _bookingId,
                      draft: draft,
                      vehicle: vehicle,
                      passenger: passenger,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton.icon(
                        onPressed: _backHome,
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        label: AppText(
                          'Back to Booking',
                          style: AppTextStyles.bodyStrong,
                          size: 14,
                          weight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({
    required this.bookingId,
    required this.draft,
    required this.vehicle,
    required this.passenger,
  });

  final String bookingId;
  final BookingDraft draft;
  final VehicleOption vehicle;
  final PassengerInfo passenger;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A606060),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Column(
              children: [
                AppText(
                  'Booking Details',
                  style: AppTextStyles.bodyStrong,
                  size: 16,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 16),
                _idRow(context),
                const SizedBox(height: 12),
                _iconLine(AppIcons.b2bFrom, draft.pickup),
                if (draft.isOneway) ...[
                  const SizedBox(height: 12),
                  _iconLine(AppIcons.b2bTo, draft.destination),
                ],
                const SizedBox(height: 12),
                _iconLine(AppIcons.b2bCalendar, draft.dateLabel),
                const SizedBox(height: 12),
                _iconLine(AppIcons.b2bClock, draft.timeLabel),
                const SizedBox(height: 12),
                _iconLine(
                  AppIcons.createOneway,
                  draft.isOneway ? 'Airport transfers' : 'Hourly chauffeur',
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _tag(vehicle.vehicleType),
                    _tag('${draft.passengers} Pax'),
                    _tag('${draft.distanceKm} | ${draft.routeDuration}'),
                  ],
                ),
              ],
            ),
          ),
          _TicketDivider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
            child: Column(
              children: [
                AppText(
                  'Passenger Details',
                  style: AppTextStyles.bodyStrong,
                  size: 16,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 16),
                _iconLine(AppIcons.b2bPaxName, passenger.fullName),
                const SizedBox(height: 12),
                _iconLine(
                  AppIcons.b2bPaxContact,
                  '${passenger.countryCode} ${passenger.phone}',
                ),
                const SizedBox(height: 12),
                _iconLine(AppIcons.b2bPaxEmail, passenger.email),
                if (passenger.flightNo.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _iconLine(AppIcons.b2bPaxFlight, passenger.flightNo),
                ],
                if (passenger.specialRequest.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _iconLine(AppIcons.b2bPaxRequest, passenger.specialRequest),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE6E8E7)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  'Price: ',
                  style: AppTextStyles.body,
                  size: 20,
                  weight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${vehicle.price}.00',
                        style: AppTextStyles.plus(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: ' ${vehicle.unit}',
                        style: AppTextStyles.plus(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _idRow(BuildContext context) {
    return Row(
      children: [
        const AppSvgIcon(AppIcons.summaryDocument, size: 14),
        const SizedBox(width: 12),
        AppText(
          bookingId,
          style: AppTextStyles.bodyStrong,
          size: 13,
          weight: FontWeight.w500,
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: bookingId));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking ID copied')),
            );
          },
          child: const Icon(Icons.copy, size: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _iconLine(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: AppSvgIcon(icon, size: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppText(
            text,
            style: AppTextStyles.body,
            size: 14,
            color: const Color(0xFF555555),
          ),
        ),
      ],
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stroke),
      ),
      child: AppText(
        label,
        style: AppTextStyles.caption,
        size: 10,
        weight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _TicketDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: List.generate(
                  (constraints.maxWidth / 8).floor(),
                  (i) => Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: i.isEven
                          ? const Color(0xFFD9D9D9)
                          : Colors.transparent,
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: const Offset(-10, 0),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5FA),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Transform.translate(
              offset: const Offset(10, 0),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5FA),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
