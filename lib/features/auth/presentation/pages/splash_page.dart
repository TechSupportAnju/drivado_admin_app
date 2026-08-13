import 'package:drivado_admin_app/core/session/session_store.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/login_page.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/onboarding_page.dart';
import 'package:drivado_admin_app/features/home/presentation/pages/home_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    Future.delayed(const Duration(seconds: 2), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    final session = SessionStore.instance;
    final Widget next;
    if (session.isLoggedIn) {
      next = const HomeShellPage();
    } else if (session.isOnboarded) {
      next = const LoginPage();
    } else {
      onBoardingValue = 1;
      next = const OnboardingPage();
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 147,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
