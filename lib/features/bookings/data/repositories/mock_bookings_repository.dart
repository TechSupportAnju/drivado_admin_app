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
        id: 'D024-15784',
        customer: 'Sumit Modi',
        pickup:
            'J Hotel Tokyo Geo, 3 Chome-1-6 Nihonbashi-Honkokucho, Nihonbashihongokucho, Chuo City, Tokyo 103-0021, Japan',
        dropoff:
            'J Hotel Tokyo Geo, 3 Chome-1-6 Nihonbashi-Honkokucho, Nihonbashihongokucho, Chuo City, Tokyo 103-0021, Japan',
        vehicle: 'STANDARD SEDAN',
        amount: 'USD 234',
        status: BookingStatus.confirmed,
        scheduledAt: date,
        tripType: 'Oneway',
        region: BookingRegion.td,
        driverName: 'Sumit Modi',
        driverPhone: '+917365977561',
        distanceLabel: '37 km',
        durationLabel: '2 hr 53 min',
        passengers: 2,
        customerPhone: '+917365977561',
        customerEmail: 'techsupport3@drivado.com',
        paymentStatus: 'PAID',
        opsStatus: 'POB',
        bookedBy: 'camila.lopez@servantrip.com',
        referenceNumber: '123456789456123789',
        specialRequest: 'I need one water bottle',
        affiliateTo: 'TKC',
        affiliateAt: '25-03-2025 | 12:20 PM',
        assignedBy: 'techsupport11@drivado.com',
        affiliateContact: '+91 9568231547',
        purchasePrice: 'USD 10',
        purchasePriceEdited: true,
        affiliateNote: '',
        carPlate: '',
        createdAt: DateTime(2024, 8, 1),
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
