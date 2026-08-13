import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';

abstract class BookingsRepository {
  Future<List<ManagedBooking>> fetchBookings();
}
