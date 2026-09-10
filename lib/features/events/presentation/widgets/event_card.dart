import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/events/domain/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  final EventItem event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static const _markupGreen = Color(0xFF098C31);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LabeledValue(
                  icon: AppIcons.moreEvent,
                  label: 'Event name',
                  value: event.name,
                  valueSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              _IconAction(
                icon: AppIcons.summaryEdit,
                tooltip: 'Edit',
                onTap: onEdit,
              ),
              const SizedBox(width: 8),
              _IconAction(
                icon: AppIcons.profileDelete,
                tooltip: 'Delete',
                onTap: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _LabeledValue(
                    icon: AppIcons.bookingsCalendar,
                    label: 'Start date',
                    value: _dateFormat.format(event.startDate),
                  ),
                ),
                Expanded(
                  child: _LabeledValue(
                    icon: AppIcons.bookingsCalendar,
                    label: 'End date',
                    value: _dateFormat.format(event.endDate),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _LabeledValue(
            icon: AppIcons.bookingsDestination,
            label: 'Region/City',
            value: event.locationLabel,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                const AppSvgIcon(
                  AppIcons.assignPrice,
                  size: 14,
                  color: _markupGreen,
                ),
                const SizedBox(width: 6),
                AppText(
                  'Markup: ${event.markup}',
                  style: AppTextStyles.bodyStrong,
                  size: 12,
                  color: _markupGreen,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({
    required this.icon,
    required this.label,
    required this.value,
    this.valueSize = 14,
  });

  final String icon;
  final String label;
  final String value;
  final double valueSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: AppSvgIcon(icon, size: 14, color: const Color(0xFF606060)),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                style: AppTextStyles.caption,
                size: 11,
                color: const Color(0xFF606060),
                weight: FontWeight.w400,
              ),
              const SizedBox(height: 2),
              AppText(
                value,
                style: AppTextStyles.bodyStrong,
                size: valueSize,
                color: AppColors.textPrimary,
                weight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final String icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary),
          ),
          child: AppSvgIcon(icon, size: 14, color: AppColors.primary),
        ),
      ),
    );
  }
}
