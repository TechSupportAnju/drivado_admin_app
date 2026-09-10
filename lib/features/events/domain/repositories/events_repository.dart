import 'package:drivado_admin_app/features/events/domain/entities/event.dart';

abstract class EventsRepository {
  List<EventItem> all();
  List<EventItem> search(String query);
  EventItem? byId(String id);
  void upsert(EventItem event);
  void delete(String id);
  List<String> get regions;
  List<String> flatRegionsFor(String region);
}
