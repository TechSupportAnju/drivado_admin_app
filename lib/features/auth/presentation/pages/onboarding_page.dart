import 'package:drivado_admin_app/core/icons/app_icons.dart';
import 'package:drivado_admin_app/core/session/session_store.dart';
import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:drivado_admin_app/core/widgets/app_svg_icon.dart';
import 'package:drivado_admin_app/core/widgets/app_text.dart';
import 'package:drivado_admin_app/core/widgets/mobile_frame.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/premium_intro_page.dart';
import 'package:drivado_admin_app/features/auth/presentation/widgets/onboarding_u_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

/// Matches `drivado_application` onboarding step counter + route stacking.
int onBoardingValue = 1;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  bool isSwipe = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.initState();
  }

  Future<void> _openPremiumIntro({required Duration duration}) async {
    await SessionStore.instance.completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).push(
      SwipeablePageRoute(
        transitionDuration: duration,
        canOnlySwipeFromEdge: true,
        builder: (BuildContext context) => const PremiumIntroPage(),
      ),
    );
  }

  void _onVerticalSwipe() {
    setState(() => isSwipe = true);
    onBoardingValue = onBoardingValue + 1;
    if (onBoardingValue == 3) {
      _openPremiumIntro(duration: const Duration(seconds: 1));
    } else {
      Navigator.of(context).push(
        SwipeablePageRoute(
          transitionDuration: const Duration(seconds: 1),
          canOnlySwipeFromEdge: true,
          builder: (BuildContext context) => const OnboardingPage(),
        ),
      );
    }
  }

  void _onSkip() {
    _openPremiumIntro(duration: const Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return MobileFrame(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: isSwipe
              ? Container()
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  CustomPaint(
                                    size: Size(
                                      MediaQuery.of(context).size.width - 20,
                                      MediaQuery.of(context).size.height,
                                    ),
                                    painter: OnboardingUPainter(),
                                  ),
                                  Positioned(
                                    height:
                                        MediaQuery.of(context).size.height /
                                            1.7,
                                    bottom: 5,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {},
                                      onVerticalDragStart: (_) =>
                                          _onVerticalSwipe(),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                          top: 0,
                                          right: 0,
                                        ),
                                        child: _SwipeIcon(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 20,
                              height:
                                  MediaQuery.of(context).size.height / 1.8,
                              color: Colors.white,
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  onBoardingValue == 1
                                      ? 'assets/images/on.png'
                                      : 'assets/images/on2.png',
                                  height: 266,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    height: MediaQuery.of(context).size.height /
                                        2.9,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              AppText(
                                                onBoardingValue == 1
                                                    ? 'Request a Ride'
                                                    : 'Choose your vehicle',
                                                color: Colors.black,
                                                weight: FontWeight.w600,
                                                size: screenWidth * 0.075,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: AppText(
                                                  onBoardingValue == 1
                                                      ? 'Select Pick-up and drop-off location and search for available car categories.'
                                                      : 'Select from available category of cars based on your requirement with all inclusive prices (no hidden charges). ',
                                                  color: Colors.black,
                                                  size: 16,
                                                  height: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 11),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: _onSkip,
                                                child: Container(
                                                  height: 36,
                                                  width: 120,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      50,
                                                    ),
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xFF555555,
                                                      ),
                                                    ),
                                                  ),
                                                  child: AppText(
                                                    'Skip',
                                                    style: AppTextStyles.bodyStrong,
                                                    color: AppColors.textLabel,
                                                    size: 14,
                                                    height: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      bottom: 15,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height:
                                              onBoardingValue == 1 ? 35 : 6,
                                          width: 6,
                                          decoration: BoxDecoration(
                                            color: onBoardingValue == 1
                                                ? AppColors.primary
                                                : const Color(0xFFDBDBDB),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        Container(
                                          height:
                                              onBoardingValue == 1 ? 6 : 35,
                                          width: 6,
                                          decoration: BoxDecoration(
                                            color: onBoardingValue == 1
                                                ? const Color(0xFFDBDBDB)
                                                : AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        Container(
                                          height: 6,
                                          width: 6,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDBDBDB),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        const SizedBox(height: 21),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width - 20,
                                height:
                                    MediaQuery.of(context).size.height / 9,
                                color: Colors.white,
                              ),
                            ),
                          ],
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

class _SwipeIcon extends StatelessWidget {
  const _SwipeIcon();

  @override
  Widget build(BuildContext context) {
    return const AppSvgIcon(AppIcons.commonSwipe, size: 35);
  }
}
