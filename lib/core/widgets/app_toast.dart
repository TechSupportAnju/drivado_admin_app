import 'package:drivado_admin_app/core/theme/app_colors.dart';
import 'package:drivado_admin_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

const _toastBackground = Color(0xFF1C2A24);
const _toastAccent = Color(0xFF22C55E);
const _toastIconRing = Color(0xFF163A2A);

Future<void> showAppSuccessToast(
  BuildContext context, {
  required String title,
  required String message,
  Duration duration = const Duration(seconds: 3),
}) {
  return _showAppToast(
    context,
    title: title,
    message: message,
    duration: duration,
    waitForDismiss: true,
    isError: false,
  );
}

void showAppErrorToast(
  BuildContext context, {
  required String title,
  required String message,
  Duration duration = const Duration(seconds: 3),
}) {
  _showAppToast(
    context,
    title: title,
    message: message,
    duration: duration,
    waitForDismiss: false,
    isError: true,
  );
}

Future<void> _showAppToast(
  BuildContext context, {
  required String title,
  required String message,
  required Duration duration,
  required bool waitForDismiss,
  required bool isError,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _SuccessToastCard(
      title: title,
      message: message,
      duration: duration,
      isError: isError,
      onFinished: () {
        entry.remove();
      },
    ),
  );
  overlay.insert(entry);
  if (waitForDismiss) {
    return Future<void>.delayed(duration);
  }
  return Future<void>.value();
}

class _SuccessToastCard extends StatefulWidget {
  const _SuccessToastCard({
    required this.title,
    required this.message,
    required this.duration,
    required this.onFinished,
    this.isError = false,
  });

  final String title;
  final String message;
  final Duration duration;
  final VoidCallback onFinished;
  final bool isError;

  @override
  State<_SuccessToastCard> createState() => _SuccessToastCardState();
}

class _SuccessToastCardState extends State<_SuccessToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this, duration: widget.duration)
      ..forward().whenComplete(widget.onFinished);
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isError ? AppColors.primary : _toastAccent;
    final ring = widget.isError ? const Color(0xFF3A1616) : _toastIconRing;
    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: _toastBackground,
              elevation: 8,
              shadowColor: Colors.black54,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ring,
                              border: Border.all(color: accent, width: 1.6),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              widget.isError ? Icons.close : Icons.check,
                              size: 16,
                              color: accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: AppTextStyles.plus(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: widget.isError
                                        ? AppColors.textOnDark
                                        : _toastAccent,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.message,
                                  style: AppTextStyles.plus(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFE8E8E8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _progress,
                      builder: (context, _) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 1 - _progress.value,
                            child: ColoredBox(
                              color: accent,
                              child: SizedBox(
                                height: 4,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
