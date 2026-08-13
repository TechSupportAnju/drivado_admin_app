import 'package:drivado_admin_app/features/dashboard/domain/entities/dashboard_entities.dart';
import 'package:drivado_admin_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardSnapshot> fetchDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final date = DateTime(2025, 12, 5);

    return DashboardSnapshot(
      kpis: const [
        DashboardKpi(
          label: 'Total Booking',
          value: '1235',
          deltaLabel: '',
          isPositive: true,
        ),
      ],
      recentBookings: [
        BookingSummary(
          id: 'D0624-6478',
          customer: 'Sanjay',
          route: 'Airport Transfer',
          vehicle: 'Sedan',
          amount: '\$120',
          status: BookingStatus.confirmed,
          scheduledAt: date,
        ),
        BookingSummary(
          id: 'D0624-6478',
          customer: 'Sanjay',
          route: 'City Transfer',
          vehicle: 'Sedan',
          amount: '\$90',
          status: BookingStatus.completed,
          scheduledAt: date,
        ),
        BookingSummary(
          id: 'D0624-6478',
          customer: 'Sanjay',
          route: 'Hourly',
          vehicle: 'Van',
          amount: '\$150',
          status: BookingStatus.cancelled,
          scheduledAt: date,
        ),
        BookingSummary(
          id: 'D0624-6478',
          customer: 'Sanjay',
          route: 'Airport Transfer',
          vehicle: 'Sedan',
          amount: '\$120',
          status: BookingStatus.confirmed,
          scheduledAt: date,
        ),
        BookingSummary(
          id: 'D0624-6478',
          customer: 'Sanjay',
          route: 'Airport Transfer',
          vehicle: 'Sedan',
          amount: '\$120',
          status: BookingStatus.confirmed,
          scheduledAt: date,
        ),
        BookingSummary(
          id: 'D0624-6478',
          customer: 'Sanjay',
          route: 'Hourly',
          vehicle: 'Van',
          amount: '\$150',
          status: BookingStatus.cancelled,
          scheduledAt: date,
        ),
      ],
    );
  }
}
