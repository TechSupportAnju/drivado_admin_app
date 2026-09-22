import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

const _fieldBorder = Color(0xFFD7D8E0);
const _errorBorder = Color(0xFFFFCBCF);
const _hintFill = Color(0xFFBFC1CC);
const _activeGreen = Color(0xFF098C31);

TextStyle get _labelStyle => AppTextStyles.plus(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 16 / 12,
    );

TextStyle get _emptyLabelStyle => AppTextStyles.plus(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 16 / 14,
    );

TextStyle get _valueStyle => AppTextStyles.plus(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 16 / 14,
    );

TextStyle get _placeholderStyle => AppTextStyles.plus(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: _hintFill,
      height: 16 / 14,
    );

InlineSpan _starSpan(TextStyle base, {required bool requiredMark}) {
  if (!requiredMark) return const TextSpan();
  return TextSpan(
    text: '*',
    style: base.copyWith(color: AppColors.primary),
  );
}

class AffiliateFieldError extends StatelessWidget {
  const AffiliateFieldError({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          message!,
          style: AppTextStyles.plus(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
            height: 16 / 10,
          ),
        ),
      ),
    );
  }
}

class AffiliateInputField extends StatefulWidget {
  const AffiliateInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.hasError,
    this.requiredMark = true,
    this.maxLines = 1,
    this.minHeight,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String icon;
  final bool hasError;
  final bool requiredMark;
  final int maxLines;
  final double? minHeight;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  State<AffiliateInputField> createState() => _AffiliateInputFieldState();
}

