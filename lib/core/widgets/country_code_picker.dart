import 'package:drivado_admin_app/core/country_code/country_code.dart';
import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<CountryCodeModel?> showCountryCodePicker(
  BuildContext context, {
  String? selectedDialCode,
}) {
  return showDialog<CountryCodeModel>(
    context: context,
    builder: (context) => _CountryCodeDialog(
      selectedDialCode: selectedDialCode,
    ),
  );
}

class _CountryCodeDialog extends StatefulWidget {
  const _CountryCodeDialog({this.selectedDialCode});

  final String? selectedDialCode;

  @override
  State<_CountryCodeDialog> createState() => _CountryCodeDialogState();
}

class _CountryCodeDialogState extends State<_CountryCodeDialog> {
  final _search = TextEditingController();
  late List<CountryCodeModel> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List<CountryCodeModel>.from(countryCodeData);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() {
      if (value.isEmpty) {
        _filtered = List<CountryCodeModel>.from(countryCodeData);
        return;
      }
      final query = value.toLowerCase();
      _filtered = countryCodeData
          .where(
            (country) =>
                country.dialCode.contains(value) ||
                country.name.toLowerCase().contains(query) ||
                country.code.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Material(
          color: AppColors.countryPickerBg,
          borderRadius: BorderRadius.circular(5),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const AppSvgIcon(
                      AppIcons.bookingsSearch,
                      size: 18,
                      color: AppColors.fieldIcon,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _search,
                        autofocus: true,
                        cursorColor: Colors.black,
                        cursorHeight: 15,
                        cursorWidth: 1.5,
                        style: AppTextStyles.plus(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLabel,
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Search for countries',
                          hintStyle: AppTextStyles.plus(
                            fontSize: 14,
                            color: const Color(0xFF828282),
                          ),
                        ),
                        onChanged: _onSearch,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final country = _filtered[index];
                    final selected =
                        country.dialCode == widget.selectedDialCode;
                    return Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(country),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              CountryFlagImage(country: country),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Text(
                                  country.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.plus(
                                    color: Colors.black,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                country.dialCode,
                                style: AppTextStyles.plus(
                                  color: Colors.black,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountryFlagImage extends StatelessWidget {
  const CountryFlagImage({super.key, required this.country, this.size = 24});

  final CountryCodeModel country;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: SvgPicture.network(
          country.flagUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholderBuilder: (_) => Center(
            child: Text(country.emoji, style: TextStyle(fontSize: size * 0.7)),
          ),
        ),
      ),
    );
  }
}

class CountryCodePickerButton extends StatelessWidget {
  const CountryCodePickerButton({
    super.key,
    required this.dialCode,
    required this.onTap,
  });

  final String dialCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        width: dialCode.length > 4
            ? 69
            : dialCode.length > 3
                ? 60
                : 54,
        child: Row(
          children: [
            Text(
              dialCode,
              style: AppTextStyles.plus(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.countryCodeText,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.expand_more_sharp,
              color: AppColors.fieldIcon,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
