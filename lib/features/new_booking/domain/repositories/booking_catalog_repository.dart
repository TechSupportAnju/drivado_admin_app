import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';

abstract class BookingCatalogRepository {
  List<String> get locations;
  List<String> get durations;

  Future<List<VehicleOption>> searchVehicles({
    required bool isOneway,
    required String currency,
    required String pickup,
    String? dropoff,
    String? duration,
  });
}
