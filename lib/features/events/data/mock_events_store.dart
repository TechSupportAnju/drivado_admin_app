import 'package:drivado_admin_app/features/events/domain/entities/event.dart';

/// In-memory event store for UI demo flows.
class MockEventsStore {
  MockEventsStore._();

  static final instance = MockEventsStore._();

  static const regions = [
    'London',
    'Tokyo',
    'Las Vegas',
    'Abu Dhabi',
    'Manchester',
  ];

  static const Map<String, List<String>> flatRegions = {
    'London': ['Flatregion', 'Westminster', 'Camden'],
    'Tokyo': ['Kanto', 'Kansai', 'Hokkaido'],
    'Las Vegas': ['Strip', 'Downtown'],
    'Abu Dhabi': ['City Centre', 'Yas Island'],
    'Manchester': ['Northern Quarter', 'Deansgate'],
  };

  final List<EventItem> _items = [
    EventItem(
      id: 'e1',
      name: 'FIFA London',
      region: 'London',
      flatRegion: 'Flatregion',
      startDate: DateTime(2026, 6, 23),
      endDate: DateTime(2026, 7, 24),
      markup: '85%',
      blackout: true,
    ),
    EventItem(
      id: 'e2',
      name: 'Tokyo Marathon',
      region: 'Tokyo',
      flatRegion: 'Kanto',
      startDate: DateTime(2026, 3, 10),
      endDate: DateTime(2026, 3, 10),
      markup: '60%',
    ),
    EventItem(
      id: 'e3',
      name: 'CES Las Vegas',
      region: 'Las Vegas',
      flatRegion: 'Strip',
      startDate: DateTime(2026, 1, 7),
      endDate: DateTime(2026, 1, 10),
      markup: '40%',
    ),
    EventItem(
      id: 'e4',
      name: 'F1 Abu Dhabi',
      region: 'Abu Dhabi',
      flatRegion: 'Yas Island',
      startDate: DateTime(2026, 11, 20),
      endDate: DateTime(2026, 11, 22),
      markup: '75%',
      blackout: true,
    ),
    EventItem(
      id: 'e5',
      name: 'Manchester Pride',
      region: 'Manchester',
      flatRegion: 'Northern Quarter',
      startDate: DateTime(2026, 8, 22),
      endDate: DateTime(2026, 8, 24),
      markup: '50%',
    ),
  ];

  List<EventItem> all() => List.unmodifiable(_items);

  List<EventItem> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all();
    return _items.where((e) {
      return e.name.toLowerCase().contains(q) ||
          e.region.toLowerCase().contains(q) ||
          e.flatRegion.toLowerCase().contains(q) ||
          e.locationLabel.toLowerCase().contains(q);
    }).toList();
  }

  EventItem? byId(String id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void upsert(EventItem event) {
    final index = _items.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      _items[index] = event;
    } else {
      _items.insert(0, event);
    }
  }

  void delete(String id) {
    _items.removeWhere((e) => e.id == id);
  }
}
