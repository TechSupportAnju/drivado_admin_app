import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';

abstract final class MockBookingCatalog {
  static const locations = [
    'Heathrow Airport (LHR), London',
    'Gatwick Airport (LGW), London',
    'London City Centre',
    'Manchester Airport (MAN)',
    'Dubai International Airport (DXB)',
    'Paris Charles de Gaulle (CDG)',
    'Abu Dhabi International Airport (AUH)',
    'Singapore Changi Airport (SIN)',
  ];

  static const durations = [
    '1 Hour / 20km',
    '2 Hour / 40km',
    '3 Hour / 60km',
    '4 Hour / 80km',
    '6 Hour / 120km',
    '8 Hour / 160km',
    '10 Hour / 200km',
    '12 Hour / 240km',
  ];

  static List<VehicleOption> vehiclesFor(String currency) {
    return [
      VehicleOption(
        id: 'standard_sedan',
        vehicleType: 'Standard Sedan',
        description:
            'Corolla, Toyota Prius, Camry, Ford Taurus or similar',
        passengerCount: 3,
        luggageCount: 2,
        price: 85,
        unit: currency,
        imageUrl:
            'https://www.figma.com/api/mcp/asset/70a7384b-13b4-4cdb-878f-6a425e9bcb74.png',
      ),
      VehicleOption(
        id: 'premium_sedan',
        vehicleType: 'Premium Sedan',
        description:
            'Mercedes E Class, BMW 5 Series, Audi A6, VW Passat, Lexus or similar',
        passengerCount: 3,
        luggageCount: 2,
        price: 85,
        unit: currency,
        imageUrl:
            'https://www.figma.com/api/mcp/asset/284f388e-c2d3-4643-b720-87690640163d.png',
      ),
      VehicleOption(
        id: 'economy_van',
        vehicleType: 'Economy Van',
        description:
            'Opel Vivaro, Ford, Volkswagen Caravelle, Honda Odyssey or similar',
        passengerCount: 5,
        luggageCount: 5,
        price: 85,
        unit: currency,
        imageUrl:
            'https://www.figma.com/api/mcp/asset/eb99271d-72ec-482f-b118-61f463c06ddf.png',
      ),
      VehicleOption(
        id: 'premium_van',
        vehicleType: 'Premium Van',
        description:
            'Mercedes Viano/V Class, Cadillac Escalade, Toyota Alphard, Chevrolet Suburban, GMC or similar',
        passengerCount: 5,
        luggageCount: 5,
        price: 85,
        unit: currency,
        imageUrl:
            'https://www.figma.com/api/mcp/asset/220964f5-ce7f-4415-85fc-41d4f797b5a3.png',
      ),
      VehicleOption(
        id: 'luxury_sedan',
        vehicleType: 'Luxury Sedan',
        description: 'Mercedes S Class, BMW 7 Series, Audi A8 or similar',
        passengerCount: 3,
        luggageCount: 2,
        price: 85,
        unit: currency,
        imageUrl:
            'https://www.figma.com/api/mcp/asset/383e754c-40a1-4541-a30a-35963c8e19c4.png',
      ),
    ];
  }
}
