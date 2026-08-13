import 'package:equatable/equatable.dart';

enum BookingStatus { confirmed, pending, cancelled, completed }

class DashboardKpi extends Equatable {
  const DashboardKpi({
    required this.label,
    required this.value,
    required this.deltaLabel,
    required this.isPositive,
  });

  final String label;
  final String value;
  final String deltaLabel;
  final bool isPositive;

  @override
  List<Object?> get props => [label, value, deltaLabel, isPositive];
}

class BookingSummary extends Equatable {
  const BookingSummary({
    required this.id,
    required this.customer,
    required this.route,
    required this.vehicle,
    required this.amount,
    required this.status,
    required this.scheduledAt,
  });

  final String id;
  final String customer;
  final String route;
  final String vehicle;
  final String amount;
  final BookingStatus status;
  final DateTime scheduledAt;

  @override
  List<Object?> get props =>
      [id, customer, route, vehicle, amount, status, scheduledAt];
}

class DashboardSnapshot extends Equatable {
  const DashboardSnapshot({
    required this.kpis,
    required this.recentBookings,
  });

  final List<DashboardKpi> kpis;
  final List<BookingSummary> recentBookings;

  @override
  List<Object?> get props => [kpis, recentBookings];
}
