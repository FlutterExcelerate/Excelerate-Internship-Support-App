import 'package:flutter/material.dart';
import 'dart:math' as math;

class AiTypingIndicator extends StatefulWidget {
  const AiTypingIndicator({super.key});

  @override
  State<AiTypingIndicator> createState() => _AiTypingIndicatorState();
}

class _AiTypingIndicatorState extends State<AiTypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(controller: _controller, delay: 0.0),
            const SizedBox(width: 6),
            _Dot(controller: _controller, delay: 0.2),
            const SizedBox(width: 6),
            _Dot(controller: _controller, delay: 0.4),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const _Dot({
    required this.controller,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double t = (controller.value - delay);
        final double normalizedT = t < 0 ? t + 1.0 : t;
        double y = 0.0;
        double opacity = 0.4;

        if (normalizedT >= 0 && normalizedT < 0.4) {
          final double progress = normalizedT / 0.4;
          y = -4.0 * math.sin(progress * math.pi);
          opacity = 0.4 + 0.6 * math.sin(progress * math.pi);
        }

        return Transform.translate(
          offset: Offset(0, y),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}