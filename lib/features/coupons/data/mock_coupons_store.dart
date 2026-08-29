import 'package:drivado_admin_app/features/coupons/domain/entities/coupon.dart';

/// In-memory coupon store for UI demo flows.
class MockCouponsStore {
  MockCouponsStore._();

  static final instance = MockCouponsStore._();

  final List<Coupon> _items = [
    Coupon(
      id: 'c1',
      code: 'DRIVEAMEX20',
      type: CouponType.oneTime,
      discount: '85%',
      bankName: 'Amex',
      card: 'Amex',
      microsite: 'american-express-card-offer',
      network: 'american-express-card-offers',
      thresholdPrice: 'USD 20203',
      startDate: DateTime(2024, 6, 27),
      expiryDate: DateTime(2024, 12, 31),
      prefix: 'DRIVEAMEX',
      count: 20,
    ),
    Coupon(
      id: 'c2',
      code: 'SUMMER15',
      type: CouponType.oneTime,
      discount: '15%',
      bankName: 'Wells Fargo',
      card: 'Visa',
      microsite: 'summer-travel-offer',
      network: 'wells-fargo-card-offers',
      thresholdPrice: 'USD 23',
      startDate: DateTime(2024, 5, 1),
      expiryDate: DateTime(2024, 8, 31),
      prefix: 'SUMMER',
      count: 15,
    ),
    Coupon(
      id: 'u1',
      code: 'HDFCBANK20',
      type: CouponType.unlimited,
      discount: '20%',
      bankName: 'HDFC',
      card: 'Visa',
      microsite: 'hdfc-bank-card-offer',
      network: 'hdfc-partner-network',
      thresholdPrice: 'USD 500',
      startDate: DateTime(2024, 1, 1),
      expiryDate: DateTime(2025, 1, 1),
    ),
    Coupon(
      id: 'u2',
      code: 'LOYALTY10',
      type: CouponType.unlimited,
      discount: '10%',
      bankName: 'Amex',
      card: 'Amex',
      microsite: 'loyalty-member-offer',
      network: 'amex-loyalty-network',
      thresholdPrice: 'USD 150',
      startDate: DateTime(2024, 2, 15),
      expiryDate: DateTime(2025, 2, 15),
    ),
  ];

  List<Coupon> all() => List.unmodifiable(_items);

  List<Coupon> byType(CouponType type, {String query = ''}) {
    final q = query.trim().toLowerCase();
    return _items.where((c) {
      if (c.type != type) return false;
      if (q.isEmpty) return true;
      return c.code.toLowerCase().contains(q) ||
          c.bankName.toLowerCase().contains(q) ||
          c.card.toLowerCase().contains(q) ||
          c.microsite.toLowerCase().contains(q) ||
          c.network.toLowerCase().contains(q);
    }).toList();
  }

  void upsert(Coupon coupon) {
    final index = _items.indexWhere((c) => c.id == coupon.id);
    if (index >= 0) {
      _items[index] = coupon;
    } else {
      _items.insert(0, coupon);
    }
  }

  void delete(String id) {
    _items.removeWhere((c) => c.id == id);
  }
}
