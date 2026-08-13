import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/features/profile/presentation/widgets/profile_headers.dart';
import 'package:flutter/material.dart';

class ProfileDocumentPage extends StatelessWidget {
  const ProfileDocumentPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ProfilePageHeader(
            title: title,
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AppText(
                  '$title will be available here soon.',
                  align: TextAlign.center,
                  style: AppTextStyles.bodyStrong,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
