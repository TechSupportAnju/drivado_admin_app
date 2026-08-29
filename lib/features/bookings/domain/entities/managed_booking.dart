import 'package:drivado_admin_app/features/dashboard/domain/entities/dashboard_entities.dart';
import 'package:equatable/equatable.dart';

enum BookingFilterTab { all, td, tw, ua }

extension BookingFilterTabX on BookingFilterTab {
  String get label => switch (this) {
        BookingFilterTab.all => 'All',
        BookingFilterTab.td => 'TD',
        BookingFilterTab.tw => 'TW',
        BookingFilterTab.ua => 'UA',
      };

  bool matches(ManagedBooking booking) => switch (this) {
        BookingFilterTab.all => true,
        BookingFilterTab.td => booking.region == BookingRegion.td,
        BookingFilterTab.tw => booking.region == BookingRegion.tw,
        BookingFilterTab.ua => booking.region == BookingRegion.ua,
      };
}

enum BookingRegion { td, tw, ua }

class ManagedBooking extends Equatable {
  const ManagedBooking({
    required this.id,
    required this.customer,
    required this.pickup,
    required this.dropoff,
    required this.vehicle,
    required this.amount,
    required this.status,
    required this.scheduledAt,
    required this.tripType,
    required this.region,
    required this.driverName,
    required this.driverPhone,
    required this.distanceLabel,
    required this.durationLabel,
    this.passengers = 1,
    this.customerPhone = '',
    this.customerEmail = '',
    this.paymentStatus = 'PAID',
    this.opsStatus = 'POB',
    this.bookedBy = 'Admin',
    this.referenceNumber = '—',
    this.specialRequest = '—',
    this.affiliateTo = '',
    this.affiliateAt = '',
    this.assignedBy = '',
    this.affiliateContact = '',
    this.purchasePrice = '',
    this.purchasePriceEdited = false,
    this.affiliateNote = '',
    this.carPlate = '',
    this.createdAt,
  });

  final String id;
  final String customer;
  final String pickup;
  final String dropoff;
  final String vehicle;
  final String amount;
  final BookingStatus status;
  final DateTime scheduledAt;
  final String tripType;
  final BookingRegion region;
  final String driverName;
  final String driverPhone;
  final String distanceLabel;
  final String durationLabel;
  final int passengers;
  final String customerPhone;
  final String customerEmail;
  final String paymentStatus;
  final String opsStatus;
  final String bookedBy;
  final String referenceNumber;
  final String specialRequest;
  final String affiliateTo;
  final String affiliateAt;
  final String assignedBy;
  final String affiliateContact;
  final String purchasePrice;
  final bool purchasePriceEdited;
  final String affiliateNote;
  final String carPlate;
  final DateTime? createdAt;

  String get route => '$pickup → $dropoff';

  String get metaLabel => '$distanceLabel | $durationLabel';

  String get passengerCountLabel =>
      '${passengers.toString().padLeft(2, '0')} Pax';

  BookingSummary toSummary() => BookingSummary(
        id: id,
        customer: customer,
        route: route,
        vehicle: vehicle,
        amount: amount,
        status: status,
        scheduledAt: scheduledAt,
      );

  @override
  List<Object?> get props => [
        id,
        customer,
        pickup,
        dropoff,
        vehicle,
        amount,
        status,
        scheduledAt,
        tripType,
        region,
        driverName,
        driverPhone,
        distanceLabel,
        durationLabel,
        passengers,
        customerPhone,
        customerEmail,
        paymentStatus,
        opsStatus,
        bookedBy,
        referenceNumber,
        specialRequest,
        affiliateTo,
        affiliateAt,
        assignedBy,
        affiliateContact,
        purchasePrice,
        purchasePriceEdited,
        affiliateNote,
        carPlate,
        createdAt,
      ];
}
