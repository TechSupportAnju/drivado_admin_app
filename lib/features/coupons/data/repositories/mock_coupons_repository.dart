import 'package:drivado_admin_app/features/coupons/data/mock_coupons_store.dart';
import 'package:drivado_admin_app/features/coupons/domain/entities/coupon.dart';
import 'package:drivado_admin_app/features/coupons/domain/repositories/coupons_repository.dart';

class MockCouponsRepository implements CouponsRepository {
  MockCouponsRepository({MockCouponsStore? store})
      : _store = store ?? MockCouponsStore.instance;

  final MockCouponsStore _store;

  @override
  List<Coupon> all() => _store.all();

  @override
  List<Coupon> byType(CouponType type, {String query = ''}) =>
      _store.byType(type, query: query);

  @override
  void upsert(Coupon coupon) => _store.upsert(coupon);

  @override
  void delete(String id) => _store.delete(id);
}
