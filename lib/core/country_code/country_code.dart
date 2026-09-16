import 'package:drivado_admin_app/core/country_code/country_code_data.dart';
import 'package:drivado_admin_app/core/country_code/country_code_model.dart';

export 'package:drivado_admin_app/core/country_code/country_code_data.dart';
export 'package:drivado_admin_app/core/country_code/country_code_model.dart';

CountryCodeModel get defaultCountryCode => countryCodeData.firstWhere(
      (country) => country.code == 'IN',
      orElse: () => countryCodeData.first,
    );

CountryCodeModel? findCountryByDialCode(String dialCode) {
  for (final country in countryCodeData) {
    if (country.dialCode == dialCode) return country;
  }
  return null;
}

(String dialCode, String nationalNumber) splitPhone(String phone) {
  final trimmed = phone.trim();
  final sorted = List<CountryCodeModel>.from(countryCodeData)
    ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));
  for (final country in sorted) {
    if (trimmed.startsWith(country.dialCode)) {
      return (
        country.dialCode,
        trimmed
            .substring(country.dialCode.length)
            .replaceAll(RegExp(r'\D'), ''),
      );
    }
  }
  return ('+91', trimmed.replaceAll(RegExp(r'\D'), ''));
}
