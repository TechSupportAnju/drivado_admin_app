import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.selected,
    required this.onTap,
  });

  final VehicleOption vehicle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = selected ? Colors.white : const Color(0xFF0D0D0D);
    final subColor = selected ? Colors.white70 : const Color(0xFF606060);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: selected
                  ? const LinearGradient(
                      colors: [Color(0xFF190C0C), Color(0xFF85252F)],
                    )
                  : null,
              color: selected ? null : const Color(0xFFF2F2F2),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          vehicle.vehicleType,
                          style: AppTextStyles.subtitle,
                          size: 16,
                          weight: FontWeight.w700,
                          color: titleColor,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          vehicle.description,
                          style: AppTextStyles.caption,
                          size: 12,
                          color: subColor,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _chip(
                              icon: AppIcons.vehiclePassenger,
                              label: 'Max. ${vehicle.passengerCount}',
                              selected: selected,
                            ),
                            const SizedBox(width: 8),
                            _chip(
                              icon: AppIcons.vehicleLuggage,
                              label: 'Max. ${vehicle.luggageCount}',
                              selected: selected,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 110,
                        height: 64,
                        child: _VehicleImage(
                          url: vehicle.imageUrl,
                          selected: selected,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        vehicle.priceLabel,
                        style: AppTextStyles.bodyStrong,
                        size: 16,
                        weight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip({
    required String icon,
    required String label,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0D0D0D) : const Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvgIcon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          AppText(
            label,
            style: AppTextStyles.caption,
            size: 10,
            weight: FontWeight.w600,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _VehicleImage extends StatelessWidget {
  const _VehicleImage({required this.url, required this.selected});

  final String? url;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(
      Icons.directions_car_filled_rounded,
      size: 56,
      color: selected ? Colors.white70 : AppColors.textSecondary,
    );
    if (url == null || url!.isEmpty) return fallback;
    return Image.network(
      url!,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
