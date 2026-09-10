import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/new_booking/domain/repositories/booking_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({
    super.key,
    required this.title,
    this.current,
  });

  final String title;
  final String? current;

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  late final TextEditingController _search;
  var _query = '';

  @override
  void initState() {
    super.initState();
    _search = TextEditingController(text: widget.current ?? '');
    _query = (widget.current ?? '').toLowerCase();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = context
        .read<BookingCatalogRepository>()
        .locations
        .where((item) => item.toLowerCase().contains(_query))
        .toList();
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.keyboard_backspace, color: Color(0xFF555555)),
        ),
        title: AppText(
          widget.title,
          style: AppTextStyles.subtitle,
          size: 18,
          weight: FontWeight.w600,
        ),
      ),
      body: AppContent(
        child: Column(
        children: [
          Padding(
            padding: AppLayout.of(context).scrollPadding(top: 8, bottom: 8),
            child: AppSearchField(
              controller: _search,
              hint: 'Search location',
              onChanged: (value) {
                setState(() => _query = value.trim().toLowerCase());
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final option = filtered[index];
                return ListTile(
                  leading: const AppSvgIcon(
                    AppIcons.bookingsSource,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  title: AppText(
                    option,
                    style: AppTextStyles.body,
                    size: 15,
                    color: option == widget.current
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    weight: option == widget.current
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  onTap: () => Navigator.of(context).pop(option),
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
