import 'package:flutter/material.dart';

class PremiumAiIcon extends StatelessWidget {
  final double size;

  const PremiumAiIcon({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assetName = isDark ? 'assets/ai_icon/dark.png' : 'assets/ai_icon/light.png';

    return Image.asset(
      assetName,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}