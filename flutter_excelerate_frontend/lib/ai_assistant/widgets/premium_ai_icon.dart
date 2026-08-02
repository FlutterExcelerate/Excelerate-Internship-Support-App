import 'package:flutter/material.dart';

class PremiumAiIcon extends StatelessWidget {
  final double size;

  const PremiumAiIcon({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF80DEEA), // Soft teal light
            Color(0xFF00897B), // Soft teal dark
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.4),
          topRight: Radius.circular(size * 0.4),
          bottomLeft: Radius.circular(size * 0.4),
          bottomRight: Radius.circular(size * 0.1), // Chat bubble tail
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00897B).withValues(alpha: 0.2),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome, // Sparkles
          color: Colors.white,
          size: size * 0.55,
        ),
      ),
    );
  }
}


