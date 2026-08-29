import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/bookings/presentation/widgets/booking_summary_outline_button.dart';
import 'package:flutter/material.dart';

class BookingFlightStatusPanel extends StatefulWidget {
  const BookingFlightStatusPanel({super.key});

  @override
  State<BookingFlightStatusPanel> createState() =>
      _BookingFlightStatusPanelState();
}

class _BookingFlightStatusPanelState extends State<BookingFlightStatusPanel> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    if (!_open) {
      return BookingSummaryOutlineButton(
        icon: AppIcons.summaryFlight,
        label: 'Flight Status',
        foreground: AppColors.primary,
        borderColor: AppColors.primary,
        onTap: () => setState(() => _open = true),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _open = false),
      child: const SizedBox(
        width: 160,
        child: _FlightExpanded(),
      ),
    );
  }
}

class _FlightExpanded extends StatelessWidget {
  const _FlightExpanded();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _stamp(label: 'ETA', value: '10-05-2024 9:15 AM'),
              const SizedBox(height: 6),
              AppText(
                'On Time',
                style: AppTextStyles.chip,
                size: 10,
                height: 1.1,
                align: TextAlign.center,
                color: AppColors.successGreen,
                weight: FontWeight.w700,
              ),
              const SizedBox(height: 3),
              Container(
                height: 2.5,
                decoration: BoxDecoration(
                  color: AppColors.successGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 3),
              AppText(
                'Terminal No. 04',
                style: AppTextStyles.chip,
                size: 10,
                height: 1.1,
                align: TextAlign.center,
                color: AppColors.textSecondary,
                weight: FontWeight.w400,
              ),
              const SizedBox(height: 6),
              _stamp(label: 'STA', value: '10-05-2024 9:15 AM'),
            ],
          ),
        ),
        const SizedBox(width: 4),
        const SizedBox(
          width: 40,
          height: 102,
          child: Column(
            children: [
              _AirportMark(
                icon: AppIcons.summaryArrival,
                code: 'DOH',
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: CustomPaint(
                    painter: _FlightDashPainter(),
                    child: SizedBox(width: 10),
                  ),
                ),
              ),
              _AirportMark(
                icon: AppIcons.summaryDeparture,
                code: 'IND',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stamp({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          style: AppTextStyles.chip,
          size: 10,
          height: 1.1,
          color: AppColors.textSecondary,
          weight: FontWeight.w400,
        ),
        const SizedBox(height: 2),
        AppText(
          value,
          style: AppTextStyles.chip,
          size: 10,
          height: 1.1,
          color: AppColors.textSecondary,
          weight: FontWeight.w700,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _AirportMark extends StatelessWidget {
  const _AirportMark({required this.icon, required this.code});

  final String icon;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppSvgIcon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 2),
        AppText(
          code,
          style: AppTextStyles.chip,
          size: 10,
          height: 1.1,
          color: AppColors.textSecondary,
          weight: FontWeight.w500,
        ),
      ],
    );
  }
}

class _FlightDashPainter extends CustomPainter {
  const _FlightDashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9A9A9A)
      ..strokeWidth = 1.1;
    const dash = 2.5;
    const gap = 2.0;
    var y = 0.0;
    final x = size.width / 2;
    while (y < size.height) {
      canvas.drawLine(Offset(x, y), Offset(x, y + dash), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
