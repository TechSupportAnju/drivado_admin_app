import 'package:drivado_admin_app/features/coupons/domain/entities/coupon.dart';

abstract class CouponsRepository {
  List<Coupon> all();
  List<Coupon> byType(CouponType type, {String query = ''});
  void upsert(Coupon coupon);
  void delete(String id);
}
