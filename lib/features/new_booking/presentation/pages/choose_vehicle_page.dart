import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/pages/passenger_details_page.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/widgets/vehicle_actions.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/widgets/vehicle_card.dart';
import 'package:flutter/material.dart';

class ChooseVehiclePage extends StatefulWidget {
  const ChooseVehiclePage({
    super.key,
    required this.draft,
    required this.vehicles,
  });

  final BookingDraft draft;
  final List<VehicleOption> vehicles;

  @override
  State<ChooseVehiclePage> createState() => _ChooseVehiclePageState();
}

class _ChooseVehiclePageState extends State<ChooseVehiclePage> {
  late VehicleOption _selected;
  late List<VehicleOption> _list;

  @override
  void initState() {
    super.initState();
    _list = List<VehicleOption>.from(widget.vehicles);
    _selected = widget.draft.vehicle ?? _list.first;
    final index = _list.indexWhere((v) => v.id == _selected.id);
    if (index > 0) {
      final item = _list.removeAt(index);
      _list.add(item);
    }
  }

  void _select(VehicleOption vehicle) {
    setState(() {
      _selected = vehicle;
      _list.removeWhere((v) => v.id == vehicle.id);
      _list.add(vehicle);
    });
  }

  void _continue() {
    Navigator.of(context).push(
      AppPageRoute(
        page: PassengerDetailsPage(
          draft: widget.draft.copyWith(vehicle: _selected),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = _selected;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF311213), Color(0xFF8B363D), Color(0xFFBD3A46)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: AppContent(
            child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.keyboard_backspace,
                          color: Color(0xFFE6E8E7),
                        ),
                      ),
                    ),
                    AppText(
                      'Choose a vehicle class',
                      style: AppTextStyles.subtitle,
                      size: 20,
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => showInclusionDialog(context),
                        icon: const AppSvgIcon(
                          AppIcons.vehicleInclusion,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.directions_car_filled_rounded,
                size: 120,
                color: Colors.white.withValues(alpha: 0.92),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D0D0D),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(21, 16, 21, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppText(
                                    vehicle.vehicleType,
                                    style: AppTextStyles.subtitle,
                                    size: 20,
                                    color: Colors.white,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: AppText(
                                    '${widget.draft.distanceKm}  ·  ${widget.draft.routeDuration}',
                                    style: AppTextStyles.caption,
                                    size: 12,
                                    weight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              vehicle.description,
                              style: AppTextStyles.body,
                              size: 14,
                              color: const Color(0xFFABABAB),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                AppText(
                                  'Price: ',
                                  style: AppTextStyles.bodyStrong,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                AppText(
                                  '${vehicle.price} ${vehicle.unit}',
                                  style: AppTextStyles.subtitle,
                                  size: 20,
                                  color: const Color(0xFFE6E8E7),
                                  weight: FontWeight.w700,
                                ),
                                const Spacer(),
                                AppText(
                                  'Max ${vehicle.passengerCount} pax',
                                  style: AppTextStyles.caption,
                                  size: 12,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            BookNowSlider(onCompleted: _continue),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12, bottom: 4),
                                child: Container(
                                  width: 72,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF818181)
                                        .withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _list.length,
                                  itemBuilder: (context, index) {
                                    final item = _list[index];
                                    return VehicleCard(
                                      vehicle: item,
                                      selected: item.id == _selected.id,
                                      onTap: () => _select(item),
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
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
