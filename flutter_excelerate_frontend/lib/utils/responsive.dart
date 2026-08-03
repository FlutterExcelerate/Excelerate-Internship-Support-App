import 'package:flutter/material.dart';

/// Breakpoints tuned for phones, tablets, and larger screens.
class AppBreakpoints {
  static const double compact = 360;
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  bool get isCompact => screenWidth < AppBreakpoints.compact;

  bool get isMobile => screenWidth < AppBreakpoints.mobile;

  bool get isTablet =>
      screenWidth >= AppBreakpoints.mobile &&
      screenWidth < AppBreakpoints.tablet;

  bool get isDesktop => screenWidth >= AppBreakpoints.tablet;

  bool get isWide => screenWidth >= AppBreakpoints.mobile;

  double get contentMaxWidth {
    if (screenWidth >= AppBreakpoints.desktop) return 1080;
    if (screenWidth >= AppBreakpoints.tablet) return 920;
    return screenWidth;
  }

  double get dialogMaxWidth {
    if (isDesktop) return 520;
    if (isTablet) return 480;
    return screenWidth - 36;
  }

  double get dialogMaxHeight => screenHeight * 0.85;

  EdgeInsets get pagePadding {
    if (isDesktop) return const EdgeInsets.fromLTRB(28, 12, 28, 100);
    if (isTablet) return const EdgeInsets.fromLTRB(24, 10, 24, 100);
    if (isCompact) return const EdgeInsets.fromLTRB(14, 8, 14, 96);
    return const EdgeInsets.fromLTRB(20, 8, 20, 100);
  }

  EdgeInsets get screenPadding {
    if (isDesktop) return const EdgeInsets.all(28);
    if (isTablet) return const EdgeInsets.all(24);
    if (isCompact) return const EdgeInsets.all(14);
    return const EdgeInsets.all(20);
  }

  int get gridCrossAxisCount {
    if (screenWidth >= AppBreakpoints.desktop) return 4;
    if (screenWidth >= AppBreakpoints.tablet) return 3;
    if (screenWidth >= 480) return 2;
    return 1;
  }

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isWide && tablet != null) return tablet;
    return mobile;
  }
}

/// Clamps text scaling so layouts stay readable on very small or large devices.
class ResponsiveAppBuilder extends StatelessWidget {
  const ResponsiveAppBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final scaleFactor = (width / 390).clamp(0.92, 1.08);
    final currentScale = mediaQuery.textScaler.scale(1);
    final clampedScale = (currentScale * scaleFactor).clamp(0.85, 1.15);

    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: TextScaler.linear(clampedScale),
      ),
      child: child,
    );
  }
}

/// Adapts a child between single-column and multi-column layouts.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.breakpoint = AppBreakpoints.mobile,
    this.tabletBreakpoint = AppBreakpoints.tablet,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double breakpoint;
  final double tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= tabletBreakpoint && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= breakpoint && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
