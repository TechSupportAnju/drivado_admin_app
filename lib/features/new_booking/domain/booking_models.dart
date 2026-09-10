import 'package:equatable/equatable.dart';

class VehicleOption extends Equatable {
  const VehicleOption({
    required this.id,
    required this.vehicleType,
    required this.description,
    required this.passengerCount,
    required this.luggageCount,
    required this.price,
    required this.unit,
    this.imageUrl,
  });

  final String id;
  final String vehicleType;
  final String description;
  final int passengerCount;
  final int luggageCount;
  final int price;
  final String unit;
  final String? imageUrl;

  String get priceLabel => '$unit $price';

  @override
  List<Object?> get props => [id, vehicleType, price, unit];
}

class PassengerInfo {
  const PassengerInfo({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.countryCode = '+91',
    this.flightNo = '',
    this.specialRequest = '',
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String countryCode;
  final String flightNo;
  final String specialRequest;

  String get fullName => '$firstName $lastName'.trim();
}

class BookingDraft {
  const BookingDraft({
    required this.isOneway,
    required this.pickup,
    required this.dateLabel,
    required this.timeLabel,
    required this.passengers,
    required this.currency,
    this.dropoff,
    this.duration,
    this.distanceKm = '32 km',
    this.routeDuration = '45 mins',
    this.vehicle,
    this.passenger,
  });

  final bool isOneway;
  final String pickup;
  final String? dropoff;
  final String? duration;
  final String dateLabel;
  final String timeLabel;
  final int passengers;
  final String currency;
  final String distanceKm;
  final String routeDuration;
  final VehicleOption? vehicle;
  final PassengerInfo? passenger;

  String get destination => isOneway ? (dropoff ?? '') : pickup;

  BookingDraft copyWith({
    VehicleOption? vehicle,
    PassengerInfo? passenger,
    String? distanceKm,
    String? routeDuration,
  }) {
    return BookingDraft(
      isOneway: isOneway,
      pickup: pickup,
      dropoff: dropoff,
      duration: duration,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      passengers: passengers,
      currency: currency,
      distanceKm: distanceKm ?? this.distanceKm,
      routeDuration: routeDuration ?? this.routeDuration,
      vehicle: vehicle ?? this.vehicle,
      passenger: passenger ?? this.passenger,
    );
  }
}
