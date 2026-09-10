import 'package:flutter/material.dart';

/// Full-bleed shell. Previously locked the app to a 393px phone frame on web.
class MobileFrame extends StatelessWidget {
  const MobileFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
