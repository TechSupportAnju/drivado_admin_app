import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/navigation/app_transitions.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:drivado_admin_app/features/events/domain/entities/event.dart';
import 'package:drivado_admin_app/features/events/domain/repositories/events_repository.dart';
import 'package:drivado_admin_app/features/events/presentation/pages/event_form_page.dart';
import 'package:drivado_admin_app/features/events/presentation/widgets/event_card.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/confirm_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Future<void> _openForm({EventItem? event}) async {
    final result = await Navigator.of(context).push<bool>(
      AppPageRoute(page: EventFormPage(event: event)),
    );
    if (result == true && mounted) setState(() {});
  }

  void _confirmDelete(EventItem event) {
    ConfirmActionDialog.show(
      context,
      icon: AppIcons.profileDelete,
      title: 'Delete this event?',
      message:
          '“${event.name}” will be removed. This action cannot be undone.',
      primaryLabel: 'Keep event',
      secondaryLabel: 'Delete',
      onPrimary: () => Navigator.of(context).pop(),
      onSecondary: () {
        Navigator.of(context).pop();
        context.read<EventsRepository>().delete(event.id);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = context.read<EventsRepository>().all();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: AppLayout.of(context).headerPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        customBorder: const CircleBorder(),
                        child: const AppSvgIcon(AppIcons.summaryBack, size: 40),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppText(
                            'Hello Sanjay',
                            align: TextAlign.right,
                            style: AppTextStyles.bodyStrong,
                            size: 14,
                            color: AppColors.textOnDark,
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            'test@drivado.com',
                            align: TextAlign.right,
                            style: AppTextStyles.caption,
                            size: 14,
                            color: const Color(0xFFF5F6FA),
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      const AppAvatar(radius: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () => _openForm(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnDark,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: AppText(
                        '+ Add Event',
                        style: AppTextStyles.button,
                        size: 16,
                        color: AppColors.textOnDark,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      AppText(
                        'Created Events',
                        style: AppTextStyles.subtitle,
                        size: 14,
                        color: const Color(0xFFADADAD),
                        weight: FontWeight.w500,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        constraints: const BoxConstraints(minWidth: 38),
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F3737),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: AppText(
                          '${items.length}',
                          style: AppTextStyles.chip,
                          size: 12,
                          color: AppColors.textOnDark,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AppRoundedSheet(
              color: const Color(0xFFF7F7F8),
              child: items.isEmpty
                  ? Center(
                      child: AppText(
                        'No events found',
                        style: AppTextStyles.body,
                        weight: FontWeight.w500,
                      ),
                    )
                  : AppContent(
                      child: ResponsiveCardList(
                        padding: AppLayout.of(context).scrollPadding(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final event = items[index];
                          return EventCard(
                            event: event,
                            onEdit: () => _openForm(event: event),
                            onDelete: () => _confirmDelete(event),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
