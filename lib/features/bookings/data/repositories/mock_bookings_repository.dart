import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:drivado_admin_app/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:drivado_admin_app/features/dashboard/domain/entities/dashboard_entities.dart';

class MockBookingsRepository implements BookingsRepository {
  @override
  Future<List<ManagedBooking>> fetchBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    final date = DateTime(2024, 1, 18, 13, 25);

    return [
      ManagedBooking(
        id: 'D0223-6854',
        customer: 'Mr. Khaled abdul rehman',
        pickup: 'J Hotel Tokyo Geo, 3 Chome-1-6 Nihon',
        dropoff: 'J Hotel Tokyo Geo, 3 Chome-1-6 Nihon',
        vehicle: 'LUXURY SEDAN',
        amount: 'USD 234.00',
        status: BookingStatus.confirmed,
        scheduledAt: date,
        tripType: 'Oneway',
        region: BookingRegion.td,
        driverName: 'Reda Julien Ghilana',
        driverPhone: '+91 9876543210',
        distanceLabel: '37 km',
        durationLabel: '2 hr 53 min',
      ),
      ManagedBooking(
        id: 'D0223-6854',
        customer: 'Mr. Khaled abdul rehman',
        pickup: 'J Hotel Tokyo Geo, 3 Chome-1-6 Nihon',
        dropoff: 'J Hotel Tokyo Geo, 3 Chome-1-6 Nihon',
        vehicle: 'LUXURY SEDAN',
        amount: 'USD 234.00',
        status: BookingStatus.confirmed,
        scheduledAt: date,
        tripType: 'Hourly',
        region: BookingRegion.tw,
        driverName: 'Reda Julien Ghilana',
        driverPhone: '+91 9876543210',
        distanceLabel: '37 km',
        durationLabel: '2 hr 53 min',
      ),
      ManagedBooking(
        id: 'D0223-6855',
        customer: 'Mr. Khaled abdul rehman',
        pickup: 'Narita Airport Terminal 1',
        dropoff: 'Shinjuku Station West Exit',
        vehicle: 'LUXURY SEDAN',
        amount: 'USD 198.00',
        status: BookingStatus.confirmed,
        scheduledAt: date.add(const Duration(hours: 3)),
        tripType: 'Oneway',
        region: BookingRegion.ua,
        driverName: 'Reda Julien Ghilana',
        driverPhone: '+91 9876543210',
        distanceLabel: '68 km',
        durationLabel: '1 hr 40 min',
      ),
      ManagedBooking(
        id: 'D0223-6856',
        customer: 'Ms. Aisha Rahman',
        pickup: 'Haneda Airport T3',
        dropoff: 'Ginza Six',
        vehicle: 'BUSINESS VAN',
        amount: 'USD 156.00',
        status: BookingStatus.pending,
        scheduledAt: date.add(const Duration(days: 1)),
        tripType: 'Hourly',
        region: BookingRegion.td,
        driverName: 'Reda Julien Ghilana',
        driverPhone: '+91 9876543210',
        distanceLabel: '22 km',
        durationLabel: '55 min',
      ),
    ];
  }
}
