import 'package:drivado_admin_app/features/new_booking/data/mock_booking_catalog.dart';
import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:drivado_admin_app/features/new_booking/domain/repositories/booking_catalog_repository.dart';

class MockBookingCatalogRepository implements BookingCatalogRepository {
  @override
  List<String> get locations => MockBookingCatalog.locations;

  @override
  List<String> get durations => MockBookingCatalog.durations;

  @override
  Future<List<VehicleOption>> searchVehicles({
    required bool isOneway,
    required String currency,
    required String pickup,
    String? dropoff,
    String? duration,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (pickup.isEmpty) {
      throw Exception('Pickup location is required');
    }
    return MockBookingCatalog.vehiclesFor(currency);
  }
}
