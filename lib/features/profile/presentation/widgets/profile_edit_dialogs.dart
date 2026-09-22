import 'package:drivado_admin_app/core/country_code/country_code.dart';
import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/auth_widgets.dart';
import 'package:drivado_admin_app/core/widgets/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileEmergencyContact {
  const ProfileEmergencyContact({
    required this.region,
    required this.dialCode,
    required this.number,
  });

  final String region;
  final String dialCode;
  final String number;

  String get display => '($region) $dialCode $number';

  static final _pattern = RegExp(
    r'^\(([^)]+)\)\s*(\+\d+)\s*(.+)$',
  );

  static ProfileEmergencyContact parse(String raw) {
    final match = _pattern.firstMatch(raw.trim());
    if (match == null) {
      return ProfileEmergencyContact(
        region: 'IN',
        dialCode: '+91',
        number: raw.replaceAll(RegExp(r'\D'), ''),
      );
    }
    return ProfileEmergencyContact(
      region: match.group(1)!.trim(),
      dialCode: match.group(2)!.trim(),
      number: match.group(3)!.replaceAll(RegExp(r'\s+'), ' ').trim(),
    );
  }
}

Future<String?> showEditBookingTimeDialog(
  BuildContext context, {
  required String current,
}) {
  return _showProfileEditDialog<String>(
    context,
    builder: (pop) => _SingleValueEditor(
      title: 'Edit Booking Time',
      label: 'Booking time',
      icon: AppIcons.bookingsClock,
      initialValue: current.trim().isEmpty ? '24' : current,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onCancel: () => pop(null),
      onSave: (value) => pop(value),
    ),
  );
}

Future<String?> showEditNightPriceDialog(
  BuildContext context, {
  required String current,
}) {
  final empty = current.trim().isEmpty ||
      current.trim() == '--' ||
      current.trim() == '__';
  return _showProfileEditDialog<String>(
    context,
    builder: (pop) => _SingleValueEditor(
      title: 'Edit Night Price',
      label: 'Night search Price',
      icon: AppIcons.profileMoon,
      initialValue: empty ? '00' : current,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onCancel: () => pop(null),
      onSave: (value) => pop(value),
    ),
  );
}

Future<List<ProfileEmergencyContact>?> showEditEmergencyContactDialog(
  BuildContext context, {
  required List<ProfileEmergencyContact> contacts,
}) {
  return _showProfileEditDialog<List<ProfileEmergencyContact>>(
    context,
    builder: (pop) => _EmergencyContactEditor(
      contacts: contacts,
      onCancel: () => pop(null),
      onSave: pop,
    ),
  );
}

Future<T?> _showProfileEditDialog<T>(
  BuildContext context, {
  required Widget Function(void Function(T? value) pop) builder,
}) {
  return showDialog<T>(
    context: context,
    useRootNavigator: true,
    barrierColor: const Color(0x66000000),
    builder: (dialogContext) {
      return builder((value) => Navigator.of(dialogContext).pop(value));
    },
  );
}

class _SingleValueEditor extends StatefulWidget {
  const _SingleValueEditor({
    required this.title,
    required this.label,
    required this.icon,
    required this.initialValue,
    required this.onCancel,
    required this.onSave,
    this.keyboardType,
    this.inputFormatters,
  });

  final String title;
  final String label;
  final String icon;
  final String initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback onCancel;
  final ValueChanged<String> onSave;

  @override
  State<_SingleValueEditor> createState() => _SingleValueEditorState();
}

class _SingleValueEditorState extends State<_SingleValueEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileEditCard(
      title: widget.title,
      onCancel: widget.onCancel,
      onSave: () => widget.onSave(_controller.text.trim()),
      child: AuthTextField(
        hint: widget.label,
        label: widget.label,
        requiredMark: false,
        autofocus: true,
        controller: _controller,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        prefix: FieldPrefixIcon(widget.icon, size: 18),
      ),
    );
  }
}

