import 'package:drivado_admin_app/features/events/data/mock_events_store.dart';
import 'package:drivado_admin_app/features/events/domain/entities/event.dart';
import 'package:drivado_admin_app/features/events/domain/repositories/events_repository.dart';

class MockEventsRepository implements EventsRepository {
  MockEventsRepository({MockEventsStore? store})
      : _store = store ?? MockEventsStore.instance;

  final MockEventsStore _store;

  @override
  List<EventItem> all() => _store.all();

  @override
  List<EventItem> search(String query) => _store.search(query);

  @override
  EventItem? byId(String id) => _store.byId(id);

  @override
  void upsert(EventItem event) => _store.upsert(event);

  @override
  void delete(String id) => _store.delete(id);

  @override
  List<String> get regions => MockEventsStore.regions;

  @override
  List<String> flatRegionsFor(String region) =>
      MockEventsStore.flatRegions[region] ?? const [];
}
