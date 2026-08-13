import 'package:flutter/material.dart';

/// Soft fade + slight upward slide — matches typical Figma prototype dissolves.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required Widget page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.04, 0.02),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// Red wipe used between splash and onboarding in the Figma auth sequence.
class RedWipeRoute<T> extends PageRouteBuilder<T> {
  RedWipeRoute({required Widget page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 780),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (_, animation, __, child) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final t = Curves.easeInOutCubic.transform(animation.value);
                final coverWidth = t < 0.5 ? (t / 0.5) : 1.0;
                final redOpacity =
                    t < 0.5 ? 1.0 : (1 - ((t - 0.5) / 0.5)).clamp(0.0, 1.0);
                final childOpacity =
                    t < 0.42 ? 0.0 : ((t - 0.42) / 0.58).clamp(0.0, 1.0);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(opacity: childOpacity, child: child),
                    if (redOpacity > 0.01)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Opacity(
                          opacity: redOpacity,
                          child: FractionallySizedBox(
                            widthFactor: coverWidth.clamp(0.0, 1.0),
                            heightFactor: 1,
                            child: const ColoredBox(color: Color(0xFFFB4156)),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
}

class SheetUpRoute<T> extends PageRouteBuilder<T> {
  SheetUpRoute({required Widget page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 480),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}
