import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:drivado_admin_app/features/new_booking/domain/repositories/booking_catalog_repository.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/bloc/search_vehicle_bloc.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/pages/choose_vehicle_page.dart';
import 'package:drivado_admin_app/features/new_booking/presentation/widgets/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showVehicleResultsSheet({
  required BuildContext context,
  required BookingDraft draft,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => SearchVehicleBloc(
        repository: context.read<BookingCatalogRepository>(),
      )
        ..add(
          SearchVehicleRequested(
            SearchVehicleRequest(
              isOneway: draft.isOneway,
              currency: draft.currency,
              pickup: draft.pickup,
              dropoff: draft.dropoff,
              duration: draft.duration,
            ),
          ),
        ),
      child: _VehicleResultsSheet(draft: draft),
    ),
  );
}

class _VehicleResultsSheet extends StatelessWidget {
  const _VehicleResultsSheet({required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final height = AppLayout.of(context).sheetHeight(0.9);
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF818181).withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchVehicleBloc, SearchVehicleState>(
              builder: (context, state) {
                if (state is SearchVehicleLoading ||
                    state is SearchVehicleInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (state is SearchVehicleFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            state.message,
                            align: TextAlign.center,
                            style: AppTextStyles.body,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              context.read<SearchVehicleBloc>().add(
                                    SearchVehicleRequested(
                                      SearchVehicleRequest(
                                        isOneway: draft.isOneway,
                                        currency: draft.currency,
                                        pickup: draft.pickup,
                                        dropoff: draft.dropoff,
                                        duration: draft.duration,
                                      ),
                                    ),
                                  );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is! SearchVehicleLoaded || state.vehicles.isEmpty) {
                  return Center(
                    child: AppText(
                      'No vehicles found.',
                      style: AppTextStyles.body,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = state.vehicles[index];
                    return VehicleCard(
                      vehicle: vehicle,
                      selected: false,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          SheetUpRoute(
                            page: ChooseVehiclePage(
                              draft: draft.copyWith(vehicle: vehicle),
                              vehicles: List<VehicleOption>.from(state.vehicles),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
