import 'package:drivado_admin_app/core/session/session_store.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_system_ui.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Exact final onboarding screen from `drivado_application` (`OnboardNextPage`).
class PremiumIntroPage extends StatefulWidget {
  const PremiumIntroPage({super.key});

  @override
  State<PremiumIntroPage> createState() => _PremiumIntroPageState();
}

class _PremiumIntroPageState extends State<PremiumIntroPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(AppSystemUi.immersiveDark);
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/onbarding.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: AppText(
                    'Premium cars.\nEnjoy the luxury',
                    align: TextAlign.center,
                    color: Colors.white,
                    weight: FontWeight.w700,
                    size: 35,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: AppText(
                    'Premium and prestige limo daily rental.\nExperience the thrill at a lower price.',
                    align: TextAlign.center,
                    color: Colors.white,
                    weight: FontWeight.w300,
                    size: 15,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 45),
                GestureDetector(
                  onTap: () async {
                    await SessionStore.instance.completeOnboarding();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (_) => false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 480),
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppText(
                      "Let's Go",
                      style: AppTextStyles.button,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
