import 'package:drivado_admin_app/features/affiliates/data/mock_affiliates_store.dart';
import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:drivado_admin_app/features/affiliates/domain/repositories/affiliates_repository.dart';

class MockAffiliatesRepository implements AffiliatesRepository {
  MockAffiliatesRepository({MockAffiliatesStore? store})
      : _store = store ?? MockAffiliatesStore.instance;

  final MockAffiliatesStore _store;

  @override
  List<Affiliate> all() => _store.all();

  @override
  List<Affiliate> search(String query) => _store.search(query);

  @override
  Affiliate? byId(String id) => _store.byId(id);

  @override
  void upsert(Affiliate affiliate) => _store.upsert(affiliate);
}
