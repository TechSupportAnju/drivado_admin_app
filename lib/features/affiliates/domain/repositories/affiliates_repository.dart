import 'package:drivado_admin_app/features/affiliates/domain/entities/affiliate.dart';

abstract class AffiliatesRepository {
  List<Affiliate> all();
  List<Affiliate> search(String query);
  Affiliate? byId(String id);
  void upsert(Affiliate affiliate);
}