class _AffiliateInputFieldState extends State<AffiliateInputField> {
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(_rebuild);
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    _focus
      ..removeListener(_rebuild)
      ..dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  bool get _expanded =>
      widget.maxLines > 1 ||
      _focus.hasFocus ||
      widget.controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final multiline = widget.maxLines > 1;
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight ?? 52,
      ),
      height: multiline ? null : 52,
      padding: EdgeInsets.fromLTRB(16, multiline ? 10 : 0, 16, multiline ? 10 : 0),
      alignment: multiline ? Alignment.topLeft : Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.hasError ? _errorBorder : _fieldBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: multiline ? 8 : 0),
            child: AppSvgIcon(widget.icon, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _expanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize:
                        multiline ? MainAxisSize.min : MainAxisSize.max,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: widget.label,
                          style: _labelStyle,
                          children: [
                            _starSpan(_labelStyle, requiredMark: widget.requiredMark),
                          ],
                        ),
                      ),
                      TextField(
                        controller: widget.controller,
                        focusNode: _focus,
                        maxLines: widget.maxLines,
                        keyboardType: widget.keyboardType,
                        onChanged: widget.onChanged,
                        cursorColor: Colors.black,
                        cursorHeight: 14,
                        cursorWidth: 1.5,
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        style: _valueStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: widget.hint,
                          hintStyle: _placeholderStyle,
                        ),
                      ),
                    ],
                  )
                : TextField(
                    controller: widget.controller,
                    focusNode: _focus,
                    maxLines: 1,
                    keyboardType: widget.keyboardType,
                    onChanged: widget.onChanged,
                    cursorColor: Colors.black,
                    cursorHeight: 14,
                    cursorWidth: 1.5,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    style: _valueStyle,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: null,
                      label: Text.rich(
                        TextSpan(
                          text: widget.label,
                          style: _emptyLabelStyle,
                          children: [
                            _starSpan(
                              _emptyLabelStyle,
                              requiredMark: widget.requiredMark,
                            ),
                          ],
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class AffiliatePhoneField extends StatefulWidget {
  const AffiliatePhoneField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.countryCode,
    required this.onCountryCodeChanged,
    this.hasError = false,
    this.requiredMark = true,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final bool hasError;
  final bool requiredMark;
  final ValueChanged<String>? onChanged;

  @override
  State<AffiliatePhoneField> createState() => _AffiliatePhoneFieldState();
}

class _AffiliatePhoneFieldState extends State<AffiliatePhoneField> {
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(_rebuild);
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    _focus
      ..removeListener(_rebuild)
      ..dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  bool get _expanded => _focus.hasFocus || widget.controller.text.isNotEmpty;

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
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.hasError ? _errorBorder : _fieldBorder,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _pickCode,
            child: Row(
              children: [
                Text(
                  widget.countryCode,
                  style: AppTextStyles.plus(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _expanded
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                const AppSvgIcon(
                  AppIcons.affiliateChevronDown,
                  width: 8,
                  height: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _expanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: widget.label,
                          style: _labelStyle,
                          children: [
                            _starSpan(
                              _labelStyle,
                              requiredMark: widget.requiredMark,
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: widget.controller,
                        focusNode: _focus,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: widget.onChanged,
                        cursorColor: Colors.black,
                        cursorHeight: 14,
                        cursorWidth: 1.5,
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        style: _valueStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: widget.hint,
                          hintStyle: _placeholderStyle,
                        ),
                      ),
                    ],
                  )
                : TextField(
                    controller: widget.controller,
                    focusNode: _focus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: widget.onChanged,
                    cursorColor: Colors.black,
                    cursorHeight: 14,
                    cursorWidth: 1.5,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    style: _valueStyle,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.requiredMark
                          ? null
                          : widget.hint,
                      hintStyle: _emptyLabelStyle,
                      label: widget.requiredMark
                          ? Text.rich(
                              TextSpan(
                                text: widget.hint,
                                style: _emptyLabelStyle,
                                children: [
                                  _starSpan(
                                    _emptyLabelStyle,
                                    requiredMark: true,
                                  ),
                                ],
                              ),
                            )
                          : null,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class AffiliateDropdownField extends StatelessWidget {
  const AffiliateDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.hasError,
    this.value,
    this.valueColor = AppColors.textPrimary,
    this.requiredMark = true,
  });

  final String label;
  final String icon;
  final String? value;
  final bool hasError;
  final bool requiredMark;
  final Color valueColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError ? _errorBorder : _fieldBorder,
            ),
          ),
          child: Row(
            children: [
              AppSvgIcon(icon, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: filled
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: label,
                              style: _labelStyle,
                              children: [
                                _starSpan(
                                  _labelStyle,
                                  requiredMark: requiredMark,
                                ),
                              ],
                            ),
                          ),
                          AppText(
                            value!,
                            style: AppTextStyles.bodyStrong,
                            size: 14,
                            color: valueColor,
                            weight: FontWeight.w500,
                            height: 16 / 14,
                          ),
                        ],
                      )
                    : Text.rich(
                        TextSpan(
                          text: label,
                          style: _emptyLabelStyle,
                          children: [
                            _starSpan(
                              _emptyLabelStyle,
                              requiredMark: requiredMark,
                            ),
                          ],
                        ),
                      ),
              ),
              const AppSvgIcon(
                AppIcons.affiliateChevronDown,
                width: 13,
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<ImageSource?> showChangeProfileSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                'Change profile',
                style: AppTextStyles.bodyStrong,
                size: 16,
                weight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileSourceAction(
                    icon: Icons.photo_camera_outlined,
                    label: 'Camera',
                    onTap: () =>
                        Navigator.of(sheetContext).pop(ImageSource.camera),
                  ),
                  _ProfileSourceAction(
                    icon: Icons.photo_outlined,
                    label: 'Gallery',
                    onTap: () =>
                        Navigator.of(sheetContext).pop(ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ProfileSourceAction extends StatelessWidget {
  const _ProfileSourceAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppColors.textSecondary),
            const SizedBox(height: 8),
            AppText(
              label,
              style: AppTextStyles.caption,
              size: 12,
              color: AppColors.textSecondary,
              weight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showAffiliateSearchPicker(
  BuildContext context, {
  required String searchHint,
  required List<String> options,
  String? current,
}) {
  return showDialog<String>(
    context: context,
    barrierColor: const Color(0x66000000),
    builder: (dialogContext) {
      return _SearchPickerDialog(
        searchHint: searchHint,
        options: options,
        current: current,
      );
    },
  );
}

class _SearchPickerDialog extends StatefulWidget {
  const _SearchPickerDialog({
    required this.searchHint,
    required this.options,
    this.current,
  });

  final String searchHint;
  final List<String> options;
  final String? current;

  @override
  State<_SearchPickerDialog> createState() => _SearchPickerDialogState();
}

class _SearchPickerDialogState extends State<_SearchPickerDialog> {
  final _search = TextEditingController();
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List<String>.from(widget.options);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    final query = value.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? List<String>.from(widget.options)
          : widget.options
              .where((item) => item.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                children: [
                  const AppSvgIcon(AppIcons.bookingsSearch, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _search,
                      autofocus: true,
                      cursorColor: Colors.black,
                      cursorHeight: 14,
                      cursorWidth: 1.5,
                      onChanged: _onSearch,
                      style: AppTextStyles.plus(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: widget.searchHint,
                        hintStyle: AppTextStyles.plus(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE8E8EE)),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Color(0xFFE8E8EE),
                ),
                itemBuilder: (context, index) {
                  final option = _filtered[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppText(
                          option,
                          style: AppTextStyles.body,
                          size: 14,
                          color: AppColors.textPrimary,
                          weight: option == widget.current
                              ? FontWeight.w600
                              : FontWeight.w400,
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
    );
  }
}

Future<String?> showAffiliateStatusPicker(
  BuildContext context, {
  String? current,
}) {
  const options = ['Active', 'Inactive', 'None'];
  return showDialog<String>(
    context: context,
    barrierColor: const Color(0x66000000),
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: Color(0xFFE8E8EE)),
              InkWell(
                onTap: () => Navigator.of(dialogContext).pop(options[i]),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: AppText(
                      options[i],
                      style: AppTextStyles.body,
                      size: 14,
                      color: options[i] == 'Active'
                          ? _activeGreen
                          : AppColors.textPrimary,
                      weight: options[i] == current
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    },
  );
}