class _EmergencyContactEditor extends StatefulWidget {
  const _EmergencyContactEditor({
    required this.contacts,
    required this.onCancel,
    required this.onSave,
  });

  final List<ProfileEmergencyContact> contacts;
  final VoidCallback onCancel;
  final ValueChanged<List<ProfileEmergencyContact>> onSave;

  @override
  State<_EmergencyContactEditor> createState() =>
      _EmergencyContactEditorState();
}

class _EmergencyContactEditorState extends State<_EmergencyContactEditor> {
  late final List<TextEditingController> _controllers;
  late final List<String> _dialCodes;
  late final List<String> _regions;

  @override
  void initState() {
    super.initState();
    final seeded = List<ProfileEmergencyContact>.from(widget.contacts);
    while (seeded.length < 3) {
      seeded.add(
        const ProfileEmergencyContact(
          region: 'IN',
          dialCode: '+91',
          number: '',
        ),
      );
    }
    _controllers = [
      for (final contact in seeded.take(3))
        TextEditingController(text: contact.number),
    ];
    _dialCodes = [for (final contact in seeded.take(3)) contact.dialCode];
    _regions = [for (final contact in seeded.take(3)) contact.region];
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _regionFor(String dialCode, String fallback) {
    final country = findCountryByDialCode(dialCode);
    if (country == null) return fallback;
    if (country.code == 'GB') return 'UK';
    return country.code;
  }

  void _save() {
    final next = <ProfileEmergencyContact>[];
    for (var i = 0; i < _controllers.length; i++) {
      final number = _controllers[i].text.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (number.isEmpty) continue;
      next.add(
        ProfileEmergencyContact(
          region: _regions[i],
          dialCode: _dialCodes[i],
          number: number,
        ),
      );
    }
    widget.onSave(next.isEmpty ? widget.contacts : next);
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileEditCard(
      title: 'Edit Emergency Contact',
      onCancel: widget.onCancel,
      onSave: _save,
      child: Column(
        children: [
          for (var i = 0; i < _controllers.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _EmergencyContactField(
              controller: _controllers[i],
              dialCode: _dialCodes[i],
              onDialCodeChanged: (code) {
                setState(() {
                  _dialCodes[i] = code;
                  _regions[i] = _regionFor(code, _regions[i]);
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _EmergencyContactField extends StatelessWidget {
  const _EmergencyContactField({
    required this.controller,
    required this.dialCode,
    required this.onDialCodeChanged,
  });

  final TextEditingController controller;
  final String dialCode;
  final ValueChanged<String> onDialCodeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14, right: 14, top: 3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          const AppSvgIcon(
            AppIcons.bookingsPhone,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              ],
              cursorColor: Colors.black,
              cursorHeight: 15,
              cursorWidth: 1.5,
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
                prefix: CountryCodePickerButton(
                  dialCode: dialCode,
                  onTap: () async {
                    final selected = await showCountryCodePicker(
                      context,
                      selectedDialCode: dialCode,
                    );
                    if (selected == null) return;
                    onDialCodeChanged(selected.dialCode);
                  },
                ),
                label: Text(
                  'Emergency Contact',
                  style: AppTextStyles.plus(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.fieldHintText,
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: AppTextStyles.plus(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.fieldHintText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileEditCard extends StatelessWidget {
  const _ProfileEditCard({
    required this.title,
    required this.child,
    required this.onCancel,
    required this.onSave,
  });

  final String title;
  final Widget child;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: AppTextStyles.subtitle,
                size: 16,
                weight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 16),
              child,
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor: AppColors.surface,
                        minimumSize: const Size.fromHeight(48),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: AppText(
                        'Cancel',
                        style: AppTextStyles.body,
                        size: 16,
                        weight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: onSave,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: AppText(
                        'Save',
                        style: AppTextStyles.body,
                        size: 16,
                        weight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
