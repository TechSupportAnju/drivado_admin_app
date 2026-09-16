class CountryCodeModel {
  CountryCodeModel({
    required this.name,
    required this.code,
    required this.emoji,
    required this.unicode,
    required this.image,
    required this.dialCode,
  });

  final String name;
  final String code;
  final String emoji;
  final String unicode;
  final String image;
  final String dialCode;

  String get flagUrl => 'https://country-code-au6g.vercel.app/$image';
}
