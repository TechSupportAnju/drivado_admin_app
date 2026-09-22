import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/layout/app_layout.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/widgets/common_ui.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryDark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppLayout.of(context).pageGutter,
            12,
            AppLayout.of(context).pageGutter,
            28,
          ),
          child: Row(
            children: [
              const AppAvatar(),
              const SizedBox(width: 12),
              Expanded(child: UserGreeting(name: name, email: email)),
              HeaderIconButton(
                asset: AppIcons.homeNotification,
                showDot: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
