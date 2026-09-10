import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/pages/booking_confirmed_page.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/widgets/booking_flow_chrome.dart';
import 'package:flutter/material.dart';

class CreateBookingSummaryPage extends StatelessWidget {
  const CreateBookingSummaryPage({super.key, required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final vehicle = draft.vehicle!;
    final passenger = draft.passenger!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BookingFlowAppBar(title: 'Booking Summary'),
      body: AppContent(
        child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: BookingFlowProgressBar(step: 1),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Card(
                  title: 'Booking Details',
                  children: [
                    _line(AppIcons.b2bCalendar, '${draft.dateLabel}  ·  ${draft.timeLabel}'),
                    _line(AppIcons.b2bFrom, draft.pickup),
                    if (draft.isOneway)
                      _line(AppIcons.b2bTo, draft.destination)
                    else
                      _line(AppIcons.b2bClock, draft.duration ?? ''),
                    _line(AppIcons.summaryCar, vehicle.vehicleType),
                    _line(
                      AppIcons.createPax,
                      '${draft.passengers} Pax  ·  ${draft.distanceKm}  ·  ${draft.routeDuration}',
                    ),
                    _line(AppIcons.assignPrice, vehicle.priceLabel),
                  ],
                ),
                const SizedBox(height: 12),
                _Card(
                  title: 'Passenger Details',
                  children: [
                    _line(AppIcons.b2bPaxName, passenger.fullName),
                    _line(
                      AppIcons.b2bPaxContact,
                      '${passenger.countryCode} ${passenger.phone}',
                    ),
                    _line(AppIcons.b2bPaxEmail, passenger.email),
                    _line(
                      AppIcons.b2bPaxFlight,
                      passenger.flightNo.isEmpty ? '—' : passenger.flightNo,
                    ),
                    _line(
                      AppIcons.b2bPaxRequest,
                      passenger.specialRequest.isEmpty
                          ? '—'
                          : passenger.specialRequest,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.textSecondary),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Pay now',
                      onPressed: () {
                        Navigator.of(context).push(
                          AppPageRoute(
                            page: BookingConfirmedPage(draft: draft),
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

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x19000000), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: AppTextStyles.subtitle,
            size: 16,
            weight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

Widget _line(String icon, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        AppSvgIcon(icon, size: 16),
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
    ),
  );
}
