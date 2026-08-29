enum CouponType { oneTime, unlimited }

class Coupon {
  const Coupon({
    required this.id,
    required this.code,
    required this.type,
    required this.discount,
    required this.bankName,
    required this.card,
    required this.microsite,
    required this.network,
    required this.thresholdPrice,
    required this.startDate,
    required this.expiryDate,
    this.prefix = '',
    this.count,
  });

  final String id;
  final String code;
  final CouponType type;
  final String discount;
  final String bankName;
  final String card;
  final String microsite;
  final String network;
  final String thresholdPrice;
  final DateTime startDate;
  final DateTime expiryDate;
  final String prefix;
  final int? count;

  Coupon copyWith({
    String? id,
    String? code,
    CouponType? type,
    String? discount,
    String? bankName,
    String? card,
    String? microsite,
    String? network,
    String? thresholdPrice,
    DateTime? startDate,
    DateTime? expiryDate,
    String? prefix,
    int? count,
  }) {
    return Coupon(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      discount: discount ?? this.discount,
      bankName: bankName ?? this.bankName,
      card: card ?? this.card,
      microsite: microsite ?? this.microsite,
      network: network ?? this.network,
      thresholdPrice: thresholdPrice ?? this.thresholdPrice,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      prefix: prefix ?? this.prefix,
      count: count ?? this.count,
    );
  }
}
