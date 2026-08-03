import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

void disposeTextControllersAfterFrame(
  Iterable<TextEditingController> controllers,
) {
  final controllersToDispose = List<TextEditingController>.of(controllers);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    for (final controller in controllersToDispose) {
      controller.dispose();
    }
  });
}

class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final card = Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0x00000000)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: widget.padding, child: widget.child),
    );

    if (widget.onTap == null) {
      return card;
    }

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        Feedback.forTap(context);
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      onTap: widget.onTap,
      child: ScaleTransition(scale: _scaleAnimation, child: card),
    );
  }
}

class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final card = Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF151D30).withValues(alpha: 0.7)
            : const Color(0xFFFFFFFF).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? const Color(0xFFF8FAFC).withValues(alpha: 0.08)
              : const Color(0xFF0F172A).withValues(alpha: 0.06),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0x00000000)
                : const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(padding: widget.padding, child: widget.child),
        ),
      ),
    );

    if (widget.onTap == null) {
      return card;
    }

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        Feedback.forTap(context);
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      onTap: widget.onTap,
      child: ScaleTransition(scale: _scaleAnimation, child: card),
    );
  }
}

class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 48,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final maxPillWidth = (context.screenWidth - 48).clamp(120.0, 320.0);
    final pill = Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxPillWidth),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return pill;
    }

    return InkWell(
      onTap: () {
        Feedback.forTap(context);
        onTap!();
      },
      borderRadius: BorderRadius.circular(999),
      child: pill,
    );
  }
}

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final maxWidth = context.contentMaxWidth;

    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CircularProgressRing extends StatefulWidget {
  const CircularProgressRing({
    super.key,
    required this.progress,
    required this.color,
    this.size = 64,
    this.strokeWidth = 6.0,
  });

  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;

  @override
  State<CircularProgressRing> createState() => _CircularProgressRingState();
}

class _CircularProgressRingState extends State<CircularProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CircularProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: _animation.value, end: widget.progress)
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackColor = theme.brightness == Brightness.light
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF1E293B);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _CircularProgressPainter(
            progress: _animation.value,
            color: widget.color,
            trackColor: trackColor,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = 2 * 3.141592653589793 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class GradientBlobBackground extends StatelessWidget {
  const GradientBlobBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _BlobPainter(
              color1: theme.colorScheme.primary.withValues(
                alpha: isDark ? 0.16 : 0.08,
              ),
              color2: theme.colorScheme.secondary.withValues(
                alpha: isDark ? 0.12 : 0.06,
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({required this.color1, required this.color2});

  final Color color1;
  final Color color2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    final paint2 = Paint()
      ..color = color2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.1),
      size.width * 0.45,
      paint1,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.35),
      size.width * 0.5,
      paint2,
    );

    if (size.width > 600) {
      canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.85),
        size.width * 0.3,
        paint2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) {
    return oldDelegate.color1 != color1 || oldDelegate.color2 != color2;
  }
}

class GlassNavDestination {
  const GlassNavDestination({
    required this.selectedIcon,
    required this.icon,
    required this.label,
  });

  final IconData selectedIcon;
  final IconData icon;
  final String label;
}

class FloatingGlassNavBar extends StatefulWidget {
  const FloatingGlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.destinations = _defaultDestinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<GlassNavDestination> destinations;

  static const _defaultDestinations = [
    GlassNavDestination(
      selectedIcon: Icons.home_rounded,
      icon: Icons.home_outlined,
      label: 'Home',
    ),
    GlassNavDestination(
      selectedIcon: Icons.grid_view_rounded,
      icon: Icons.grid_view_outlined,
      label: 'Programs',
    ),
    GlassNavDestination(
      selectedIcon: Icons.mail_rounded,
      icon: Icons.mail_outline_rounded,
      label: 'Messages',
    ),
    GlassNavDestination(
      selectedIcon: Icons.person_rounded,
      icon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  @override
  State<FloatingGlassNavBar> createState() => _FloatingGlassNavBarState();
}

class _FloatingGlassNavBarState extends State<FloatingGlassNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pillController;
  late Animation<double> _pillPosition;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.selectedIndex;
    _pillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _pillPosition =
        Tween<double>(
          begin: widget.selectedIndex.toDouble(),
          end: widget.selectedIndex.toDouble(),
        ).animate(
          CurvedAnimation(parent: _pillController, curve: Curves.easeOutExpo),
        );
  }

