import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

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
    final pill = Container(
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
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
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
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: child,
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

class _NavItem {
  const _NavItem(this.selectedIcon, this.icon, this.label);
  final IconData selectedIcon;
  final IconData icon;
  final String label;
}

class FloatingGlassNavBar extends StatefulWidget {
  const FloatingGlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<FloatingGlassNavBar> createState() => _FloatingGlassNavBarState();
}

class _FloatingGlassNavBarState extends State<FloatingGlassNavBar>
    with SingleTickerProviderStateMixin {
  static const _items = [
    _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
    _NavItem(Icons.grid_view_rounded, Icons.grid_view_outlined, 'Programs'),
    _NavItem(Icons.mail_rounded, Icons.mail_outline_rounded, 'Messages'),
    _NavItem(Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
  ];

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
      _pillController
        ..reset()
        ..forward();
      _previousIndex = oldWidget.selectedIndex;
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

    return Container(
      height: 78,
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final slotWidth = totalWidth / _items.length;

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
                            final stretch = (travel * 12).clamp(0.0, 24.0);
                            final pillWidth = slotWidth - 16 + stretch;
                            final adjustedLeft = pillLeft - stretch / 2 + 8;

                            return Positioned(
                              left: adjustedLeft,
                              top: 0,
                              bottom: 0,
                              width: pillWidth,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: pillColor,
                                  borderRadius: BorderRadius.circular(26),
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
                          children: List.generate(_items.length, (index) {
                            final item = _items[index];
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
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                          ),
                                          child: Icon(
                                            isSelected
                                                ? item.selectedIcon
                                                : item.icon,
                                            key: ValueKey(
                                              '${index}_$isSelected',
                                            ),
                                            color: isSelected
                                                ? activeColor
                                                : inactiveColor,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 5,
                                        ),
                                        child: Text(
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
