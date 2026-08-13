import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Keeps the Figma mobile frame (393) centered on wide web canvases.
class MobileFrame extends StatelessWidget {
  const MobileFrame({super.key, required this.child});

  final Widget child;

  static const double designWidth = 393;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= designWidth + 24) {
          return child;
        }
        return ColoredBox(
          color: const Color(0xFF111111),
          child: Center(
            child: Container(
              width: designWidth,
              height: constraints.maxHeight.clamp(0, 900),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 40,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