  @override
  void didUpdateWidget(FloatingGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _pillPosition =
          Tween<double>(
            begin: _pillPosition.value,
            end: widget.selectedIndex.toDouble(),
          ).animate(
            CurvedAnimation(parent: _pillController, curve: Curves.easeOutExpo),
          );
      _previousIndex = oldWidget.selectedIndex;
      _pillController
        ..reset()
        ..forward().whenComplete(() {
          if (mounted) {
            setState(() => _previousIndex = widget.selectedIndex);
          }
        });
    }
  }

  @override
  void dispose() {
    _pillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final pillColor = isDark
        ? const Color(0xFFFFFFFF).withValues(alpha: 0.10)
        : theme.colorScheme.primary.withValues(alpha: 0.12);
    final pillBorderColor = isDark
        ? const Color(0xFFFFFFFF).withValues(alpha: 0.14)
        : theme.colorScheme.primary.withValues(alpha: 0.18);
    final items = widget.destinations;
    final navHeight = context.isCompact ? 68.0 : 76.0;

    return Container(
      height: navHeight,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF111827).withValues(alpha: 0.55)
            : const Color(0xFFFFFFFF).withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(
          color: isDark
              ? const Color(0xFFF8FAFC).withValues(alpha: 0.09)
              : const Color(0xFF0F172A).withValues(alpha: 0.07),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF000000,
            ).withValues(alpha: isDark ? 0.40 : 0.10),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final slotWidth = totalWidth / items.length;

                return AnimatedBuilder(
                  animation: _pillPosition,
                  builder: (context, _) {
                    final pillLeft = _pillPosition.value * slotWidth;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedBuilder(
                          animation: _pillPosition,
                          builder: (context, __) {
                            final travel =
                                (_pillPosition.value - _previousIndex).abs();
                            final decay = 1 - _pillController.value;
                            final stretch = (travel * 10 * decay).clamp(
                              0.0,
                              18.0,
                            );
                            final pillWidth = slotWidth - 10 + stretch;
                            final adjustedLeft = pillLeft - stretch / 2 + 5;

                            return Positioned(
                              left: adjustedLeft,
                              top: 4,
                              bottom: 4,
                              width: pillWidth,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: pillColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: pillBorderColor,
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark
                                          ? const Color(
                                              0xFF000000,
                                            ).withValues(alpha: 0.25)
                                          : theme.colorScheme.primary
                                                .withValues(alpha: 0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                          children: List.generate(items.length, (index) {
                            final item = items[index];
                            final isSelected = widget.selectedIndex == index;
                            final activeColor = isDark
                                ? Colors.white
                                : theme.colorScheme.primary;
                            final inactiveColor = isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B);
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Feedback.forTap(context);
                                  widget.onDestinationSelected(index);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: SizedBox(
                                  height: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 260,
                                        ),
                                        switchInCurve: Curves.easeOutBack,
                                        switchOutCurve: Curves.easeIn,
                                        transitionBuilder: (child, anim) =>
                                            ScaleTransition(
                                              scale: anim,
                                              child: FadeTransition(
                                                opacity: anim,
                                                child: child,
                                              ),
                                            ),
                                        child: Icon(
                                          isSelected
                                              ? item.selectedIcon
                                              : item.icon,
                                          key: ValueKey('${index}_$isSelected'),
                                          color: isSelected
                                              ? activeColor
                                              : inactiveColor,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.label,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: isSelected
                                              ? activeColor
                                              : inactiveColor,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          fontSize: 10.5,
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({super.key});

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Theme.of(context).brightness == Brightness.dark) {
        _controller.value = 1.0;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    final currentTheme = LearnifyApp.themeNotifier.value;
    final isDark =
        currentTheme == ThemeMode.dark ||
        (currentTheme == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    Feedback.forTap(context);
    if (isDark) {
      _controller.reverse();
      LearnifyApp.themeNotifier.value = ThemeMode.light;
    } else {
      _controller.forward();
      LearnifyApp.themeNotifier.value = ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: _toggleTheme,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E293B).withValues(alpha: 0.6)
              : const Color(0xFFF1F5F9),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? const Color(0xFFF8FAFC).withValues(alpha: 0.08)
                : const Color(0xFF0F172A).withValues(alpha: 0.06),
            width: 1.2,
          ),
        ),
        child: Center(
          child: RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 0.5).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: isDark
                  ? Icon(
                      Icons.dark_mode_rounded,
                      key: const ValueKey('dark_icon'),
                      color: theme.colorScheme.primary,
                      size: 20,
                    )
                  : Icon(
                      Icons.light_mode_rounded,
                      key: const ValueKey('light_icon'),
                      color: theme.colorScheme.secondary,
                      size: 20,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class LearnifyDialogShell extends StatelessWidget {
  const LearnifyDialogShell({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.subtitle,
    this.isPrimaryLoading = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Widget child;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final bool isPrimaryLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dialogMaxWidth = context.dialogMaxWidth;
    final keyboardInset = context.viewInsets.bottom;
    final usableHeight =
        context.screenHeight -
        context.viewPadding.vertical -
        keyboardInset -
        32;
    final dialogMaxHeight = usableHeight.clamp(280.0, context.dialogMaxHeight);
    final horizontalInset = context.isCompact ? 12.0 : 18.0;
    final shellPadding = context.isCompact ? 16.0 : 22.0;
    final footerAsColumn = context.screenWidth < 380;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: horizontalInset,
          vertical: context.viewPadding.top > 0 ? 16 : 24,
        ),
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogMaxWidth,
            maxHeight: dialogMaxHeight,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Material(
              color: isDark ? const Color(0xFF101827) : const Color(0xFFF6FAF8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      shellPadding,
                      shellPadding,
                      shellPadding - 4,
                      12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconBadge(
                          icon: icon,
                          color: color,
                          size: context.isCompact ? 42 : 48,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.headlineMedium,
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subtitle!,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        shellPadding,
                        8,
                        shellPadding,
                        12,
                      ),
                      child: child,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      shellPadding,
                      14,
                      shellPadding,
                      shellPadding,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0B1220).withValues(alpha: 0.72)
                          : Colors.white.withValues(alpha: 0.72),
                      border: Border(
                        top: BorderSide(
                          color: isDark
                              ? LearnifyColors.borderDark
                              : LearnifyColors.borderLight,
                        ),
                      ),
                    ),
                    child: footerAsColumn
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _footerActions(context).first,
                              const SizedBox(height: 12),
                              _footerActions(context).last,
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: _footerActions(context).first),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: _footerActions(context).last,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _footerActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton.icon(
        onPressed: isPrimaryLoading ? null : onPrimaryPressed,
        icon: isPrimaryLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check_rounded),
        label: Text(primaryLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    ];
  }
}

class ResponsiveActionRow extends StatelessWidget {
  const ResponsiveActionRow({
    super.key,
    required this.children,
    this.spacing = 12,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (context.screenWidth < 380) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) SizedBox(height: spacing),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }
}

class ResponsiveHeaderRow extends StatelessWidget {
  const ResponsiveHeaderRow({
    super.key,
    required this.icon,
    required this.color,
    required this.child,
    this.trailing,
    this.iconSize = 48,
    this.spacing = 14,
  });

  final IconData icon;
  final Color color;
  final Widget child;
  final Widget? trailing;
  final double iconSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final badge = IconBadge(
      icon: icon,
      color: color,
      size: context.isCompact ? iconSize - 6 : iconSize,
    );

    if (context.screenWidth < 340) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              badge,
              if (trailing != null) ...[const Spacer(), trailing!],
            ],
          ),
          SizedBox(height: spacing),
          child,
        ],
      );
    }

    return Row(
      children: [
        badge,
        SizedBox(width: spacing),
        Expanded(child: child),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}

class LearnifyDialogField extends StatelessWidget {
  const LearnifyDialogField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.errorText,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMultiline = maxLines > 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: isMultiline
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  maxLines: maxLines,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    errorText: errorText,
                    hintText: 'Enter $label…',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : TextField(
              controller: controller,
              maxLines: 1,
              keyboardType: keyboardType,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: label,
                errorText: errorText,
                prefixIcon: Icon(icon),
              ),
            ),
    );
  }
}
