import 'package:flutter/material.dart';

/// Exact U-curve side rail from `drivado_application` onboarding.
class OnboardingUPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const gradient = LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height / 1.4 - 65)
      ..arcToPoint(
        Offset(size.width - 20, size.height / 1.4 - 29),
        radius: const Radius.circular(50),
        clockwise: true,
      )
      ..quadraticBezierTo(
        size.width - 40,
        size.height / 1.4 - 10,
        size.width - 15,
        size.height / 1.4 + 10,
      )
      ..arcToPoint(
        Offset(size.width, size.height / 1.4 + 40),
        radius: const Radius.circular(40),
        clockwise: true,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
