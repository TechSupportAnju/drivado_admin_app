class Affiliate {
  const Affiliate({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.affiliateId,
    required this.password,
    required this.email1,
    required this.email2,
    required this.phone1,
    required this.phone2,
    required this.phone3,
    required this.address,
    required this.city,
    required this.country,
    required this.active,
    this.locations = '',
    this.photoPath,
    this.countryCode1 = '+91',
    this.countryCode2 = '+91',
    this.countryCode3 = '+91',
    this.initials = '',
    this.logoColor = 0xFF1B4F72,
  });

  final String id;
  final String name;
  final String contactPerson;
  final String affiliateId;
  final String password;
  final String email1;
  final String email2;
  final String phone1;
  final String phone2;
  final String phone3;
  final String countryCode1;
  final String countryCode2;
  final String countryCode3;
  final String address;
  final String city;
  final String country;
  final bool active;
  final String locations;
  final String? photoPath;
  final String initials;
  final int logoColor;

  String get displayInitials {
    if (initials.isNotEmpty) return initials;
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'A';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  /// Kept for list-card city chips (comma-separated display).
  String get locationsLabel {
    if (locations.trim().isNotEmpty) return locations.trim();
    final parts = <String>[
      if (city.trim().isNotEmpty) city.trim(),
      if (country.trim().isNotEmpty) country.trim(),
    ];
    return parts.join(', ');
  }

  String get primaryPhone {
    final digits = phone1.trim();
    if (digits.isEmpty) return '—';
    return '$countryCode1 $digits';
  }

  List<String> get emails {
    return [
      if (email1.trim().isNotEmpty) email1.trim(),
      if (email2.trim().isNotEmpty) email2.trim(),
    ];
  }

  List<String> get phones {
    final list = <String>[];
    if (phone1.trim().isNotEmpty) list.add('$countryCode1 ${phone1.trim()}');
    if (phone2.trim().isNotEmpty) list.add('$countryCode2 ${phone2.trim()}');
    if (phone3.trim().isNotEmpty) list.add('$countryCode3 ${phone3.trim()}');
    return list;
  }

  Affiliate copyWith({
    String? id,
    String? name,
    String? contactPerson,
    String? affiliateId,
    String? password,
    String? email1,
    String? email2,
    String? phone1,
    String? phone2,
    String? phone3,
    String? countryCode1,
    String? countryCode2,
    String? countryCode3,
    String? address,
    String? city,
    String? country,
    bool? active,
    String? locations,
    String? photoPath,
    bool clearPhoto = false,
    String? initials,
    int? logoColor,
  }) {
    return Affiliate(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      affiliateId: affiliateId ?? this.affiliateId,
      password: password ?? this.password,
      email1: email1 ?? this.email1,
      email2: email2 ?? this.email2,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      phone3: phone3 ?? this.phone3,
      countryCode1: countryCode1 ?? this.countryCode1,
      countryCode2: countryCode2 ?? this.countryCode2,
      countryCode3: countryCode3 ?? this.countryCode3,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      active: active ?? this.active,
      locations: locations ?? this.locations,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      initials: initials ?? this.initials,
      logoColor: logoColor ?? this.logoColor,
    );
  }
}
