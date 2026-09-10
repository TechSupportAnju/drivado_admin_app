import 'package:flutter/material.dart';

/// Window size classes used to adapt layout without per-page MediaQuery math.
enum AppWindowSize { compact, medium, expanded }

class AppLayout {
  const AppLayout._(this.size);

  factory AppLayout.of(BuildContext context) {
    return AppLayout._(MediaQuery.sizeOf(context));
  }

  final Size size;

  double get width => size.width;
  double get height => size.height;

  static const double compactMax = 600;
  static const double mediumMax = 1024;

  AppWindowSize get windowSize {
    if (width >= mediumMax) return AppWindowSize.expanded;
    if (width >= compactMax) return AppWindowSize.medium;
    return AppWindowSize.compact;
  }

  bool get isCompact => windowSize == AppWindowSize.compact;
  bool get isMedium => windowSize == AppWindowSize.medium;
  bool get isExpanded => windowSize == AppWindowSize.expanded;

  /// Max width for list/dashboard content on tablet and desktop.
  double get contentMaxWidth {
    switch (windowSize) {
      case AppWindowSize.expanded:
        return 1120;
      case AppWindowSize.medium:
        return 840;
      case AppWindowSize.compact:
        return double.infinity;
    }
  }

  /// Narrower cap for auth and data-entry forms.
  double get formMaxWidth {
    if (isCompact) return double.infinity;
    return 560;
  }

  int get cardColumns {
    if (width >= 1200) return 3;
    if (width >= 700) return 2;
    return 1;
  }

  double get pageGutter {
    if (isExpanded) return 32;
    if (isMedium) return 24;
    return 16;
  }

  EdgeInsets scrollPadding({
    double top = 16,
    double bottom = 24,
  }) {
    final gutter = pageGutter;
    return EdgeInsets.fromLTRB(gutter, top, gutter, bottom);
  }

  EdgeInsets get headerPadding =>
      EdgeInsets.fromLTRB(pageGutter, 8, pageGutter, 16);

  double sheetHeight([double fraction = 0.9]) {
    return height * fraction.clamp(0.45, 0.95);
  }

  double get authHeaderHeight => (height * 0.28).clamp(180.0, 280.0);
}

/// Centers [child] and caps its width for large screens.
class AppContent extends StatelessWidget {
  const AppContent({
    super.key,
    required this.child,
    this.maxWidth,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double? maxWidth;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final layout = AppLayout.of(context);
    final cap = maxWidth ?? layout.contentMaxWidth;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final width = maxW.isFinite ? maxW.clamp(0, cap).toDouble() : cap;
        return Align(
          alignment: alignment,
          child: SizedBox(
            width: width == double.infinity ? null : width,
            height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
            child: child,
          ),
        );
      },
    );
  }
}

/// Variable-height card grid: 1 column on phones, 2–3 on larger screens.
class ResponsiveCardList extends StatelessWidget {
  const ResponsiveCardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.spacing = 12,
    this.physics,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final layout = AppLayout.of(context);
    final columns = layout.cardColumns;
    final resolvedPadding = padding ?? layout.scrollPadding();

    if (columns == 1) {
      return ListView.separated(
        padding: resolvedPadding,
        physics: physics,
        shrinkWrap: shrinkWrap,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: spacing),
        itemBuilder: itemBuilder,
      );
    }

    final rows = (itemCount / columns).ceil();
    return ListView.separated(
      padding: resolvedPadding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: rows,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (context, row) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var col = 0; col < columns; col++) ...[
                if (col > 0) SizedBox(width: spacing),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final index = row * columns + col;
                      if (index >= itemCount) {
                        return const SizedBox.shrink();
                      }
                      return itemBuilder(context, index);
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
