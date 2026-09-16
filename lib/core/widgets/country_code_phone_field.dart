import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryCodePhoneField extends StatefulWidget {
  const CountryCodePhoneField({
    super.key,
    required this.controller,
    required this.countryCode,
    required this.onCountryCodeChanged,
    this.label = 'Contact number',
    this.hint = 'Enter your contact number',
    this.hasError = false,
    this.requiredMark = true,
    this.focusNode,
    this.onChanged,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final String label;
  final String hint;
  final bool hasError;
  final bool requiredMark;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  State<CountryCodePhoneField> createState() => _CountryCodePhoneFieldState();
}

class _CountryCodePhoneFieldState extends State<CountryCodePhoneField> {
  late final FocusNode _internalFocus;
  var _focused = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocus;

  @override
  void initState() {
    super.initState();
    _internalFocus = FocusNode();
    _focused = _focusNode.hasFocus;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(CountryCodePhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) return;
    oldWidget.focusNode?.removeListener(_onFocusChange);
    _internalFocus.removeListener(_onFocusChange);
    _focusNode.addListener(_onFocusChange);
    _focused = _focusNode.hasFocus;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _internalFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  Future<void> _pickCode() async {
    final selected = await showCountryCodePicker(
      context,
      selectedDialCode: widget.countryCode,
    );
    if (selected == null || !mounted) return;
    widget.onCountryCodeChanged(selected.dialCode);
  }

  @override
  Widget build(BuildContext context) {
    final picker = CountryCodePickerButton(
      dialCode: widget.countryCode,
      onTap: _pickCode,
    );

    return Container(
      height: 52,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14, right: 14, top: 3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: widget.hasError
              ? AppColors.primary.withValues(alpha: 0.44)
              : AppColors.stroke,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.number,
        textInputAction: widget.textInputAction,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        cursorColor: Colors.black,
        cursorHeight: 15,
        cursorWidth: 1.5,
        onChanged: widget.onChanged,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: AppTextStyles.plus(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textLabel,
        ),
        decoration: InputDecoration(
          filled: false,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          prefixIcon: _focused
              ? null
              : Align(alignment: Alignment.centerLeft, child: picker),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 54,
            minHeight: 44,
            maxWidth: 80,
          ),
          prefix: _focused ? picker : null,
          hintText: widget.hint,
          hintStyle: AppTextStyles.plus(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.fieldHintText,
          ),
          label: Text.rich(
            TextSpan(
              text: widget.label,
              style: AppTextStyles.plus(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.fieldHintText,
              ),
              children: [
                if (widget.requiredMark)
                  TextSpan(
                    text: ' *',
                    style: AppTextStyles.plus(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
