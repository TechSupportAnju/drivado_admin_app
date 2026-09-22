import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';

class MockAffiliatesStore {
  MockAffiliatesStore._();

  static final instance = MockAffiliatesStore._();

  final List<Affiliate> _items = [
    const Affiliate(
      id: 'a1',
      name: 'Wanderlust Travel Co.',
      contactPerson: 'Sanjay Das',
      affiliateId: 'Rtha',
      password: '********',
      email1: 'techsupport11@drivado.com',
      email2: 'techsupport3@drivado.com',
      phone1: '9547881261',
      phone2: '9876543210',
      phone3: '9756842632',
      countryCode1: '+91',
      countryCode2: '+91',
      countryCode3: '+91',
      address:
          'Netaji Subhash Chandra Bose International Airport (CCU), Dum Dum',
      city: 'Kolkata, West Bengal',
      country: 'India',
      active: true,
      initials: 'W',
      logoColor: 0xFF1A365D,
      locations:
          'Paris, Rome, Barcelona, Lisbon, Berlin, Amsterdam, Budapest, Prague',
    ),
    const Affiliate(
      id: 'a2',
      name: 'Globetrotter Ventures',
      contactPerson: 'Maria Gomez',
      affiliateId: '551119972002',
      password: '********',
      email1: 'support@globetrotter.com',
      email2: 'ops@globetrotter.com',
      phone1: '9123456780',
      phone2: '9123456781',
      phone3: '',
      address: '123 Baker Street, Marylebone, London',
      city: 'London',
      country: 'United Kingdom',
      active: false,
      initials: 'G',
      logoColor: 0xFF0F766E,
      locations: 'London, Manchester, Edinburgh, Dublin, Brussels, Amsterdam',
    ),
    const Affiliate(
      id: 'a3',
      name: 'Horizon Getaways',
      contactPerson: 'Li Wei',
      affiliateId: '551119972003',
      password: '********',
      email1: 'hello@horizon.com',
      email2: '',
      phone1: '9988776655',
      phone2: '',
      phone3: '',
      address: 'Champs-Élysées 42, Paris',
      city: 'Paris',
      country: 'France',
      active: true,
      initials: 'H',
      logoColor: 0xFF7C2D12,
      locations: 'Paris, Lyon, Nice, Geneva, Milan, Barcelona',
    ),
    const Affiliate(
      id: 'a4',
      name: 'Atlas Partner Group',
      contactPerson: 'Aisha Khan',
      affiliateId: '551119972004',
      password: '********',
      email1: 'partners@atlas.com',
      email2: 'desk@atlas.com',
      phone1: '9001122334',
      phone2: '9001122335',
      phone3: '9001122336',
      address: 'Friedrichstraße 88, Berlin',
      city: 'Berlin',
      country: 'Germany',
      active: true,
      initials: 'A',
      logoColor: 0xFF1E3A8A,
      locations: 'Berlin, Munich, Hamburg, Vienna, Prague, Warsaw',
    ),
    const Affiliate(
      id: 'a5',
      name: 'Summit Chauffeur Ltd.',
      contactPerson: 'Tomoko Tanaka',
      affiliateId: '551119972005',
      password: '********',
      email1: 'book@summit.com',
      email2: '',
      phone1: '8800112233',
      phone2: '',
      phone3: '',
      address: '5th Avenue 200, New York',
      city: 'New York',
      country: 'United States',
      active: false,
      initials: 'S',
      logoColor: 0xFF4A044E,
      locations: 'New York, Boston, Chicago, Miami, Toronto, Montreal',
    ),
    const Affiliate(
      id: 'a6',
      name: 'Pacific Route Agency',
      contactPerson: 'Carlos Mendoza',
      affiliateId: '551119972006',
      password: '********',
      email1: 'agency@pacific.com',
      email2: 'ops@pacific.com',
      phone1: '7700998877',
      phone2: '7700998878',
      phone3: '',
      address: 'Harbour Bridge Plaza, Sydney',
      city: 'Sydney',
      country: 'Australia',
      active: true,
      initials: 'P',
      logoColor: 0xFF164E63,
      locations: 'Sydney, Melbourne, Brisbane, Auckland, Singapore, Tokyo',
    ),
  ];

  List<Affiliate> all() => List.unmodifiable(_items);

  List<Affiliate> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all();
    return _items.where((a) {
      return a.name.toLowerCase().contains(q) ||
          a.contactPerson.toLowerCase().contains(q) ||
          a.city.toLowerCase().contains(q) ||
          a.country.toLowerCase().contains(q) ||
          a.affiliateId.toLowerCase().contains(q);
    }).toList();
  }

  Affiliate? byId(String id) {
    try {
      return _items.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  void upsert(Affiliate affiliate) {
    final index = _items.indexWhere((a) => a.id == affiliate.id);
    if (index >= 0) {
      _items[index] = affiliate;
    } else {
      _items.insert(0, affiliate);
    }
  }
}
